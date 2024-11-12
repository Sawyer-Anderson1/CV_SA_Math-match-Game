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
columnHeader: 	.asciiz "_| 0  1  2  3\n"
row0: 		.asciiz "0|\0", " + ", " + ", " + ", " + ", "\n\0\0"
row1:		.asciiz "1|\0", " + ", " + ", " + ", " + ", "\n\0\0"
row2:		.asciiz "2|\0", " + ", " + ", " + ", " + ", "\n\0\0"
row3:		.asciiz "3|\0", " + ", " + ", " + ", " + ", "\n\0\0"

# displayCardsR0:	.asciiz "3", "1x1", "1x2", "2x2"
# displayCardsR1:	.asciiz "1", "2", "1x3", "1x5"
# displayCardsR2:	.asciiz "4", "6", "5", "1x7"
# displayCardsR3:	.asciiz "4x2", "8", "7", "3x2" 

cardDisArr: 	.asciiz "4  ","2x2","6  ","2x3","8  ","2x4", "9  ", "3x3 ","10 ","2x5","12 ","3x4","15 ","3x5","16 ","4x4"

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
	
	la	$t1, row0
	li	$t0, 0
	
	row0Loop:
		add	$t2, $t1, $t0
		
		la 	$a0, 0($t2)      # Load address of each cell in row0   
    		syscall              # Print the cell content
    		
    		addi 	$t0, $t0, 4
    		
    	ble $t0, 20, row0Loop # Print all 5 elements in row
	
	la	$t1, row1
	li	$t0, 0
	
	row1Loop:
		add	$t2, $t1, $t0

		la 	$a0, 0($t2)      # Load address of each cell in row0   
  		syscall          
  		
  		addi 	$t0, $t0, 4
		
	ble	$t0, 20, row1Loop
	
	la	$t1, row2
	li	$t0, 0
	
	row2Loop:
		add	$t2, $t1, $t0

		la 	$a0, 0($t2)      # Load address of each cell in row0   
  		syscall          
  		
  		addi 	$t0, $t0, 4
		
	ble	$t0, 20, row2Loop
	
	la	$t1, row3
	li	$t0, 0
	
	row3Loop:
		add	$t2, $t1, $t0

		la 	$a0, 0($t2)      # Load address of each cell in row0   
  		syscall          
  		
  		addi 	$t0, $t0, 4
		
	ble	$t0, 20, row3Loop
	
	jr	$ra
