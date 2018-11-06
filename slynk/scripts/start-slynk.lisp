(ql:quickload :slynk)

;; Disable slynk's secondary output connection so we only
;; use one port out of the container

(setf slynk:*use-dedicated-output-stream* nil)

(slynk:create-server :port 4008
		     :interface "0.0.0.0"
		     :dont-close t)

;; Kill time until the user is done ;)
(loop (sleep 10))
