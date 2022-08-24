#lang racket
(require goblins
         goblins/actor-lib/bootstrap
         goblins/actor-lib/methods)

(define v (make-vat))
(define-vat-run with-vat
  v)

(define (^counter bcom [count 0])
  (methods
   [(count) count]
   [(add1) (bcom (^counter bcom (add1 count)))]))

(define c (with-vat (spawn ^counter)))
(with-vat  ($ c 'count))
(with-vat ($ c 'add1))
(with-vat  ($ c 'add1))
(with-vat  ($ c 'count))
