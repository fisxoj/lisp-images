(defun install-quicklisp-version (version-string &key (replace t))
  (let* ((versions (ql-dist:available-versions (ql-dist:find-dist "quicklisp")))
	 (desired-version (assoc version-string versions :test #'string-equal)))
    (if desired-version
	(ql-dist:install-dist (cdr desired-version) :prompt nil :replace replace))))

(install-quicklisp-version (uiop:getenv "QUICKLISP_DIST"))
