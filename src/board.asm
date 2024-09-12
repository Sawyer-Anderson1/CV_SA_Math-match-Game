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
columnHeader: 	.asciiz "_|0 1 2 3"
rowHeader: 	.asciiz "0|+ + + +"
			"1|+ + + +"
			"2|+ + + +"
			"3|+ + + +"

#------------------
# Main program body
#------------------
.text
main:
li $v0, 4
la $a0, string1
syscall
la $a0, string2
syscall
li $t0, 1
loop:
li $v0, 4
la $a0, string3
syscall
li $v0, 1
move $a0, $t0
syscall
addi $t0, $t0, 1
bne $t0, 4, loop
#-----
# Halt
#-----
li $v0, 10
syscall
