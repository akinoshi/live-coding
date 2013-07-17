; File: yog-sothoth.scm
; ---------------------
; This is a script for audio visual performance
; called Yog-Sothoth. This was designed to be
; live coding performance for the event called
; Good Vibration.
;
; Author: Akinori Kinoshita
; E-mail: art.akinoshi -at- gmail.com
; Date: Mon Jul  1 20:40:48 CST 2013

(clear)
(gain .1)
(blur .1)
(blend-mode 'src-alpha 'one)
(collisions 1)
(gravity (vector 0 0 0))
(set-max-physical 500)

(define p-size 500)
(define t-size 5)
(define s-size 3)

(define p (build-particles p-size))

(with-primitive p
    (hint-depth-sort)
    (pdata-map! (lambda (p) (vmul (hsrndvec) 3)) "p")
    (pdata-map! (lambda (c) (vector 1 1 1)) "c")
    (texture (load-texture "particle.png")))

(define t (build-nurbs-plane t-size t-size))

(with-primitive t
    (rotate (vector -90 0 0))
    (scale 100)
    (translate (vector 0 0 -.8))
    (colour (vector .5 1 1))
    (texture (load-texture "gradient.png")))

(define center (build-locator))

(define s (with-state
    (backfacecull 0)
    (build-icosphere s-size)))

(with-primitive s
    (poly-convert-to-indexed)
    (pdata-copy "p" "pref")
    (pdata-copy "n" "nref"))

(define w (with-state
    (translate (vector 1000 0 0))
    (build-pixels 128 4 #t)))

(define x (with-pixels-renderer w
    (with-state
        (scale 4)
        (hint-unlit)
        (build-torus .2 2 2 3))))

(build-image (pixels->texture w)
    (vector 0 0) (get-screen-size))

(define (render)
    (with-pixels-renderer w
        (with-primitive x
            (colour (hsv->rgb (vector (cos (time)) 1 1)))
            (rotate (vector (gh 6) (gh 7) (gh 8)))))
    (with-primitive s
        (rotate (vector (gh 3) (gh 4) (gh 5)))
        (pdata-index-map! (lambda (i p) (vadd (pdata-ref "pref" i)
            (vmul (pdata-ref "nref" i) (gh i))))
            "p")
        (colour (hsv->rgb (vector (sin (time)) 1 1))))
    (with-primitive center (rotate (vector 0 1 0)))
    (when (> (gh 0) 3)
        (with-state
            (parent center)
            (hint-wire)
            (backfacecull 0)
            (colour (vector (/ 200 255) (/ 150 255) (/ 100 255) .1))
            (wire-colour (vector (/ 128 255) .1))
            (translate (vmul (grndvec) 1))
            (active-box (build-cube))))
    (with-primitive t
        (rotate (vector 0 0 1))
        (pdata-index-map! (lambda (i p) (vector
            (vx (pdata-ref "p" i))
            (vy (pdata-ref "p" i))
            (noise (* (+ .5 (gh 8)) (modulo i t-size))
                   (* (+ .5 (gh 8)) (quotient i t-size)))))
            "p"))
    (with-primitive p
        (identity)
        (rotate (vector (gh 1) (gh 2) 0))
        (scale (+ 3 (gh 0)))))

(every-frame (render))
