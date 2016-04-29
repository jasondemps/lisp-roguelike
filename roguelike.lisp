;;;; roguelike.lisp

(in-package #:roguelike)

;;; "roguelike" goes here. Hacks and glory await!

;; (sdl:with-init ()
;;   (sdl:window 320 240)
;;   (sdl:draw-surface (sdl:load-image "image.png"))
;;   (sdl:update-display)
;;     (sdl:with-events ()
;;       (:quit-event () t)
;;       (:video-expose-event () (sdl:update-display))))

(defparameter *random-color* sdl:*white*)
(defun mouse-rect-2d ()
  (sdl:with-init ()
    (sdl:window 200 200 :title-caption "Move a rectangle using the mouse")
    (setf (sdl:frame-rate) 60)

    (sdl:with-events ()
      (:quit-event () t)
      (:key-down-event ()
                       (sdl:push-quit-event))
      (:idle ()
             (update-swank)
             ;; Change color of box if left mouse button pressed.
             (when (sdl:mouse-left-p)
               (setf *random-color* (sdl:color :r (random 255) :g (random 255) :b (random 255))))

             ;; Clear display each game loop
             (sdl:clear-display sdl:*black*)

             ;; Draw the box having a center at mouse xy
             (sdl:draw-box (sdl:rectangle-from-midpoint-* (sdl:mouse-x) (sdl:mouse-y) 20 20)
                           :color *random-color*)

             ;; Redraw the display
             (sdl:update-display)))))

(defmacro continuable (&body body)
  "Helper macro that we can use to allow us to continue from an
error. Remember to hit C in slime or pick the restart so errors don't kill the app."
  `(restart-case (progn ,@body) (continue () :report "Continue")))

(defun update-swank ()
  "Called from within the main loop, this keep the lisp repl
working while cepl runs"
  (continuable (let ((connection (or swank::*emacs-connection* (swank::default-connection)))) (when connection
                                                                                                (swank::handle-requests connection t)))))


;;; Separate, testing hot loading in SBCL with threads!
(defun update (i)
  (+ i 2))

(defun hot-patch ()
   (loop for i = 0 then (update i) do
        (format t "~&i = ~d~%" i)
        (fresh-line)
        (sleep 5)))

;;;; Start thread with:
;;;; (defparmater *thread* (sb-thread:make-thread #'hot-patch))

;;;; Can change update and recompile to see effect (in inferior lisp).

;;;; Stop thread with:
;;;; (sb-thread:terminate-thread *thread*)

