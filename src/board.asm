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
.include 
#------------------
# Main program body
#------------------
.text
bne $t0, #, boardUpdate

boardUpdate:
bne $t0, #, boardUpdate

