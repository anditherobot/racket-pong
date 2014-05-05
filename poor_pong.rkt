 #lang racket

;; Andi milhomme. Project


;; Game instructions


;;Press RUN or Ctrl + R,
;; You control the left paddle with the up and down keys

;;  Press P to pause. If you fail to hit the ball, you lose.

;; Note, try to hit the ball with the center of the paddle. Hitting with the edge
;; is a bit inconsitent

(require 2htdp/universe 2htdp/image)


;; The size of the frame /window
(define-values (WIDTH HEIGHT) (values 840 680))

;; Paddle step amount,ball velocity, and pause state
(define-values (MOVE-DELTA TICK-SETTING PAUSED?) (values 10 .005 #f))


;; The margin for the borders and x-ccordinates for the paddles

(define-values (BOUNDARY LEFT RIGHT) (values 10 5 (- WIDTH 5)))


;;Drawing all the necessary pieces
(define BALL (bitmap "ball.png"))

(define LEFT-PADDLE (bitmap "paddlel.png"))
(define RIGHT-PADDLE (bitmap "paddler.png"))
 

;; Text for the game
(define GAME-OVER-TEXT-SIZE 35)




;; Game state is a list of 6 integers
(define (ball-x state) (list-ref state 0))
(define (ball-y state) (list-ref state 1))
(define (ball-vec-x state) (list-ref state 2))
(define (ball-vec-y state) (list-ref state 3))
(define (left-paddle-y state) (list-ref state 4))
(define (right-paddle-y state) (list-ref state 5))

;; This will update  a list at tracker with a new value
(define (replace lst tracker value)
  (append (take lst tracker)
          (list value)
          (list-tail lst (add1 tracker))))

;; Is the ball colliding with a paddle?
(define (collision? state)
  (define (within? n target dist)
    (and (>= n (- target dist)) (<= n (+ target dist))))
  (or (and (equal? (ball-x state) 20) 
           (within? (ball-y state) (left-paddle-y state) 25))
      (and (equal? (ball-x state) (- WIDTH 20))
           (within? (ball-y state) (right-paddle-y state) 25))))

;; Did the ball travel past either paddle? check botton
(define (off-limits? state)
  (or (>= BOUNDARY (ball-x state))
      (<= (- WIDTH BOUNDARY) (ball-x state))) )

;; Move the ball one step
(define (move-ball state)
  (replace (replace state 0 (+ (ball-x state) (ball-vec-x state)))
           1
           (+ (ball-y state) (ball-vec-y state))))

;; Next position of the ball
;; if it's paused it will retain the state

(define (next-ball state)
  (if PAUSED?
      state
      (move-ball
       (cond
         [(collision? state)
          (replace state 2 (* -1 (ball-vec-x state)))]
         [(or (equal? (ball-y state) BOUNDARY)
              (equal? (ball-y state) (- HEIGHT BOUNDARY)))
          (replace state 3 (* -1 (ball-vec-y state)))]
         [else state]))))


;; Move the left paddle vec pixels
(define (next-player state vec)
  (define new-y
    (max 40  (min (- HEIGHT 25) (+ vec (left-paddle-y state)))))
  (if PAUSED?
      state
      (replace state 4 new-y)))

;;Fake ai hahahahh
(define (arti-intel state)
 
  ;; this is where the magic happens. By replacing the state, it matches the ball's height. (y coordinate)
  (replace state 5 (ball-y state)))

;; Pause the game using a toggle
(define (toggle-pause state)
  (set! PAUSED? (not PAUSED?))
  state)

;; Event handlers 
(define (event-handler state a-key)
  (cond
    [(key=?  a-key "up") (next-player state (- MOVE-DELTA))]
    [(key=?  a-key "down") (next-player state (+ MOVE-DELTA))]
    [(key=?  a-key "p") (toggle-pause state)]
    [else state]))


;; The universe library can move object with ticks. 
;; After every tick ,  It will find new ai position, every time the ball moves
(define (world-step state)
  (arti-intel (next-ball state)))

;; These are the initial positions of the sprites
;; The ball will change position, 


(define original-state
  (let ([random-vector (λ () (list-ref (list -1 1) (random 2)))]
        [half-width (/ WIDTH 2)] 
        [half-height (/ HEIGHT 2)])
    (list half-width half-height                    ; ball position
          (random-vector) (random-vector)  ; ball direction
          half-height half-height)))                 ; paddle heights

;; Drawing the game area
;; By simply placing the images I can tie everything together. 
;; The only pieces are the ball and 2 paddles.

(define (display-sprites state)
  (place-image
   BALL (ball-x state) (ball-y state)
   (place-image
    LEFT-PADDLE LEFT (left-paddle-y state)
    (place-image 
     RIGHT-PADDLE RIGHT (right-paddle-y state)
     (add-line(empty-scene WIDTH HEIGHT "black" )  420 0 420 680   (make-pen "white" 7 "long-dash" "round" "round") )))))


;; Displays a game over text, when the game is over

(define (game-over-text w)
  (overlay (text/font "GAME  OVER" 50 "red"  "Terminal" 'default 'normal 'bold #f)
           (display-sprites w)))



;; Create the frame for the game, and start.

;; This will take all the procedures defined above , and just run them as needed
;; I still don't have a full idea about how it works, but it works.
(big-bang original-state
          (to-draw display-sprites)
          (on-key event-handler)
          (on-tick world-step TICK-SETTING)
          (stop-when off-limits? game-over-text))


