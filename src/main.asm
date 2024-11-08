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

firstCard:	.word 0, 0
secondCard: 	.word 0, 0
amount:		.word 8
timer:		.word 0

#------------------
# Main program body
#------------------

.text
.globl	main, Prompt
main:
	lw	$s0, amount
	
Prompt: # reprompting for the input
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

	#the arguements for both MatchPrint and TempPrint	
		#card 1
	move	$a0, $t0
	move	$a1, $t1
		#card 2
	move 	$a2, $t2
	move	$a3, $t3
		
	#the if statement condition
	bne	$s2, $s1, Else
	
	If: 
		# decrementing the count
		addi	$s0, $s0, -1
		
		#the exit condition
		beq	$s0, -1, Exit # when all the cards have been matched a flipped
		
		j 	MatchPrint
	Else:
		li	$a0, 0 # 0 for not matching
		
		j	TempPrint
	
Exit: 
	li	$v0, 10
	syscall
