#-----------------------------------------------------------
# Program File: main.asm
# Written by: Sawyer Anderson and Carlos Vazquez
# Date Created: 11/7/2024
# Description: The file that gets input (Prompt) and calls
#        the locationCheck and boardUpdate files/subroutines
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

firstCard:	.word 0, 0
secondCard: 	.word 0, 0
amount:		.word 8
timer:		.word 0

displayCardsR0:	.asciiz "3", "1x1", "1x2", "2x2"
displayCardsR1:	.asciiz "1", "2", "1x3", "1x5"
displayCardsR2:.asciiz "4", "6", "5", "1x7"
displayCardsR3:.asciiz "4x2", "8", "7", "3x2" 

cardsRow0:	.word 3, 1, 2, 4
cardsRow1: 	.word 1, 2, 3, 5
cardsRow2:	.word 4, 6, 5, 7
cardsRow3:	.word 8, 8, 7, 6

#------------------
# Main program body
#------------------

.text
.globl	main, cardCheck, Exit
main:
	lw	$s0, amount
	
Prompt: # reprompting for the input
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
	
	li	$v0, 4
	la	$a0, prompt
	syscall
	
	li	$v0, 5
	syscall
	move	$t0, $v0
	sw	$t0, firstCard
	
	li	$v0, 5
	syscall
	move	$t0, $v0
	sw	$t0, firstCard+4
	
	li	$v0, 4
	la	$a0, prompt
	syscall
	
	li	$v0, 5
	syscall
	move	$t0, $v0
	sw	$t0, secondCard
		
	li	$v0, 5
	syscall
	move	$t0, $v0
	sw	$t0, secondCard+4
		
		
	# lw	$s2, timer
	# move	$a0, $s2
	# jal	Timer
		
cardCheck:	
	# t0: the firstCard (the row index)
	# t1: the column index for the first card
	# t2: the secondCard (the row index)
	# t3: the column index for the second card
	# v0: the value of card 1
	# v1: the value of card 2
	
	lw	$t0, firstCard
	lw	$t1, firstCard+4 #the column index for the first card
	add	$a0, $zero, $t0 # the arugment for the subroutine call
	add	$a1, $zero, $t1 # the second 
	li	$a2, 0 # the argument that indicates that the operation is loading for first card
	
	jal	locationCheck # jumping to the subroutine
	move	$s2, $v0
	
	lw	$t2, secondCard
	lw	$t3, secondCard+4 #the column index for the second card
	add	$a0, $zero, $t2
	add	$a1, $zero, $t3
	li	$a2, 0 # the value that indicates the second card
	
	jal	locationCheck # jumping to the subroutine
	move	$s1, $v0
	
	#goes to the if statement
	bne	$s2, $s1, Else
	
	If: 
		li	$t0, 1 # 1 for matching
		# decrementing the count
		addi	$s0, $s0, -1
		
		j 	boardUpdate
	Else:
		li	$t0, 0 # 0 for not matching
		
		j	boardUpdate
	#beq	$t0, $zero, _boardUpdate
	
Exit: 
	li	$v0, 10
	syscall
