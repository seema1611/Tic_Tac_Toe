#! /bin/bash -x

#Declaration of the Board
declare -a gameBoard

#Constants
LIMIT=9

#Variable
isWinner=0
count=1
winCount=1
blockCount=1
cornerCount=1

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
   symbol=$1
   checkRows $symbol
   checkColumns $symbol
   checkDiagonals $symbol
}

#Function to check rows win or NOT
function checkRows() {
   mark=$1
   for(( i=1; i<=9; i=$(($i+3 )) ))
   do
      if [[ ${gameBoard[$i]} == $mark ]] && [[ ${gameBoard[$i]} == ${gameBoard[$(($i+1))]} ]] &&
		 [[ ${gameBoard[$(($i+1))]} == ${gameBoard[$(($i+2))]} ]]
      then
         isWinner=1
      fi
   done
}

#Function to check column win or NOT
function checkColumns() {
   mark=$1
   for(( i=1; i<=9; i++ ))
   do
      if [[ ${gameBoard[$i]} == $mark ]] && [[ ${gameBoard[$i]} == ${gameBoard[$(($i+3))]} ]] &&
		 [[ ${gameBoard[$(($i+3))]} == ${gameBoard[$(($i+6))]} ]]
      then
         isWinner=1
      fi
   done
}

#Function to check diagonal is win or not
function checkDiagonals() {
   mark=$1
   if [[ ${gameBoard[1]} == $mark ]] && [[ ${gameBoard[1]} == ${gameBoard[5]} ]] &&
		 [[ ${gameBoard[5]} == ${gameBoard[9]} ]]
   then
      isWinner=1
   elif [[ ${gameBoard[3]} == $mark ]] && [[ ${gameBoard[3]} == ${gameBoard[5]} ]] &&
		 [[ ${gameBoard[5]} == ${gameBoard[7]} ]]
   then
      isWinner=1
   fi
}

#Function to check winner
function checkWinner() {
   if [[ $isWinner == 1 ]]
   then
      echo "-----$1 is Won the game-----"
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
function checkComputerWin() {
   while [ $winCount == $LIMIT ]
   do
      if [[ ${gameBoard[$winCount]} != $playerMark ]] && [[ ${gameBoard[$winCount]} != $computerMark ]]
      then
         gameBoard[$winCount]=$computerMark
         checkWinningConditions $computerMark
         if [[ $isWinner == 1 ]]
         then
            echo "Computer turn, move and [Win]: $j"
            displayBoard
         fi
         checkWinner "Computer"
         gameBoard[$winCount]=$winCount
      fi
   ((winCount++))
   done
}

#Function to play and block opponant
function checkComputerBlock() {
   while [[ $blockCount == $LIMIT ]]
   do

      if [[ ${gameBoard[$blockCount]} != $playerMark ]] && [[ ${gameBoard[$blockCount]} != $computerMark ]]
      then
         gameBoard[$blockCount]=$playerMark
         checkWinningConditions $playerMark
         if [[ $isWinner == 1 ]]
         then
            echo "Computer turn, move and [Block]: $blockCount"
            gameBoard[$blockCount]=$computerMark
            ((count++))
            displayBoard
            switchPlayer=0
            switchThePlayer
         else
            gameBoard[$blockCount]=$blockCount
         fi
      fi
      ((blockCount++))
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
      echo "Computer turn, move towards CORNERS: $cornerPosition"
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

#Function to check position is empty or NOT and insert symbol
function checkEmptyForPlayer() {
   if [[ $playerPosition -ge 1 ]] && [[ $playerPosition -le $LIMIT ]] && [[ ${gameBoard[$playerPosition]} != $playerMark ]] &&
       [[ ${gameBoard[$playerPosition]} != $computerMark ]]
   then
      gameBoard[$playerPosition]=$playerMark
      ((count++))
      displayBoard
   else
      echo "Position is either not valid or not empty"
      switchThePlayer
   fi
}

#Function to check position is empty or NOT and insert symbol
function checkEmptyForComputer() {
   if [[ $computerPosition -ge 1 ]] && [[ $computerPosition -le $LIMIT ]] && [[ ${gameBoard[$computerPosition]} != $playerMark ]] &&
       [[ ${gameBoard[$computerPosition]} != $computerMark ]]
   then
      gameBoard[$computerPosition]=$computerMark
      ((count++))
      displayBoard
   else
      echo "Position is either not valid or not empty"
      switchThePlayer
   fi
}

#Function of player turn
function playerTurn() {
   read -p "Player turn, Enter the position: " playerPosition
   checkEmptyForPlayer $playerPosition $playerMark $computerMark
   checkWinningConditions $playerMark
   checkWinner "Player"
   switchPlayer=1
}

#Function of computer turn
function computerTurn() {
   checkComputerWin
   checkComputerBlock
   checkComputerCorner
   checkComputerCenter
   computerPosition=$((RANDOM%9 +1))
   echo "Computer turn, Enter the position: " $computerPosition
   checkEmptyForComputer $computerPosition $playerMark $computerMark
   checkWinningConditions $computerMark
   checkWinner "Computer"
   switchPlayer=0
}

#Function to switch the player
function switchThePlayer() {
   while [[ $count -ne $LIMIT ]]
   do
      if [[ $switchPlayer -eq 0 ]]
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
