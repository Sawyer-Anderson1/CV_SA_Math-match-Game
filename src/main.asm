#-----------------------------------------------------------
# Program File: main.asm
# Written by: Sawyer Anderson and Carlos Vazquez
# Date Created: 11/7/2024
# Description: The file that gets input (Prompt) and calls
#        the locationCheck timer, DataRand, and boardUpdate files/subroutines
#-----------------------------------------------------------

#-----------------------
# Declare some constants
#-----------------------
		.data

prompt:		.asciiz "Enter a row index 0-3 and a column index 0-3: "
gameFinished: 	.asciiz "You won!\n"
sameCardErr:	.asciiz	"Error: Same card position, please enter again with different positions\n"
boundsErr:	.asciiz	"Error: Out of bounds, please enter integers 0-3\n"
firstCard:	.word 0, 0
secondCard: 	.word 0, 0
amount:		.word 8
timer:		.word 0

#------------------
# Main program body
#------------------

.text
.globl	main, Prompt, timer

# Notable registers:
#	s3: holds the returned address of the newIndArr from the randomizor
main:
	lw	$s0, amount
	
	# Record start time
	li 	$v0, 30              # Syscall: get runtime 
	syscall
	sw	$a0, timer		# Store lo 32 bits of end time
	
	# call the randomizor
	jal 	DataRand
	addi	$s3, $v0, 0
	
Prompt: # reprompting for the input
	#the exit condition
	beq	$s0, 0, Exit # when all the cards have been matched a flipped
	
	jal	currBoard
	
	li	$v0, 4
	la	$a0, prompt
	syscall
	
	li	$v0, 5
	syscall
	move	$t0, $v0
	sw	$t0, firstCard
	
	li	$v0, 5
	syscall
	move	$t1, $v0
	sw	$t1, firstCard+4
	
	li	$v0, 4
	la	$a0, prompt
	syscall
	
	li	$v0, 5
	syscall
	move	$t2, $v0
	sw	$t2, secondCard
		
	li	$v0, 5
	syscall
	move	$t3, $v0
	sw	$t3, secondCard+4
	
	#Check if inputs are out of bounds
	ble 	$t0, 3, Continue1
	ble	$t1, 3, Continue1	
	ble 	$t2, 3, Continue1
	ble	$t3, 3, Continue1
	
	li	$v0, 4		# if so
	la	$a0, boundsErr	# Print sameCardErr, inputted postions are the same, try again.
    	syscall 
	j 	Prompt
	
	Continue1:
	#Check if same card, row and col
	bne 	$t0, $t2, Continue2	# Continue print if rows are not equal
	bne	$t1, $t3, Continue2	# Continue print if columns are not equal
	
	li	$v0, 4			# if so
	la	$a0, sameCardErr	# Print sameCardErr, inputted postions are the same, try again.
    	syscall 
	j 	Prompt
	
	Continue2:
	
cardCheck:	
	# t0: the firstCard (the row index)
	# t1: the column index for the first card
	# t2: the secondCard (the row index)
	# t3: the column index for the second card
	# v0: the value of card 1 & 2
	
	lw	$t0, firstCard
	lw	$t1, firstCard+4 #the column index for the first card
	add	$a0, $zero, $t0 # the arugment for the subroutine call
	add	$a1, $zero, $t1 # the second 
	# li	$a2, 0 # the argument that indicates that the operation is loading for first card
	
	jal	locationCheck # jumping to the subroutine
	move	$s2, $v0
	
	lw	$t2, secondCard
	lw	$t3, secondCard+4 #the column index for the second card
	add	$a0, $zero, $t2
	add	$a1, $zero, $t3
	#li	$a2, 0 # the value that indicates the second card
	
	jal	locationCheck # jumping to the subroutine
	move	$s1, $v0
	
	#the if statement condition
	bne	$s2, $s1, Else
	
	If: 
		# decrementing the count
		addi	$s0, $s0, -1
		
		lw	$t0, firstCard
		lw	$t1, firstCard+4 #the column index for the first card
		move	$a0, $t0 # the arugment for the subroutine call
		move	$a1, $t1 # the second 
		
		lw	$t2, secondCard
		lw	$t3, secondCard+4 #the column index for the second card
		move	$a2, $t2
		move	$a3, $t3
		
		jal 	MatchPrint
		jal	CurrTime
		j 	Prompt
	Else:
		li	$a0, 0 # 0 for not matching
		
		lw	$t0, firstCard
		lw	$t1, firstCard+4 #the column index for the first card
		move	$a0, $t0 # the arugment for the subroutine call
		move	$a1, $t1 # the second 
		
		lw	$t2, secondCard
		lw	$t3, secondCard+4 #the column index for the second card
		move	$a2, $t2
		move	$a3, $t3
		
		jal	TempPrint
		jal	CurrTime
		j	Prompt
Exit: 
	li	$v0, 4
	la	$a0, gameFinished
	syscall
	
	jal	CurrTime
	
	li	$v0, 10
	syscall
