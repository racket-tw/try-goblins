#lang racket
(require goblins
         goblins/actor-lib/bootstrap
         goblins/actor-lib/methods)
(require syntax/parse/define
         (for-syntax racket/syntax))

(define-syntax-parser make-named-vat
  [(_ name:id)
   (with-syntax ([vat-name (format-id #'name "~a-vat" #'name)]
                 [run-name (format-id #'name "~a-run" #'name)])
     #'(begin (define vat-name (make-vat))
              (define-vat-run run-name vat-name)))])

(make-named-vat a)
(make-named-vat b)

(define (^spawn-in-another-vat bcom)
  (define (next cur-map)
    (methods
     [(create name) (define m (b-run (spawn ^oops name)))
                    (bcom (next (hash-set cur-map name m)) m)]
     [(get name) (bcom (next cur-map)
                       (hash-ref cur-map name))]))
  (next (hash)))
(define a-actor (a-run (spawn ^spawn-in-another-vat)))

(define (^oops bcom name)
  (define (next name)
    (methods
     [(flow) (on (<- a-actor 'create "hello")
                 (lambda (actor)
                   (<-np actor 'print)))]
     [(print) (println name)]))
  (next name))

(define hi-actor (a-run ($ a-actor 'create "hi")))

(b-run ($ hi-actor 'flow)
       ($ hi-actor 'print))
