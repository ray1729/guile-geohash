(hall-description
  (name "geohash")
  (prefix "guile")
  (version "0.1")
  (author "Ray Miller")
  (email "ray@1729.org.uk")
  (copyright (2024))
  (synopsis "Geohash encoding and decoding")
  (description
    "A geohash is a convenient way of expressing a location (anywhere in the world) using a short alphanumeric string, with greater precision obtained with longer strings. This implementation is based on a Javascript implementation (c) Chris Veness 2014-2019 / MIT Licence.")
  (home-page
    "https://github.com/ray1729/guile-geohash")
  (license gpl3+)
  (dependencies `())
  (skip ())
  (features
    ((guix #t)
     (use-guix-specs-for-dependencies #f)
     (native-language-support #f)
     (licensing #f)))
  (files (libraries
           ((scheme-file "geohash")
            (directory
              "geohash"
              ((scheme-file "hconfig")))))
         (tests ((directory "tests" ((scheme-file "geohash")))))
         (programs ((directory "scripts" ())))
         (documentation
           ((symlink "README" "README.org")
            (text-file "HACKING")
            (text-file "COPYING")
            (directory
              "doc"
              ((texi-file "geohash")
               (text-file ".dirstamp")
               (text-file "stamp-vti")
               (texi-file "version")
               (info-file "guile-geohash")))))
         (infrastructure
           ((scheme-file "guix")
            (text-file ".gitignore")
            (scheme-file "hall")))))
