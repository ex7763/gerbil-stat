(import :std/pregexp)
(import :gerbil/gambit/threads)

(define (remove-new-line str)
  (pregexp-replace "\n" str ""))

(def (cpu-usage)
  (let ((context ""))
    (call-with-input-file "/proc/stat"
      (lambda (input-port)
        (let lp ((x (read-line input-port)))
          (if (not (eof-object? x))
            (begin
              (set! context (string-append context x))
              (set! context (string-append context "\n"))
              (lp (read-line input-port)))))))
        (let* ((a (pregexp-match "cpu .*\n" context))
               (b (map (lambda (x) (string->number (remove-new-line x)))
                       (pregexp-split " +" (car a))))
               (idel (list-ref b 4))
               (total (apply + (cdr b))))
          (list idel total)
          )
     )
  )

(define a (cpu-usage))
(thread-sleep! 1)
(define b (cpu-usage))

(define idel (- (car a) (car b)))
(define total (- (cadr a) (cadr b)))
(displayln "cpu usage: " (exact->inexact
                         (* 100
                            (- 1
                                (/ idel total))))
           "%")
