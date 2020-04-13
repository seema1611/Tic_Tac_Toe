#! /bin/bash -x

#Declaration of the Board
declare -a gameBoard

#Constants
LIMIT=9

#Variable
isWinner=0

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

#Function to check who plays first
function whoPlayFirst() {
   if [ $((RANDOM%2)) -eq 0 ]
   then
      echo "Player turn first"
   else
      echo "Computer turn first"
   fi
}

#Function to display board
function displayBoard() {

   for ((i=1; i<=9; i+=3))
   do
      echo "---------------------"
      echo " |  ${gameBoard[$i]}  |  ${gameBoard[$(($i+1))]}  |  ${gameBoard[$(($i+2))]}  | "
   done
   echo "---------------------"
}

#Function to check winning conditions
function checkWinningConditions() {
   checkRows
   checkColumns
   checkDiagonals

   if [[ $isWinner == 1 ]]
   then
      echo "$1 is Won the game"
      exit
   fi
}

#Function to check rows win or NOT
function checkRows() {
   for(( i=1; i<=9; i=$(($i+3 )) ))
   do

      if [[ ${gameBoard[$i]} == $playerMark ]] && [[ ${gameBoard[$i]} == ${gameBoard[$(($i+1))]} ]] &&
		 [[ ${gameBoard[$(($i+1))]} == ${gameBoard[$(($i+2))]} ]]
      then
         isWinner=1
      fi

   done
}

#Function to check column win or NOT
function checkColumns() {
   for(( i=1; i<=9; i++ ))
   do

      if [[ ${gameBoard[$i]} == $playerMark ]] && [[ ${gameBoard[$i]} == ${gameBoard[$(($i+3))]} ]] &&
		 [[ ${gameBoard[$(($i+3))]} == ${gameBoard[$(($i+6))]} ]]
      then
         isWinner=1
      fi

   done
}

#Function to check diagonal is win or not
function checkDiagonals() {
   if [[ ${gameBoard[1]} == $playerMark ]] && [[ ${gameBoard[1]} == ${gameBoard[5]} ]] &&
		 [[ ${gameBoard[5]} == ${gameBoard[9]} ]]
   then
      isWinner=1
   elif [[ ${gameBoard[3]} == $playerMark ]] && [[ ${gameBoard[3]} == ${gameBoard[5]} ]] &&
		 [[ ${gameBoard[5]} == ${gameBoard[7]} ]]
   then
      isWinner=1
   fi
}

#Function to check tie is happened or NOT
function checkTie() {
   if [[ $count -eq $LIMIT ]]
   then
      echo "Tie Happened"
      exit
   fi
}

#Function to check position is empty or NOT and insert symbol
function checkEmpty() {
   if [[ $position -ge 1 ]] && [[ $position -le 9 ]]
   then

      if [[ ${gameBoard[$position]} != $playerMark ]]
      then
         gameBoard[$position]=$playerMark
         ((count++))
      else
         echo "Position if full"
      fi

   else
      echo "Invalid Position"
   fi
}

#Main function
function main() {
   reset
   assignSymbol
   whoPlayFirst
   displayBoard
   while [[ $count -ne $LIMIT ]]
   do
      read -p "Enter the position number between 1-9: " position
      checkEmpty
      displayBoard
      checkWinningConditions "Player"
   done
   checkTie
}

#Function call
main
