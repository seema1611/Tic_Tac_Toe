#! /bin/bash -x

echo "-----START TIC-TAC-TOE GAME-----"

#Declaration of the Board
declare -a gameBoard
declare -A corners
declare -A sides

#Constants
LIMIT=9

#Variable
isWinner=0
count=0

#Function to reset the board
function reset(){
   for((i=1; i<=LIMIT; i++))
   do
      gameBoard[i]=" "
   done
}

#Function to assign symbol for player and computer
function assignSymbolAndTurn() {
   if [ $((RANDOM%2)) -eq 0 ]
   then
      echo "Player turn first"
      playerMark=X
      computerMark=0
      switchPlayer=0
   else
      echo "Computer turn first"
      playerMark=0
      computerMark=X
      switchPlayer=1
   fi
   echo "Player Mark:"  $playerMark
   echo "Computer Mark:"  $computerMark
}

#Function to check winning conditions
function checkWinningConditions() {
   mark=$1
   isWinner=0

   #Check rows here
   for(( i=1; i<=LIMIT; i=$(($i+3 )) ))
   do
      if [[ ${gameBoard[$i]} == $mark ]] && [[ ${gameBoard[$i]} == ${gameBoard[$(($i+1))]} ]] && [[ ${gameBoard[$(($i+1))]} == ${gameBoard[$(($i+2))]} ]]
      then
         isWinner=1
      fi
   done

   #Check column here
   for(( i=1; i<=LIMIT; i++ ))
   do
      if [[ ${gameBoard[$i]} == $mark ]] && [[ ${gameBoard[$i]} == ${gameBoard[$(($i+3))]} ]] && [[ ${gameBoard[$(($i+3))]} == ${gameBoard[$(($i+6))]} ]]
      then
         isWinner=1
      fi
   done

   #Check diagonal here
   if [[ ${gameBoard[1]} == $mark ]] && [[ ${gameBoard[1]} == ${gameBoard[5]} ]] && [[ ${gameBoard[5]} == ${gameBoard[9]} ]]
   then
      isWinner=1
   elif [[ ${gameBoard[3]} == $mark ]] && [[ ${gameBoard[3]} == ${gameBoard[5]} ]] && [[ ${gameBoard[5]} == ${gameBoard[7]} ]]
   then
      isWinner=1
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

#Function to check winner
function checkWinner() {
   if [[ $isWinner == 1 ]]
   then
      echo "-----$1 is Won the game with $2 mark-----"
      exit
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

#Function to check win and move
function checkComputerWinner() {
   for(( winCount=1; winCount<=LIMIT; winCount++))
   do
      if [[ ${gameBoard[$winCount]} != $playerMark ]] && [[ ${gameBoard[$winCount]} != $computerMark ]]
      then
         gameBoard[$winCount]=$computerMark
         checkWinningConditions $computerMark
         if [[ $isWinner == 1 ]]
         then
            echo "Computer turn, move towards Winner: $winCount"
            displayBoard
         fi
         checkWinner "Computer" $playerMark
         gameBoard[$winCount]=$winCount
      fi
   done
}

#Function to play and block opponant
function checkComputerBlock() {
   for ((blockCount=1; blockCount<=$LIMIT; blockCount++))
   do
      if [[ ${gameBoard[$blockCount]} != $playerMark ]] && [[ ${gameBoard[$blockCount]} != $computerMark ]]
      then
         gameBoard[$blockCount]=$playerMark
         checkWinningConditions $playerMark
         if [[ $isWinner == 1 ]]
         then
            echo "Computer turn, move and Block: $blockCount"
            gameBoard[$blockCount]=$computerMark
            ((count++))
            displayBoard
            switchPlayer=0
            switchThePlayer
         else
            gameBoard[$blockCount]=$blockCount
         fi
      fi
   done
}

#Function to play at corners
function checkComputerCorner() {
   corners[1]=1
   corners[2]=3
   corners[3]=7
   corners[4]=9
   random=$((RANDOM%4+1))
   cornerPosition=${corners[$random]}

   if [[ ${gameBoard[$cornerPosition]} != $playerMark ]] && [[ ${gameBoard[$cornerPosition]} != $computerMark ]]
   then
      echo "Computer turn, move towards Corners: $cornerPosition"
      gameBoard[$cornerPosition]=$computerMark
      ((count++))
      displayBoard
      switchPlayer=0
      switchThePlayer
   else
      echo "The Position is not empty, Enter the again"
      checkComputerCorner $playerMark $computerMark
   fi
}

#Function to play at center
function checkComputerCenter() {
   center=5
   if [[ ${gameBoard[$center]} != $playerMark ]] && [[ ${gameBoard[$center]} != $computerMark ]]
   then
      gameBoard[5]=$computerMark
      echo "Computer turn, move towards center: $center"
      displayBoard
      switchPlayer=0
      switchThePlayer
   fi
}

#Function to play at sides
function checkComputerSide() {
   corners[1]=2
   corners[2]=4
   corners[3]=6
   corners[4]=8

   random=$((RANDOM%4+1))
   sidePosition=${sides[$random]}
   if [[ ${gameBoard[$sidePosition]} != $playerMark ]] && [[ ${gameBoard[$sidePosition]} != $computerMark ]]
   then
      echo "Computer turn, move towards sides: $sidePosition"
      gameBoard[$sidePosition]=$computerMark
      ((count++))
      displayBoard
      switchPlayer=0
      switchThePlayer
   else
      echo "The Position is not empty. enter the again"
      checkComputerSide $playerMark $computerMark
   fi
}

#Function to check position is empty or NOT and insert symbol
function checkEmpty() {
   position=$1
   if [[ $position -ge 1 ]] && [[ $position -le $LIMIT ]] && [[ ${gameBoard[$position]} != $playerMark ]] &&
		 [[ ${gameBoard[$position]} != $computerMark ]]
   then
      if [[ $switchSymbol -eq 1 ]]
      then
         gameBoard[$position]=$playerMark
      else
         gameBoard[$position]=$computerMark
      fi
      ((count++))
      displayBoard
   else
      echo "Either Position is not valid or not empty"
      switchThePlayer
   fi
}

#Function of player turn
function playerTurn() {
   read -p "Player turn, Enter the position: " playerPosition
   switchSymbol=1
   checkEmpty $playerPosition $playerMark $computerMark
   checkWinningConditions $playerMark
   checkWinner "Player" $playerMark
   switchPlayer=1
}

#Function of computer turn
function computerTurn() {
   checkComputerWinner
   checkComputerBlock
   checkComputerCorner
   checkComputerCenter
   checkComputerSide
   computerPosition=$((RANDOM%9+1))
   echo "Player turn, Enter the position: " computerPosition
   switchSymbol=1
   checkEmpty $computerPosition $playerMark $computerMark
   checkWinningConditions $computerMark
   checkWinner "Computer" $compuyterMark
   switchPlayer=1
}

#Function to switch the player
function switchThePlayer() {
   while [[ $count -ne $LIMIT ]]
   do
      if [[ $switchPlayer -eq 0 ]]		#switch player generated in assignSymbolandturn function
      then
         playerTurn
      else
         computerTurn
      fi
   done
   checkTie
}

#Main function
function main() {
   reset
   assignSymbolAndTurn
   displayBoard
   switchThePlayer
}
#Main function call
main
