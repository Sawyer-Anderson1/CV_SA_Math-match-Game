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
columnHeader: 	.asciiz "_|0 1 2 3\n"
row0: 		.asciiz "0|+ + + +\n"
row1:		.asciiz "1|+ + + +\n"
row2:		.asciiz "2|+ + + +\n"
row3:		.asciiz "3|+ + + +\n"

#------------------
# Main program body
#------------------
.text
main: #dummy main
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
#li	$v0, 4
#la	$s0, row3
#syscall
#boardUpdate:
#bne $t0, 5, boardUpdate #will change the amount it iterates when we get to working on the other files in the furtue
