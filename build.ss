#!/usr/bin/env gxi
;; -*- Gerbil -*-

(import :std/make
        :std/build-script)


(def build-lst
   (filter-map
    (lambda (filename)
      (and (equal? (path-extension filename) ".ss")
	   (path-expand (path-strip-extension filename) "sysinfo")))
    (read-all (open-directory "sysinfo")))
   )

(displayln build-lst)

(defbuild-script
  build-lst
  optimize: #f debug: 'src
  )
