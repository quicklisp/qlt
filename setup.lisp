(require 'asdf)
(require 'sb-posix)

(defpackage #:qlt-user
  (:use #:cl)
  (:export #:qlt-load-test-file
           #:qlt-setup-asdf
           #:*scratch-directory*))

(in-package #:qlt-user)

(defvar *scratch-directory*)

(defun qlt-make-system-search-function (index-file)
  (let ((table (make-hash-table :test 'equal)))
    (with-open-file (stream index-file)
      (loop for system-file = (read-line stream nil)
         while system-file do
           (setf (gethash (pathname-name system-file) table)
                 (merge-pathnames system-file index-file))))
    (lambda (system-name)
      (values (gethash system-name table)))))

(defun qlt-setup-asdf (build-directory)
  (let ((index-file (merge-pathnames "system-file-index"
                                     build-directory)))
    (push (qlt-make-system-search-function index-file)
          asdf:*system-definition-search-functions*)))

(defun qlt-load-prerequisites (source-file)
  (with-open-file (stream source-file)
    (let ((plist (read stream)))
      (when (and (consp plist)
                 (eql (car plist) 'quote))
        (setf plist (cadr plist))
        (let ((required-systems (getf plist :requires)))
          (dolist (system required-systems)
            (asdf:load-system system)))))))

(defun qlt-ensure-scratch-directory ()
  (flet ((random-pathname-character ()
           (aref "abcdefghijklmnopqrstuvwxyz0123456789"
                 (random 36))))
    (let* ((base (make-pathname :name nil
				:type nil
				:defaults #.(or *compile-file-truename*
						*load-truename*)))
           (pid (sb-posix:getpid))
           (token (map-into (make-string 8) #'random-pathname-character))
           (subdirectory (format nil "~A-~A" pid token))
           (subpath
            (make-pathname :directory (list :relative "tmp" subdirectory )))
           (path
            (merge-pathnames subpath base)))
      (ensure-directories-exist path))))

(defun qlt-load-test-file (file)
  (let* ((*package* (find-package '#:qlt-user))
	 (*default-pathname-defaults*
	  (make-pathname :name nil
			 :type nil
			 :defaults file))
	 (scratch (qlt-ensure-scratch-directory))
	 (*scratch-directory* (merge-pathnames "scratch/" scratch))
	 (fasl (merge-pathnames "fasls/" scratch)))
    (asdf:clear-output-translations)
    (asdf:initialize-output-translations
     `(:output-translations
       (t ,(merge-pathnames #P "**/*.*" fasl))
       :ignore-inherited-configuration
       :disable-cache))
    (qlt-load-prerequisites file)
    (load file)))
