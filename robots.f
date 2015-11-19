\ Robots.f - An implementation of the BSD robots game
\
\ You ("@") are placed into a wide space covered with holes ("o") and
\ robots ("R"). Try to lure the robots into the holes to win. If a
\ robot catches you, you loose. You are able to teleport yourself to a
\ random location 3 times.
\
\ (by ckeen)


\ statistics
variable #moves 0 #moves !
variable #teleports 3 #teleports !

\ the board
20 constant board-rows
78 constant board-cols

: random-xy ( -- x y ) \ returns random x y coordinates
    random 255 and board-cols mod random 255 and board-rows mod ;

board-rows board-cols * constant board-dimension
create board board-dimension cells allot
: xy->board ( x y -- i ) \ converts xy coordinates to the board buffer index
    board-cols * + ;
: board@ ( x y -- c ) \ fetches a tile at coordinates x y
    xy->board cells board + @ ;
: board! ( c x y -- ) \ stores tile char c at coordinates x y
    xy->board cells board + ! ;

\ drawing words
char ☻ constant player-sym
char ☹ constant robot-sym
char ◯ constant hole-sym
32 constant floor-sym \ a space character
char │ constant wall-sym

: top-border ( -- ) \ draw a border like '+----+' for the board
    [char] ┌ emit
    board-cols 0 do [char] ─ emit loop
    [char] ┐ emit ;

: bottom-border ( -- ) \ draw a border like '+----+' for the board
    [char] └ emit
    board-cols 0 do [char] ─ emit loop
    [char] ┘ emit ;

: wall ( -- ) \ print a wall symbol
    wall-sym emit ;

: board-reset ( -- ) \ empties a board by placing floor tiles in it
    board-dimension 0 do \ for the whole board
        floor-sym board i cells + ! \ store a floor tile
    loop ;

: board-print ( -- ) \ prints the whole board
    \ clears screen, prints the board surrounded
    \ by walls and a border on top and bottom
    page top-border cr wall
    board-dimension 0 do
        i board-cols mod 0= i 0> and if \ special case for first position at (0,0)
            wall cr wall then \ otherwise draw a wall at the end of each line
        board i cells + @ emit \ and draw the (next) tile
    loop
    wall cr bottom-border cr ;

\ player
create (player) 2 cells allot

: player@ ( -- x y ) \ returns current player x y position
    (player) 2@ ;

: player! ( x y -- ) \ sets current player position to x y
    (player) 2! ;

: new-position ( x1 y1 dx dy -- x2 y2 ) \ adds an offset to the current position
    rot +        \ calculate y2 ( x1 dx y2 )
    >r           \ store y2
    + r> ;       \ add x1 dx and push y2

: valid-position? ( x y -- f ) \ checks whether the player can be placed here
    2dup 2>r                          \ save coordinates for later
    0 board-rows within swap          \ y is within board boundaries
    ( b x ) 0 board-cols within and   \ x is also within boundaries?
    2r> ( x y ) board@ floor-sym = and ;  \ is it a free space? This prevents falling into holes

: up ( -- dx dy ) 0 -1 ;
: down ( -- dx dy ) 0 1 ;
: left ( -- dx dy ) -1 0 ;
: right ( -- dx dy ) 1 0 ;

: teleport-location ( -- ) \ ensure that the new location is legal
    random-xy                   \ get random coordinates
    2dup valid-position? invert \ use a copy for testing, is valid?
    if 2drop                    \ if it is not, clean stack
        recurse then ;          \ and try again

: update-player ( x y -- )
    \ move the player tile on the board
    \ and update the player position
    floor-sym player@ board!    \ set the floor tile at old pos
    player-sym rot rot          \ ( player-sym x y )
    2dup player!                \ set player position, leave x y
    ( player-sym x y ) board! ; \ set player tile at new position

: move ( dx dy -- )
    \ high level movement word, taking a direction
    \ and moving the player if the new position is valid
    player@ 2swap new-position \ get new x y coordinates
    2dup valid-position?       \ if these are valid
    if update-player           \ move to it
    else 2drop then ;          \ or restore the stack

\ hole words
10 constant #holes
create holes #holes 2* cells allot
: hole@ ( i -- x y ) 2* cells holes + 2@ ;
: hole! ( x y i -- ) 2* cells holes + 2! ;


\ robot words
\ we do have a maximum of 20 robots
20 constant #max-robots
\ we start with 2 robots
variable #robots  2 #robots !
\ robots occupy 3 cells: x y alive?
create robots #max-robots 3 * cells allot

: robot@ ( i -- x y ) \ return the x y position of the ith robot
    3 * cells robots + 2@ ;

: robot! ( x y i -- ) \ set the ith robot's postion to x y
    3 * cells robots + 2! ;

: robot-alive! ( t i -- ) \ set the alive flag to f for the ith robot
    3 * cells 2 cells + robots + ! ;
: robot-alive? ( i -- t ) \ return the alive flag for the ith robot
    3 * cells 2 cells + robots + @ ;

: #robots-alive ( -- n ) \ returns the numer of robots that are alive
    0                  \ always return something sensible
    #robots @ 0 ?do      \ we iterate over the current number of robots
        i robot-alive? \ it it is alive
        if 1+ then     \ count it
    loop ;

: update-robot ( x y i -- )    \ sets robot position and board tile
    >r                         \ save index for later usage
    floor-sym r@ robot@ board! \ replace the old place with floor tile
    r@ robot!                  \ update the robot
    robot-sym r@ robot@ board! \ robot tie on new pos
    r> drop ;                  \ clean stack

: distance ( x1 y1 x2 y2 -- x2-x1 y2-y1) \ returns the distance between two positions
    >r       \ save y2
    rot -    \ x2-x1
    r> rot - \ y2-y1
    swap ;   \ -> x' y'

: sign ( n1 -- n2 ) \ calculate the sign of a number
    dup 0=
    if
        drop 0    \ 0 -> 0
    else
        dup abs / \ n1 / (abs n1) -> -1 / 1
    then ;

: direction ( d1 d2 -- dx dy ) \ extract the direction from a given position
    sign swap sign ;

: towards-player ( x y -- x' y' ) \ return new position that moves one step toward the player's current pos
    2dup player@ distance direction new-position ;

: collision? ( x1 y1 x2 y2 -- f ) \ are the two positions the same?
    xy->board     \ get the index for the second position
    rot rot       \ move first position to TOS
    xy->board = ; \ convert to index and compare

: is-in-hole? ( x y -- f ) \ checks whether a given position is on a hole
    xy->board                  \ convert to index
    false                      \ initialise with false
    #holes 0 do
        over                   \ get a copy of the index
        i hole@ xy->board      \ is it on this hole?
        = or                   \ yes? if so or it
    loop swap drop ;           \ ( i f ) -> ( -- f )

: move-robot ( i -- ) \ move the i-th robot towards the player
    dup >r robot@ towards-player   \ get the new coords
    2dup is-in-hole?               \ fell into a hole
    if false r@ robot-alive!       \ yes, this is a dead robot
        floor-sym r> robot@ board! \ replace the old robot position with an empty tile
        2drop                      \ remove the wrong position again
    else
        r> update-robot            \ if alive update the robot's position and the board
    then ;

: move-robots ( -- ) \ highlevel word to move all robots towards player
    #robots @ 0 ?do
        i robot-alive?              \ if robot i is alive
        if i move-robot then loop ; \ move it towards player

: any-collision? ( -- f ) \ returns true if any robot caught the player
    false                               \ we assume that the player is well
    #robots @ 0                           \ for all robots
    ?do i robot-alive?                  \ is this robot alive
        if i robot@ player@  collision? \ has this robot caught the player?
            or                          \ set flag to true if so
        then loop ;

\ game routines init, loop
: init-robots ( -- ) \ place the current number of robots on the board and activate them
    #robots @ 0 ?do
        robot-sym random-xy 2dup i robot! board! \ place them on board and initialise position
        true i robot-alive! loop ;               \ switch them on

: init-holes ( -- ) \ randomly scatter holes on the board
    #holes 0 do hole-sym random-xy 2dup i hole! board! loop ;

: init-player ( -- ) \ place player on the board
    teleport-location          \ find a spot where the player can live
    2dup player! update-player \ update board tiles and player pos
    0 #moves !                 \ reset move counter
    3 #teleports ! ;           \ give the player 3 teleports

: reset-game ( -- ) \ sets up a new game with the current number of robots
    board-reset init-player init-robots init-holes ;
: status-line ( -- ) \ prints a status line on screen
    ." moves: "  #moves @ . ." teleports: " #teleports @ . ." robots: " #robots-alive . ;
: help ( -- ) \ prints a key legend on screen
    ." h: left, j: down, k: up, l: right, t: teleport, q: quit, any other key waits."  cr ;

: user-input ( -- ) \ waits for one key, then handles player movement
    key
    case
        [char] h of left move endof
        [char] j of down move endof
        [char] k of up move endof
        [char] l of right move endof
        [char] q of ." Thanks for playing! " cr bye endof
        [char] t of #teleports @ 0>
            if #teleports @ 1- #teleports !
                teleport-location 2dup
                update-player player! then endof
        10 of recurse endof
    endcase
    1 #moves +! ;

: run ( -- ) \ main loop and entry point
    2 #robots ! \ start with 2 robots
    reset-game
    begin
        board-print status-line cr help \ print the board
        #robots-alive 0=                \ are robots left?
        if ." You win!" cr              \ no, next round with more robots
            #max-robots #robots @ 1+ min #robots ! \ unless there are already #max-robots
            reset-game then
        any-collision?                  \ did they catch the player?
        if ." You died! " cr bye       \ yes, player dies
        else user-input then            \ handle user input
        move-robots                     \ robots move last
    again ;

here seed ! \ initialise PRNG
\ run \ start the game
