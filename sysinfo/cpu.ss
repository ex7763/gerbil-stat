(import :std/pregexp)
(import :gerbil/gambit/threads)
(import :ex7763/sysinfo/utils)

(export
  cpu-idle-total!
  cpu-usage!)

(define (cpu-idle-total!)
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
                   (idle (list-ref b 4))
                   (total (apply + (cdr b))))
              (values idle total)
              )
            )
 )

(def (cpu-usage! (sleep-time 0.05))
  (define-values (pre-idle pre-total) (cpu-idle-total!))
  (thread-sleep! sleep-time)
  (define-values (next-idle next-total) (cpu-idle-total!))
  (exact->inexact (* 100
                     (- 1
                        (/ (- next-idle pre-idle)
                           (- next-total pre-total)))))
  )

;(displayln "cpu usage: " (cpu-usage!))
