#! /bin/bash -x

#Declaration of the Board
declare -a gameBoard

#Constants
LIMIT=9

#Function to reset the board
function reset(){
   for((i=1; i<=LIMIT; i++))
   do
      gameBoard[i]=" "
   done
}
reset
