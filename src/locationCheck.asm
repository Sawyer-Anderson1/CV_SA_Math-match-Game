#-----------------------------------------------------------
# Program File: locationCheck.asm
# Written by: Sawyer Anderson and Carlos Vazquez
# Date Created: 11/5/2024
# Description: The file that controls the board
#-----------------------------------------------------------
		.data

# cardsRow0:	.word 3, 1, 2, 4
# cardsRow1: 	.word 1, 2, 3, 5
# cardsRow2:	.word 4, 6, 5, 7
# cardsRow3:	.word 8, 8, 7, 6

cardValArr: 	.word 4, 4, 6, 6, 8, 8, 9, 9, 10, 10, 12, 12, 15, 15, 16, 16 # Array of card values

.text
.globl	locationCheck
locationCheck: # checks and goes to location in the array
	# a0: the row index
	# a1: the column index
	# t0: the row
	# t1: the index position for a row
	# t2: the value for loading which will be transfered to 
	# v0: returns value for cards 1 & 2
	
	beq	$a0, 0, Row0
	beq	$a0, 1, Row1
	beq	$a0, 2, Row2
	beq    	$a0, 3, Row3
	
	Row0: 
		lw	$t0, cardValArr
		
		mul	$t1, $a1, 4
		add	$t1, $t1, $t0
		
		j	Return
		
	Row1: 
		lw	$t0, cardValArr+16
		
		mul	$t1, $a1, 4
		add	$t1, $t1, $t0
		
		j	Return
		
	Row2: 
		lw	$t0, cardValArr+32
		
		mul	$t1, $a1, 4
		add	$t1, $t1, $t0
		
		j	Return
		
	Row3:
		lw	$t0, cardValArr+48
		
		mul	$t1, $a1, 4
		add	$t1, $t1, $t0
		
		j	Return
		
	Return:
		lw	$t2, 0($t1)
		add	$v0, $zero, $t2
		
		j	end
		
	end:
		jr	$ra
