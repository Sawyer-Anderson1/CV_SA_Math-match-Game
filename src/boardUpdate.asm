#-----------------------------------------------------------
# Program File: boardUpdate.asm
# Written by: Sawyer Anderson and Carlos Vazquez
# Date Created: 9/12/2024
# Description: The file that controls the board
#-----------------------------------------------------------

#-----------------------
# Declare some constants
#-----------------------
		.data

prompt:		.asciiz "Enter a row index 0-3 and a column index 0-3: "
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
.globl boardUpdate

boardUpdate:
	beq	$t0, 1, MatchPrint
	#else flip for a bit then return
	
	TempPrint: # showing the cards choosen, if they don't match
		# probably will make this another file?
		j	Prompt
	
	MatchPrint: # permanantly change the board, maybe this will be be another file, with TempPrint
		# t0: the firstCard (the row index)
		# t1: the column index for the first card
		# t2: the secondCard (the row index)
		# t3: the column index for the second card
		
		li	$v0, 4
		la	$a0, matchIndicator
		syscall
		
		# lw	$t0, firstCard
		# lw	$t1, 4($t0) # the column index for the first card
		# add	$a0, $zero, $t0
		# add	$a1, $zero, $t1
		# addi	$a2, $zero, 2 # the value that indicates that we are changing the board
		
		# jal	locationCheck
		
		# lw	$t2, secondCard
		# lw	$t3, 4($t2) # the column index for the second card
		# add	$a0, $zero, $t2
		# add	$a1, $zero, $t3
		# addi	$a2, $zero, 2 # the value that indicates that we are changing the board
		
		# jal	locationCheck
		
		# jal	TimerPause
		# move	$s2, $v0
		# sw	$s2, timer

	j	cardCheck
