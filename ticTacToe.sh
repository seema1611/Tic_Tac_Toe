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

#Function to assign symbol for player and computer
function assignSymbol() {
   if [ $((RANDOM%2)) -eq 0 ]
   then
      playerMark=X
      computerMark=0
   else
      playerMark=0
      computerMark=X
   fi

   echo "Player Mark:"  $playerMark
   echo "Computer Mark:"  $computerMark
}
reset
assignSymbol
