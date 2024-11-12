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
	# a2: 0, 1, or 2 for the loading and storing (changing the board)
		# 0 is for getting value of card 1 & 2
		# 1 is for changing board
	# t0: the row
	# t1: the index position for a row
	# t2: the value for loading which will be transfered to 
	# v0: returns value for cards 1 & 2
	
	beq	$a0, 0, Row0
	beq	$a0, 1, Row1
	beq	$a0, 2, Row2
	beq    	$a0, 3, Row3
	
	Row0: 
		la	$t0, cardValArr
		
		mul	$t1, $a1, 4
		add	$t1, $t1, $t0
		
		beq	$a2, 0, Return_1
		
	Row1: 
		la	$t0, cardValArr+16
		
		mul	$t1, $a1, 4
		add	$t1, $t1, $t0
		
		beq	$a2, 0, Return_1
		
	Row2: 
		la	$t0, cardValArr+32
		
		mul	$t1, $a1, 4
		add	$t1, $t1, $t0
		
		beq	$a2, 0, Return_1
		
	Row3:
		la	$t0, cardValArr+48
		
		mul	$t1, $a1, 4
		add	$t1, $t1, $t0
		
		beq	$a2, 0, Return_1
		
	Return_1:
		lw	$t2, 0($t1)
		add	$v0, $zero, $t2
		
		j	end
		
	end:
		jr	$ra
