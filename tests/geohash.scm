(define-module (test-geohash)
  #:use-module (geohash)
  #:use-module (ice-9 receive)
  #:use-module (srfi srfi-64))

(define (approximately? test-expr expected error)
  (and (>= test-expr (- expected error))
       (<= test-expr (+ expected error))))

(test-begin "geohash")

(test-equal "encode Jutland"
  "u4pruy"
  (encode 57.648 10.410 #:precision 6))

(test-assert "decode Jutland"
  (receive (lat lon) (decode "u4pruy")
    (and (approximately? lat 57.648 0.0001)
         (approximately? lon 10.410 0.0001))))

(test-equal "encode Curitiba"
  "6gkzwgjz"
  (encode -25.38262 -49.26561 #:precision 8))

(test-assert "decode Curitiba"
  (receive (lat lon) (decode "6gkzwgjz")
    (and (approximately? lat -25.38262 0.000001)
         (approximately? lon -49.26561 0.000001))))

(test-equal "neighbours"
  '((n . "gbpb") (ne . "u000") (e . "spbp") (se . "spbn") (s . "ezzy") (sw . "ezzw") (w . "ezzx") (nw . "gbp8"))
  (neighbours "ezzz"))

(test-equal "encode max precision"
  "wy85bj0hbp21"
  (encode 37.25 123.75 #:precision 12))

(test-equal "encode default precision"
  "wy85bj0hb"
  (encode 37.25 123.75))

(test-end)
