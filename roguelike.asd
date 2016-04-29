;;;; roguelike.asd

(asdf:defsystem #:roguelike
  :description "Describe roguelike here"
  :author "Your Name <your.name@example.com>"
  :license "Specify license here"
  :depends-on (#:lispbuilder-sdl)
  :serial t
  :components ((:file "package")
               (:file "roguelike")))

