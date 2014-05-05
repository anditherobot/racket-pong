Andi Milhomme

OPL Final Project.  May 4th 2014

1. Files Submitted
==================
* poor_pong.rkt
* ball.png
* paddlel.png
* paddler.png
* README.txt


2. Overall structure of the code
================================

+ I included the libraries: 2htdp/universe 2htdp/image. The first library 
defines a special form called  big-bang that creates interactive programs,
which we call worlds. The second one provides a bunch of functions for manipulating
images. Afer setting up the libraries The first thing I did was
setting up the global values: Windows size, tick speed and the boundaries. 
These values were then followed by the inclusion of the UI elements. These
elements were: Two paddles, a ball and other texts. 

+ The state of these elements are stored in a list of 6 integers. By the way 
a state can be anything, the velocity of the object, their z-index etc... For
the purpose of this assignment I have defined their state according to their
(x, y) coordinates and vectors(being a measure of direction and velocity). 
The ball is the object with the most states. Because I have to keep track of 
its position in the 2-D plane and also it's vector state.

+ Then comes the function that checks whether the ball is colliding with a paddle. 
If the states of the left paddle or right paddle intersect, it means that they 
have collided.

+ Next we have the algorithm that drive the game. Every tick , the ball position
will be replaced with a new position. Then it will be moved one step.

+ The event handler has 2 functions that it will call depending on the input.
 If the "up" or "down key are pressed the function : (next-player) will be called.
 if the "p" key is pressed the function (toggle-pause) will be called. 
 
+ The universe library can move object with ticks, after every tick the AI will 
update the next state,   according to the tick setting. It sounds complicated , but the AI 
is actually really simple to implement using scheme. I have defined a function called
(arti-intell) this function takes a state as an argument. Then I pass in the function 
(next-ball) with its state to the (arti-intell).
Magically it works. The layer of abstraction is really convenient.


 + After setting up the necessary interaction and conditionals the game should follow,
 I set up an initial position for all the elements. Then I defined the game over text.
 
 + Finally I called the (big-bang) which is the most interesting function of all. 
 It calls a function, depending of which parameter was provided to it. In this case I have:
 to-draw, on-key, on-tick, and stop-when.
 
 
 3. Functions used and a quick description
==========================================

+ (define (replace lst tracker value) : This will update  a list at tracker with a new value

+ (define (collision? state): Checks whether the ball is colliding with a paddle

+  (define (off-limits? state): Is the ball off limits

+  (define (move-ball state): move the ball one step, with the help of 'replace'

+ (define (next-ball state): The position of the ball

+ (define (next-player state vec): this moves the player's paddle by an amount of pixels.

+ (define (arti-intel state): replaces it's state with the ball y state. Nothing fancy, it's unbeatable for now.

+ (define (toggle-pause state): Toggle the pause state, but retaining the current state

+ (define (event-handler a-key): call functions according to which key is pressed

+ (define (world-step state): Calls the it, gives it a state to find

+ (define original-state): Initializes the UI elements

+ (define (display-sprites state): Draw them on the board

+ define (game-over-text w): Notifies the user if the game is over
 
+ (big-bang start-state): Creates the universe. Set up the initial look of the canvas
  by getting the values from original-state
  
  
  
4. Key ideas of the class that were used in the making of this program
=====================================================================
During this assignment, I have used a few key ideas that the racket language 
features. Certain concepts were quite intimidating , but I have learned so much about the flow of racket
by actually working on this project.

* Booleans: Used to toggle the pause state of the game

* Strings: Display various texts

* Lists: Game states. Append a new value at the end to keep track of the positions

* Functions: Defining the parts that drive the code.

* Lambda: Create a nameless function on the fly.

* Conditionals: Ask questions about value, the rest of the computation will depend 
on the questions' outcomes.


5. Blocks I am particularly satisfied with
=====================================================================
(define (arti-intel state)
 (replace state 5 (ball-y state)))
 
 (define (world-step state)
  (arti-intel (next-ball state)))
  
  Whenever I look at this block of code. I smile, because this snippet shows the 
  potential of racket. How a seemingly complicated idea can be condensed into
  only 4 lines of code. If I were to write this in C for example it would take much longer and 
  would be more difficult to understand.
  
    var paddleBox = MyApp.app.paddleLeft.element.getBox();

    var delta = Math.floor(Math.random() * (MyApp.app.difficulty / 2));

    if (xy[1] < paddleBox.top) {
        MyApp.app.paddleLeft.element.setY(paddleBox.y - constants.cpuSpeed - delta);
    }
    if (xy[1] > paddleBox.bottom) {
        MyApp.app.paddleLeft.element.setY(paddleBox.y + constants.cpuSpeed + delta);
    }
}

Learn about the "states" really changed my way of thinking about programming. 


6.  Annoying thing I've dealt with
=====================================================================

Displaying text over the canvas took me a while to figure out. The other 
thing was finding the correct tick speed for the paddle and the ball. Also It took me
a lot of research to find the maths behind the game, then adapt it to racket.
Luckily I stumbled upon that book: Realm of Racket. This book taught me everything I needed to know.
They really did a good job explaining the big concepts of racket, while keeping it interesting. 

7. How to run the game
=====================================================================

Press RUN or Ctrl + R,
You control the left paddle with the up and down keys

Press P to pause. If you fail to hit the ball, you lose.
Note, try to hit the ball with the center of the paddle. 
 Hitting with the edge is a bit inconsistent



7. Version 2 ?
=====================================================================

If I were to implement a version 2. I would definitely improve on the AI. I would
also add sound effects and multiple levels. I think it's a really nice project. 
If I get some time during the summer, I would try to make that happen.



  
  
  
