":" ; exec sbcl --noinform --non-interactive --load "$0" "$@"

(load "setup.lisp")
(in-package #:qlt-user)

(flet ((fail (&rest messages)
	 (format *error-output* "~{~A~^ ~}~%" messages)
	 (sb-ext:exit :code 1)))
  (let ((args sb-ext:*posix-argv*))
    (unless (second args)
      (fail "Usage: run-test.sh TEST-FILE"))
    (let ((test-file (second args)))
      (unless (probe-file test-file)
	(fail "Test file " test-file " not found")))))

(qlt-load-test-file (merge-pathnames (second sb-ext:*posix-argv*)))
