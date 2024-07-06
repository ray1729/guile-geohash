;; A Geohash implementation for Guile scheme
;; This is a port of the code from https://github.com/chrisveness/latlon-geohash/tree/master

(define-module (geohash)
  #:use-module (ice-9 receive)
  #:use-module (ice-9 match)
  #:export (encode decode bounds adjacent neighbours))

(define max-precision 12)

(define base32 "0123456789bcdefghjkmnpqrstuvwxyz")

(define* (encode lat lon #:key (precision 12))
  (define desired-precision (min precision max-precision))
  (let loop ((lat-min -90.0)
             (lat-max 90.0)
             (lon-min -180.0)
             (lon-max 180.0)
             (even-bit? #t)
             (idx 0)
             (bit 0)
             (result '()))
    (cond
     ((= desired-precision (length result))
      (reverse-list->string result))

     ((= bit 5)
      (loop lat-min lat-max lon-min lon-max even-bit?
            0 0 (cons (string-ref base32 idx) result)))

     (even-bit?
      (let ((lon-mid (/ (+ lon-min lon-max) 2)))
        (if (>= lon lon-mid)
            (loop lat-min lat-max lon-mid lon-max (not even-bit?)
                  (1+ (* 2 idx)) (1+ bit) result)
            (loop lat-min lat-max lon-min lon-mid (not even-bit?)
                  (* 2 idx) (1+ bit) result))))

     (else
      (let ((lat-mid (/ (+ lat-min lat-max) 2)))
        (if (>= lat lat-mid)
            (loop lat-mid lat-max lon-min lon-max (not even-bit?)
                  (1+ (* 2 idx)) (1+ bit) result)
            (loop lat-min lat-mid lon-min lon-max (not even-bit?)
                  (* 2 idx) (1+ bit) result)))))))

(define (bounds s)
  (let loop ((xs (map (lambda (c) (string-index base32 c)) (string->list s)))
             (n 4)
             (lat-min -90.0)
             (lat-max 90.0)
             (lon-min -180.0)
             (lon-max 180.0)
             (even-bit? #t))
    (cond
     ((nil? xs)
      (values lat-min lat-max lon-min lon-max))

     ((< n 0)
      (loop (cdr xs) 4 lat-min lat-max lon-min lon-max even-bit?))

     (even-bit?
      (let ((lon-mid (/ (+ lon-min lon-max) 2)))
        (if (logbit? n (car xs))
            (loop xs (1- n) lat-min lat-max lon-mid lon-max (not even-bit?))
            (loop xs (1- n) lat-min lat-max lon-min lon-mid (not even-bit?)))))

     (else
      (let ((lat-mid (/ (+ lat-min lat-max) 2)))
        (if (logbit? n (car xs))
            (loop xs (1- n) lat-mid lat-max lon-min lon-max (not even-bit?))
            (loop xs (1- n) lat-min lat-mid lon-min lon-max (not even-bit?))))))))

(define (round-to-n-decimal-places x n)
  (let* ((whole-part (truncate x))
         (fractional-part (- x whole-part))
         (multiplier (expt 10 n))
         (rounded-frac (round (* fractional-part multiplier))))
    (+ whole-part (/ rounded-frac multiplier))))

(define (decode s)
  (receive (lat-min lat-max lon-min lon-max) (bounds s)
    (let ((lat (/ (+ lat-min lat-max) 2))
          (lat-places (truncate (- 2 (log10 (- lat-max lat-min)))))
          (lon (/ (+ lon-min lon-max) 2))
          (lon-places (truncate (- 2 (log10 (- lon-max lon-min))))))
      (values (round-to-n-decimal-places lat lat-places)
              (round-to-n-decimal-places lon lon-places)))))

(define (neighbour direction geohash-length)
  (match (list direction (even? geohash-length))
    (('n #t) "p0r21436x8zb9dcf5h7kjnmqesgutwvy")
    (('n #f) "bc01fg45238967deuvhjyznpkmstqrwx")
    (('s #t) "14365h7k9dcfesgujnmqp0r2twvyx8zb")
    (('s #f) "238967debc01fg45kmstqrwxuvhjyznp")
    (('e #t) "bc01fg45238967deuvhjyznpkmstqrwx")
    (('e #f) "p0r21436x8zb9dcf5h7kjnmqesgutwvy")
    (('w #t) "238967debc01fg45kmstqrwxuvhjyznp")
    (('w #f) "14365h7k9dcfesgujnmqp0r2twvyx8zb")))

(define (border direction geohash-length)
  (match (list direction (even? geohash-length))
    (('n #t) "prxz")
    (('n #f) "bcfguvyz")
    (('s #t) "028b")
    (('s #f) "0145hjnp")
    (('e #t) "bcfguvyz")
    (('e #f) "prxz")
    (('w #t) "0145hjnp")
    (('w #f) "028b")))

(define (adjacent s direction)
  (let* ((n (string-length s))
         (last-char (string-ref s (1- n)))
         (nbr-idx (string-index (neighbour direction n) last-char))
         (parent (if (and (> n 1) (string-index (border direction n) last-char))
                     (adjacent (substring s 0 (1- n)) direction)
                     (substring s 0 (1- n)))))
    (string-append parent (string (string-ref base32 nbr-idx)))))

(define (neighbours s)
  (list (cons 'n (adjacent s 'n))
        (cons 'ne (adjacent (adjacent s 'n) 'e))
        (cons 'e (adjacent s 'e))
        (cons 'se (adjacent (adjacent s 's) 'e))
        (cons 's (adjacent s 's))
        (cons 'sw (adjacent (adjacent s 's) 'w))
        (cons 'w (adjacent s 'w))
        (cons 'nw (adjacent (adjacent s 'n) 'w))))
