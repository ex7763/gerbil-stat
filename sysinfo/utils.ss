(import :std/pregexp)

(export #t)

(define (remove-new-line str)
  (pregexp-replace "\n" str ""))

