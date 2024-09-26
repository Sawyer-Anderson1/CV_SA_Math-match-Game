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
prompt		.asciiz "Enter a row index 0-3 and a column index 0-3: "
columnHeader: 	.asciiz "_|0 1 2 3\n"
row0: 		.asciiz "0|+ + + +\n"
row1:		.asciiz "1|+ + + +\n"
row2:		.asciiz "2|+ + + +\n"
row3:		.asciiz "3|+ + + +\n"

i_index:	.word 0
j_index: 	.word 0
count:		.word 0
amount:		.word 8

displayCards:	.asciiz "3", "1x1", "1x2", "2x2", "1", "2", "1x3", "1x5", "4", "6", "5", "1x7", "4x2", "8", "7", "3x2" 
cards:		.word 3, 1, 2, 4, 1,  2, 3, 5, 4, 6, 5, 7, 8, 8, 7, 6
		     #0  1  2  3  4  5  6  7  8  9  10 11 12 13 14 15
		 #row:0  0  0  0  1  1  1  1  2  2  2  2  3  3  3  3
	     #column:0  1  2  3  0  1  2  3  0  1  2  3  0  1  2  3

#------------------
# Main program body
#------------------

.text
main:
	lw	$s0, count
	lw	$s1, amount
	lw 	$s2, cards
	
	j	_boardUpdate
	
cardCheck:
	
	#$t0 for the boolean
	
	#if card1 == card2:
	#	boolean = 1
	#else:
	#	boolean = 0
	
	beq	$t0, $zero, _boardUpdate
	
	# incrementing the count
	addi	$s0, $s0, 1
	
	j	_boardUpdate

_boardUpdate:
	beq	$s0, $s1, exit 	# if count == amount, go to exit

	# Prints the board
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
	
	# Prompts the player for row and column input
	la	$a0, prompt
	syscall
	# Reads and stores row input to i_index
	li	$v0, 1
	syscall
	move	$t0, $v0
	sw	$t0, i_index
	# Reads and stores column input to j_index
	li	$v0, 1
	syscall
	move	$t0, $v0
	sw	$t0, j_index
	
	j	cardCheck	

#------
# Halt
#------
Exit:
	li $v0, 10
	syscall		# calls the system to exit
