(import :std/pregexp)
(import :gerbil/gambit/threads)
(import :ex7763/sysinfo/utils)

(export
  mem-info!
  mem-usage!
  mem-used!
  mem-free!)

;(define (mem-info!)
  ;(define (pipe str context)
    ;(string->number 
        ;(list-ref
          ;(pregexp-split "[ \t]+"
            ;(car (pregexp-match str context)))
          ;1)))
  ;(let ((context ""))
      ;(call-with-input-file "/proc/meminfo"
          ;(lambda (input-port)
            ;(let lp ((x (read-line input-port)))
              ;(if (not (eof-object? x))
                ;(begin
                  ;(set! context (string-append context x))
                  ;(set! context (string-append context "\n"))
                  ;(lp (read-line input-port)))))))
            ;(let* ((total (pipe "MemTotal.*\n" context))
                   ;(free (pipe "MemFree.*\n" context))
                   ;(available (pipe "MemAvailable.*\n" context)))
              ;(displayln total)
              ;(displayln free)
              ;(displayln available)
              ;`((total ,total)
                ;(free ,free)
                ;(avaiable ,available)
                ;(usage ,(exact->inexact (/ available total))))
              ;)
            ;)
 ;)

(define (mem-info!)
  (define (pipe str context)
    (string->number 
        (list-ref
          (pregexp-split "[ \t]+"
            (car (pregexp-match str context)))
          1)))
  (let ((context ""))
      (call-with-input-file "/proc/meminfo"
          (lambda (input-port)
            (let lp ((x (read-line input-port)))
              (if (not (eof-object? x))
                (begin
                  (set! context (string-append context x))
                  (set! context (string-append context "\n"))
                  (lp (read-line input-port)))))))
          (let* (
                  ;; raw data
                  (MemTotal (pipe "MemTotal.*\n" context))
                  (MemFree (pipe "MemFree.*\n" context))
                  (SReclaimable (pipe "SReclaimable.*\n" context))
                  (Buffers (pipe "Buffers.*\n" context))
                  (Cached (pipe "Cached.*\n" context))

                  (free (+ MemFree SReclaimable Buffers Cached))
                  (used (- MemTotal (+ MemFree SReclaimable Buffers Cached)))
                  )
             `((total ,MemTotal)
               (free ,free)
               (buffers ,Buffers)
               (cached ,Cached)
               (used ,used)
               (usage ,(exact->inexact
                        (/ used MemTotal))))
           )
          )
  )

;; Unit: KB
(define (mem-free!)
  (cadr (assoc 'free (mem-info!))))

(define (mem-used!)
  (cadr (assoc 'used (mem-info!))))

(define (mem-usage!)
  (cadr (assoc 'usage (mem-info!))))


(def (test)
  (displayln "mem usage: " (mem-usage!))
  (displayln "mem used: " (mem-used!))
  (displayln "mem free: " (mem-free!))
  )
