#-----------------------------------------------------------
# Program File: board.asm
# Written by: Sawyer Anderson and Carlos Vazquez
# Date Created: 9/12/2024
# Description: The file that controls the board
#-----------------------------------------------------------

#-----------------------
# Declare some constants
#-----------------------
		.data

matchIndicator: .asciiz "Match!\n"
columnHeader: 	.asciiz "_|0 1 2 3\n"
row0: 		.asciiz "0|+ + + +\n"
row1:		.asciiz "1|+ + + +\n"
row2:		.asciiz "2|+ + + +\n"
row3:		.asciiz "3|+ + + +\n"

displayCardsR0:	.asciiz "3", "1x1", "1x2", "2x2"
displayCardsR1:	.asciiz "1", "2", "1x3", "1x5"
displayCardsR2:.asciiz "4", "6", "5", "1x7"
displayCardsR3:.asciiz "4x2", "8", "7", "3x2" 

#------------------
# Main program body
#------------------

.text
.globl TempPrint, MatchPrint, currBoard

# Registers for TempPrint/MatchPrint:
#	a0: the firstCard (the row index)
# 	a1: the column index for the first card
# 	a2: the secondCard (the row index)
#	a3: the column index for the second card

TempPrint: # showing the cards choosen, if they don't match
	
	j	Prompt
	
MatchPrint: # permanantly change the board
		
	li	$v0, 4
	la	$a0, matchIndicator
	syscall
		
	j	Prompt
	
	
# Registers for boardUpdate:
# 	

currBoard:
	li	$v0, 4
	la	$a0, columnHeader
	syscall
	la	$a0, row0
	syscall
	la	$a0, row1
	syscall
	la	$a0, row2
	syscall
	la	$a0, row3
	syscall
	
	jr	$ra
