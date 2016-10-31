(in-package #:closette)

;;;
;;; Bootstrap
;;;

(format t "Beginning to bootstrap Closette...")
(forget-all-classes)
(forget-all-generic-functions)
;; How to create the class hierarchy in 10 easy steps:
;; 1. Figure out standard-class's slots.
(setq the-slots-of-standard-class
      (mapcar #'(lambda (slotd)
                  (make-effective-slot-definition
                    :name (car slotd)
                    :initargs
                      (let ((a (getf (cdr slotd) ':initarg)))
                        (if a (list a) ()))
                    :initform (getf (cdr slotd) ':initform)
                    :initfunction
                      (let ((a (getf (cdr slotd) ':initform)))
                        (if a #'(lambda () (eval a)) nil))
                    :allocation ':instance))
              (nth 3 the-defclass-standard-class)))
;; 2. Create the standard-class metaobject by hand.
(setq the-class-standard-class
      (allocate-std-instance
         'tba
         (make-array (length the-slots-of-standard-class)
                     :initial-element secret-unbound-value)))
;; 3. Install standard-class's (circular) class-of link. 
(setf (std-instance-class the-class-standard-class) 
      the-class-standard-class)
;; (It's now okay to use class-... accessor).
;; 4. Fill in standard-class's class-slots.
(setf (class-slots the-class-standard-class) the-slots-of-standard-class)
;; (Skeleton built; it's now okay to call make-instance-standard-class.)
;; 5. Hand build the class t so that it has no direct superclasses.
(setf (find-class 't) 
  (let ((class (std-allocate-instance the-class-standard-class)))
    (setf (class-name class) 't)
    (setf (class-direct-subclasses class) ())
    (setf (class-direct-superclasses class) ())
    (setf (class-direct-methods class) ())
    (setf (class-direct-slots class) ())
    (setf (class-precedence-list class) (list class))
    (setf (class-slots class) ())
    class))
;; (It's now okay to define subclasses of t.)
;; 6. Create the other superclass of standard-class (i.e., standard-object).
(defclass standard-object (t) ())
;; 7. Define the full-blown version of standard-class.
(setq the-class-standard-class (eval the-defclass-standard-class))
;; 8. Replace all (3) existing pointers to the skeleton with real one.
(setf (std-instance-class (find-class 't)) 
      the-class-standard-class)
(setf (std-instance-class (find-class 'standard-object)) 
      the-class-standard-class)
(setf (std-instance-class the-class-standard-class) 
      the-class-standard-class)
;; (Clear sailing from here on in).
;; 9. Define the other built-in classes.
(defclass symbol (t) ())
(defclass sequence (t) ())
(defclass array (t) ())
(defclass number (t) ())
(defclass character (t) ())
(defclass function (t) ())
(defclass hash-table (t) ())
(defclass package (t) ())
(defclass pathname (t) ())
(defclass readtable (t) ())
(defclass stream (t) ())
(defclass list (sequence) ())
(defclass null (symbol list) ())
(defclass cons (list) ())
(defclass vector (array sequence) ())
(defclass bit-vector (vector) ())
(defclass string (vector) ())
(defclass complex (number) ())
(defclass integer (number) ())
(defclass float (number) ())
;; 10. Define the other standard metaobject classes.
(setq the-class-standard-gf (eval the-defclass-standard-generic-function))
(setq the-class-standard-method (eval the-defclass-standard-method))
;; Voila! The class hierarchy is in place.
(format t "Class hierarchy created.")
;; (It's now okay to define generic functions and methods.)

