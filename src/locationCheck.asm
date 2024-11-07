#-----------------------------------------------------------
# Program File: locationCheck.asm
# Written by: Sawyer Anderson and Carlos Vazquez
# Date Created: 11/5/2024
# Description: The file that controls the board
#-----------------------------------------------------------
		.data

cardsRow0:	.word 3, 1, 2, 4
cardsRow1: 	.word 1, 2, 3, 5
cardsRow2:	.word 4, 6, 5, 7
cardsRow3:	.word 8, 8, 7, 6

.text
.globl	locationCheck, Row0, Row1, Row2, Row3, Return_1, end
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
		la	$t0, cardsRow0
		
		mul	$t1, $a1, 4
		add	$t1, $t1, $t0
		
		beq	$a2, 0, Return_1
		
		j	alteringBoard
		
	Row1: 
		la	$t0, cardsRow1
		
		mul	$t1, $a1, 4
		add	$t1, $t1, $t0
		
		beq	$a2, 0, Return_1
		
		j	alteringBoard
		
	Row2: 
		la	$t0, cardsRow2
		
		mul	$t1, $a1, 4
		add	$t1, $t1, $t0
		
		beq	$a2, 0, Return_1
		
		j	alteringBoard
		
	Row3:
		la	$t0, cardsRow3
		
		mul	$t1, $a1, 4
		add	$t1, $t1, $t0
		
		beq	$a2, 0, Return_1
		
		j	alteringBoard
		
	Return_1:
		lw	$t2, 0($t1)
		add	$v0, $zero, $t2
		
		j	end
	
	alteringBoard:
		j	end
		
	end:
		jr	$ra
