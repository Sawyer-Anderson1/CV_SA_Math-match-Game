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
prompt:		.asciiz "Enter a row index 0-3 and a column index 0-3: "
matchIndicator: .asciiz "Match!\n"
columnHeader: 	.asciiz "_|0 1 2 3\n"
row0: 		.asciiz "0|+ + + +\n"
row1:		.asciiz "1|+ + + +\n"
row2:		.asciiz "2|+ + + +\n"
row3:		.asciiz "3|+ + + +\n"

firstCard:	.word 0, 0
secondCard: 	.word 0, 0
amount:		.word 8

displayCardsR0:	.asciiz "3", "1x1", "1x2", "2x2"
displayCardsR1:	.asciiz "1", "2", "1x3", "1x5"
displayCardsR2:.asciiz "4", "6", "5", "1x7"
displayCardsR3:.asciiz "4x2", "8", "7", "3x2" 

cardsRow0:	.word 3, 1, 2, 4
cardsRow1: 	.word 1, 2, 3, 5
cardsRow2:	.word 4, 6, 5, 7
cardsRow3:	.word 8, 8, 7, 6

#------------------
# Main program body
#------------------

.text
main:
	lw	$s0, amount
	
	addi	$a0, $zero, 0 # this is the arguement that indicates that no correct flips
	jal	_boardUpdate
	
cardCheck:	
	# t0: the firstCard (the row index)
	# t1: the column index for the first card
	# t2: the secondCard (the row index)
	# t3: the column index for the second card
	# v0: the value of card 1
	# v1: the value of card 2
	
	lw	$t0, firstCard
	lw	$t1, firstCard+4 #the column index for the first card
	add	$a0, $zero, $t0 # the arugment for the subroutine call
	add	$a1, $zero, $t1 # the second 
	addi	$a2, $zero, 0 # the argument that indicates that the operation is loading for first card
	
	jal	locationCheck # jumping to the subroutine
	
	lw	$t2, secondCard
	lw	$t3, secondCard+4 #the column index for the second card
	add	$a0, $zero, $t2
	add	$a1, $zero, $t3
	addi	$a2, $zero, 1 # the value that indicates the second card
	
	jal	locationCheck # jumping to the subroutine
	
	move	$s0, $v0
	move	$s1, $v1
	
	#goes to the if statement
	beq	$s0, $s1, If
	j	Else
	
	If: 
		addi	$a0, $a0, 1 # 1 for matching
		# decrementing the count
		addi	$s0, $s0, -1
		
		jal _boardUpdate
	Else:
		addi	$a0, $a0, 0 # 0 for not matching
	
	#beq	$t0, $zero, _boardUpdate
	
	jal	_boardUpdate

_boardUpdate:
	
	beq	$s0, 0, exit # when all the cards have been matched a flipped
	
	beq	$a0, 1, MatchPrint
	#else flip for a bit then return
	
	j	MatchPrint
	
	TempPrint: # showing the cards choosen, if they don't match
		
		j	Prompt
	
	MatchPrint: # permanantly change the board
		# t0: the firstCard (the row index)
		# t1: the column index for the first card
		# t2: the secondCard (the row index)
		# t3: the column index for the second card
		
		li	$v0, 4
		la	$a0, matchIndicator
		syscall
		
		# lw	$t0, firstCard
		# lw	$t1, 4($t0) # the column index for the first card
		# add	$a0, $zero, $t0
		# add	$a1, $zero, $t1
		# addi	$a2, $zero, 2 # the value that indicates that we are changing the board
		
		# jal	locationCheck
		
		# lw	$t2, secondCard
		# lw	$t3, 4($t2) # the column index for the second card
		# add	$a0, $zero, $t2
		# add	$a1, $zero, $t3
		# addi	$a2, $zero, 2 # the value that indicates that we are changing the board
		
		# jal	locationCheck
	
	Prompt: # reprompting for the input
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
	
	j	cardCheck
	
locationCheck: # checks and goes to location in the array
	# a0: the row index
	# a1: the column index
	# a2: 0, 1, or 2 for the loading and storing (changing the board)
		# 0 is for getting value of card 1
		# 1 is for getting value of card 2
		# 2 is for changing board
	# t0: the row
	# t1: the index position for a row
	# t2: the value for loading which will be transfered to 
	# v0: returns value for card 1
	# v1: returns value for card 2
	
	beq	$a0, 0, Row0
	beq	$a0, 1, Row1
	beq	$a0, 2, Row2
	beq    	$a0, 3, Row3
	
	Row0: 
		la	$t0, cardsRow0
		
		sll	$t1, $a1, 2
		add	$t0, $t0, $t1
		
		beq	$a2, 0, Return_1
		beq	$a2, 1, Return_2
		
		j	alteringBoard
		
	Row1: 
		la	$t0, cardsRow1
		
		sll	$t1, $a1, 2
		add	$t0, $t0, $t1
		
		beq	$a2, 0, Return_1
		beq	$a2, 1, Return_2
		
		j	alteringBoard
		
	Row2: 
		la	$t0, cardsRow2
		
		sll	$t1, $a1, 2
		add	$t0, $t0, $t1
		
		beq	$a2, 0, Return_1
		beq	$a2, 1, Return_2
		
		j	alteringBoard
		
	Row3:
		la	$t0, cardsRow0
		
		sll	$t1, $a1, 2
		add	$t0, $t0, $t1
		
		beq	$a2, 0, Return_1
		beq	$a2, 1, Return_2
		
		j	alteringBoard
		
	Return_1:
		lw	$t2, 0($t0)
		add	$v0, $zero, $t2
		
		j	end
	
	Return_2:
		lw	$t2, 0($t0)
		add	$v1, $zero, $t2
		
		j	end
		
	alteringBoard:
		j	end
		
	end:
		jr	$ra
exit: 
	li	$v0, 10
	syscall
