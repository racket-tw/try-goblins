#lang racket
(require goblins)

(define a-vat
  (make-vat))

(define (^friend bcom my-name)
  (lambda (your-name)
    (format "Hello ~a, my name is ~a!" your-name my-name)))

(define alice
  (a-vat 'spawn ^friend "Alice"))

alice

(a-vat 'call alice "Chris")
