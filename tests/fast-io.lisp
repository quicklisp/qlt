'(:requires ("fast-io"))

;;; Adapted from https://github.com/rpav/fast-io/issues/21

(defun broken (file-path)
  (with-open-file (fin file-path
		       :direction :input
		       :element-type '(unsigned-byte 8)
		       :if-does-not-exist :error)
    (fast-io:with-fast-input (fin-fast
			      (make-array 0 :element-type '(unsigned-byte 8))
			      fin)
      (let* ((seq (make-array 10 :element-type '(unsigned-byte 8)
			      :initial-element 0))
	     (octets-read (fast-io:fast-read-sequence seq fin-fast 0 1)))
	(unless (eql octets-read 1)
	  (error "Read ~A bytes using fast-read-sequence, ~
                  but it should have been 1.~%"
		 octets-read))))))

(broken *load-truename*)
