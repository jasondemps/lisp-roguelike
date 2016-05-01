;;;; roguelike.lisp

(in-package #:roguelike)

;;; "roguelike" goes here. Hacks and glory await!

(defparameter *random-color* sdl:*white*)
(defparameter *sh* 0)
(defparameter *cells* 0)

(defparameter player-x 0)
(defparameter player-y 0)

(defparameter move-offset 8)


;;; Event list and processing
;(acons 'up-event '())
;(defparameter events '(player-up))
(defparameter events-max 2)
(defparameter events-list '())

(defun prune-events (l)
  (if (> (length l) events-max)
      ;; Write inline function to recurse through list up until hit max length.
(defun fire-event (e)
  (cons e (events-list nil))

(defun mouse-rect-2d ()
  (sdl:with-init ()
    (sdl-init)
    (load-spritesheets)
    (process-events)
))

(defun load-spritesheets ()
  (defparameter *sh* (sdl:load-image "terminal-white.png"))
  (defparameter *cells* (loop for y from 0 to 128 by 8
                         append (loop for x from 0 to 128 by 8
                                   collect (list x y 8 8))))
  (setf (sdl:cells *sh*) *cells*))


(defun sdl-init ()
  (sdl:window 200 200 :title-caption "Move a rectangle using the mouse")
  (setf (sdl:frame-rate) 60))

(defun process-events () ;;; Later, add event macro forms?
  (sdl:with-events ()
    (:quit-event () t)
    (:key-down-event (:key key)
                     (cond
                       ((sdl:key= key :sdl-key-escape)
                        (sdl:push-quit-event))
                       ((sdl:key= key :sdl-key-w)
                        (setf player-y (- player-y 8)))
                       ((sdl:key= key :sdl-key-s)
                        (setf player-y (+ player-y 8)))
                       ((sdl:key= key :sdl-key-a)
                        (setf player-x (- player-x 8)))
                       ((sdl:key= key :sdl-key-d)
                        (setf player-x (+ player-x 8)))))
    (:idle ()
           (update-swank)
           (update-actor)

           ;; Clear display each game loop
           (sdl:clear-display sdl:*black*)

           (draw-actor)

           ;; Redraw the display
           (sdl:update-display))))

(defun update-actor ()
  )
  ;; Change color of box if left mouse button pressed.
  ;; (when (sdl:mouse-left-p)
  ;;   (setf *random-color* (sdl:color :r (random 255) :g (random 255) :b (random 255)))))

(defun draw-actor ()
  ;; Draw @ at mouse position
  (sdl:draw-surface-at-* *sh* player-x player-y :cell 4))
  ;; Draw the box having a center at mouse xy
  ;(sdl:draw-box (sdl:rectangle-from-midpoint-* (sdl:mouse-x) (sdl:mouse-y) 100 50)
  ;              :color *random-color*))

(defmacro continuable (&body body)
  "Helper macro that we can use to allow us to continue from an
error. Remember to hit C in slime or pick the restart so errors don't kill the app."
  `(restart-case (progn ,@body) (continue () :report "Continue")))

(defun update-swank ()
       "Called from within the main loop, this keep the lisp repl
working while the game runs"
       (continuable (let ((connection (or swank::*emacs-connection* (swank::default-connection))))
                      (when connection
                        (swank::handle-requests connection t)))))

;;; Separate, testing hot loading in SBCL with threads!
;; (defun update (i)
;;   (+ i 2))

;; (defun hot-patch ()
;;    (loop for i = 0 then (update i) do
;;         (format t "~&i = ~d~%" i)
;;         (fresh-line)
;;         (sleep 5)))

;;;; Start thread with:
;;;; (defparmater *thread* (sb-thread:make-thread #'hot-patch))

;;;; Can change update and recompile to see effect (in inferior lisp).

;;;; Stop thread with:
;;;; (sb-thread:terminate-thread *thread*)

