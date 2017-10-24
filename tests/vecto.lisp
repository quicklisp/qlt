'(:requires ("vecto"))

(in-package #:vecto)

(with-canvas (:width 100 :height 100)
  (move-to 0 0)
  (line-to 50 50)
  (stroke)
  (let ((output (merge-pathnames "output/x.png" qlt-user:*scratch-directory*)))
    (ensure-directories-exist output)
    (save-png output)))
