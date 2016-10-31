(in-package :cl-user)

(defpackage #:closette.system
  (:use :common-lisp :asdf))
 
(in-package :closette.system)

(defsystem #:closette
  :description "Closette"
  :version "1.0"
  :author "Gregor Kiczales, et al."
  :maintainer "Chun Tian (binghe)"
  :license "MIT"
  :components
  ((:file "package")
   (:file "utils"             :depends-on ("package"))
   (:file "closette"          :depends-on ("package" "utils"))
   (:file "bootstrap"         :depends-on ("closette"))
   (:file "closette-final"    :depends-on ("bootstrap"))))

(defsystem #:closette.tests
  :description "Closette tests"
  :components
  ((:file "closette-tests")))
