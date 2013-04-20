; File: ixd-demo-party-#6.scm
; ---------------------------
; A live coding script for IxD Demo Party #6.
; 
; Author: Akinori Kinoshita
; E-mail: art.akinoshi -at- gmail.com
; Sat Apr 20 11:34:00 CST 2013

(clear)

(gain 2)

(blend-mode 'one 'one)

(blur .1)

(define size 300)

(define pos (build-list size (lambda (x) (vmul (grndvec) 10))))

(define ang (build-list size
    (lambda (x) (vector (* 360 (flxrnd))
                        (* 360 (flxrnd))
                        (* 360 (flxrnd))))))

(define p (with-state
    (translate (vector 1000 0 0))
    (build-pixels 8 8 #t)))

(define q (with-pixels-renderer p
    (with-state
        (hint-unlit)
        (blur .1)
        (blend-mode 'one 'one)
        (scale 3)
        (build-torus .2 2 2 3))))

(build-image (pixels->texture p)
    (vector 0 0) (get-screen-size))

(define (render)
    (with-state
        (colour (vector 1 0 0 .5))
        (scale (vector (gh 0) .5 .5))
        (draw-cube))
    (with-state
        (colour (vector 0 1 0 .5))
        (scale (vector .5 (gh 1) .5))
        (draw-cube))
    (with-state
        (colour (vector 0 0 1 .5))
        (scale (vector .5 .5 (gh 2)))
        (draw-cube)))

(define (render-all ls0 ls1)
    (when (not (null? ls0))
        (translate (car ls0))
        (rotate (car ls1))
        (translate (vector (* 15 (sin (time))) 
                        (* 30 (cos (time)))
                        0))
        (render)
        (render-all (cdr ls0) (cdr ls1))))

(every-frame (begin
    (with-pixels-renderer p
        (with-primitive q
            (colour (hsv->rgb (vector (sin (time)) (gh 6) 1)))
            (rotate (vector (gh 3) (gh 4) (gh 5)))))
    (render-all pos ang)))
