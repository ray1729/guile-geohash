(define-module
  (geohash hconfig)
  #:use-module
  (srfi srfi-26)
  #:export
  (%version
    %author
    %license
    %copyright
    %gettext-domain
    G_
    N_
    init-nls
    init-locale))

(define %version "0.1")

(define %author "Ray Miller")

(define %license 'gpl3+)

(define %copyright '(2024))

(define %gettext-domain "guile-geohash")

(define G_ identity)

(define N_ identity)

(define (init-nls) "Dummy as no NLS is used" #t)

(define (init-locale)
  "Dummy as no NLS is used"
  #t)

