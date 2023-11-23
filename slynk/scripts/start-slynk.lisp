(ql:quickload '(:slynk :trivial-signal))

;; largely from https://github.com/fukamachi/psychiq/blob/master/roswell/psychiq.ros

(defmacro with-handle-interrupt (int-handler &body body)
  (let ((main (gensym "MAIN")))
    `(flet ((,main () ,@body))
       #+(or sbcl ccl clisp allegro ecl)
       (handler-case
           (let (#+ccl (ccl:*break-hook* (lambda (condition hook)
                                           (declare (ignore hook))
                                           (error condition))))
             (,main))
         (#+sbcl sb-sys:interactive-interrupt
          #+ccl  ccl:interrupt-signal-condition
          #+clisp system::simple-interrupt-condition
          #+ecl ext:interactive-interrupt
          #+allegro excl:interrupt-signal
          ()
           (funcall ,int-handler)))
       #-(or sbcl ccl clisp allegro ecl)
       (,main))))


(let ((slynk-interface (or (uiop:getenv "SLYNK_INTERFACE") "0.0.0.0"))
      (slynk-output-port (or (uiop:getenv "SLYNK_OUTPUT_PORT") 4009))
      (slynk-port (or (uiop:getenv "SLYNK_PORT") 4008)))
  ;; Set slynk up to use set port for its output stream so it's a port
  ;; we know instead of a random one.
  (setf slynk:*use-dedicated-output-stream* t
        slynk:*loopback-interface* slynk-interface
        slynk:*dedicated-output-stream-port* slynk-output-port)

  (slynk:create-server :port slynk-port
                       :dont-close t)

  (let ((should-shutdown nil))
    (flet ((handle-signal (signo)
             (format uiop:*stderr*
                     "Got signal ~S, shutting down."
                     (trivial-signal:signal-name signo))
             (setf should-shutdown t)))
      (setf (trivial-signal:signal-handler :term) #'handle-signal)
      (setf (trivial-signal:signal-handler :int)  #'handle-signal)
      (with-handle-interrupt (lambda () (handle-signal trivial-signal:+sigint+))
        (loop :until should-shutdown
              :do (sleep 2)
              :finally (uiop:quit 0))))))
