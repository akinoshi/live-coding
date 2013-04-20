; File: lsf64.scm
; ---------------
; A live coding script for Lacking Sound Festival Listen 64
; warm-up performance.
;
; Author: Akinori Kinoshita
; E-mail: art.akinoshi -at- gmail.com
; Sat Apr 20 11:36:28 CST 2013

(clear)

(blend-mode 'src-alpha 'one)

(blur .1)

(gain .02)

(define size 1)

(define p (build-particles size))

(with-primitive p
    (hint-depth-sort)
    (scale 5)
    (pdata-map! (lambda (p) (hsrndvec)) "p")
    (pdata-map! (lambda (c) (vector 1 1 1)) "c")
    (texture (load-texture "./particle.png")))

(define s (with-state
;    (hint-unlit)
;    (hint-wire)
    (backfacecull 0)
    (colour (vector 1 1 0 .1))
    (wire-colour (vector 0 1 1 .1))
    (build-icosphere 2)))

(with-primitive s
    (poly-convert-to-indexed)
    (pdata-copy "p" "pref")
    (pdata-copy "n" "nref"))

(define cnt 0)

(define count 100000)

(define p2 (build-particles count))

(with-primitive p2
    (pdata-add "vel" "v")
    (hint-none)
    (hint-points)
    (point-width 3))

(define (init n)
    (pdata-set! "p" n (hsrndvec))
    (pdata-set! "vel" n (vmul (grndvec) .1))
    (pdata-set! "c" n (vector (flxrnd) (flxrnd) 1 .1)))

(define (initsome n)
    (when (not (zero? n))
        (init (random count))
        (initsome (- n 1))))

(define (render)
    (with-primitive p2
        (rotate (vector 0 (gh 0) 0))
        (initsome 100)
        (pdata-op "+" "p" "vel"))
    (set! cnt (+ cnt .1))
    (with-primitive s
        (rotate (vector (sin (time)) (cos (time)) 0))
        (for ((i (in-range (pdata-size))))
            (pdata-set! "p" i (vadd (pdata-get "pref" i)
                                    (vmul (pdata-get "nref" i) (* 3 (gh (+ i cnt)))))))
        (colour (hsv->rgb (vector (sin (time)) 1 1)))
        (wire-colour (hsv->rgb (vector (cos (time)) 1 1))))
    (with-primitive p
        (rotate (vector (gh 0) (gh 1) (gh 2)))
;        (identity)
;        (scale (* 10 (gh 0)))
))

(every-frame (render))
