(use-modules
  (gnu packages)
  (gnu packages autotools)
  (gnu packages guile)
  (gnu packages guile-xyz)
  (gnu packages pkg-config)
  (gnu packages texinfo)
  (guix build-system gnu)
  (guix download)
  (guix gexp)
  ((guix licenses) #:prefix license:)
  (guix packages)
  (srfi srfi-1))

(package
  (name "guile-geohash")
  (version "0.1")
  (source
    (local-file
      (dirname (current-filename))
      #:recursive?
      #t
      #:select?
      (lambda (file stat)
        (not (any (lambda (my-string)
                    (string-contains file my-string))
                  (list ".git" ".dir-locals.el" "guix.scm"))))))
  (build-system gnu-build-system)
  (arguments `())
  (native-inputs
    (list autoconf automake pkg-config texinfo))
  (inputs (list guile-3.0))
  (propagated-inputs (list))
  (synopsis "Geohash encoding and decoding")
  (description
    "A geohash is a convenient way of expressing a location (anywhere in the world) using a short alphanumeric string, with greater precision obtained with longer strings. This implementation is based on a Javascript implementation (c) Chris Veness 2014-2019 / MIT Licence.")
  (home-page
    "https://github.com/ray1729/guile-geohash")
  (license license:gpl3+))

