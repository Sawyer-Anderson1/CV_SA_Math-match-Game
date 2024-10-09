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
	lw 	$s2, cards
	lw	$s3, displayCards
	
	addi	$a0, $zero, 0 # this is the arguement that indicates that no correct flips
	jal	_boardUpdate
	
cardCheck:
	
	
	#$s4 for the boolean
	
	#if card1 == card2:
	#	boolean = 1
	#else:
	#	boolean = 0
	
	lw	$t0, firstCard
	lw	$t2, secondCard
	lw	$t6, 4($t0) #the column index for the first card
	lw	$t7, 4($t2) #the column index for the second card
	
	# $t3 and $t4 for the values of the cards
	# finding the row for card one, and then its values
	beq	$t0, 0, Row0
	beq	$t0, 1, Row1
	beq	$t0, 2, Row2
	beq    	$t0, 3, Row3
	
	Row0: 
		lw	$t5, cardsRow0
		
		sll	$t6, $t6, 2
		add	$t5, $t5, $t6
		lw	$t3, 0($t5)
		
		j	Card2
	Row1: 
		lw	$t5, cardsRow1
		
		sll	$t6, $t6, 2
		add	$t5, $t5, $t6
		lw	$t3, 0($t5)
		
		j	Card2
	Row2: 
		lw	$t5, cardsRow2
		
		sll	$t6, $t6, 2
		add	$t5, $t5, $t6
		lw	$t3, 0($t5)
		
		j	Card2
	Row3:
		lw	$t5, cardsRow0
		
		sll	$t6, $t6, 2
		add	$t5, $t5, $t6
		lw	$t3, 0($t5)
	
	Card2:
	#card 2
	beq	$t2, 0, Row0
	beq	$t2, 1, Row1
	beq	$t2, 2, Row2
	beq    	$t2, 3, Row3
	
	Row0: 
		lw	$t5, cardsRow0
		
		sll	$t7, $t7, 2
		add	$t5, $t5, $t7
		lw	$t4, 0($t5)
		
		j	Resume
	Row1: 
		lw	$t5, cardsRow1
		
		sll	$t7, $t7, 2
		add	$t5, $t5, $t7
		lw	$t4, 0($t5)
		
		j	Resume
	Row2: 
		lw	$t5, cardsRow2
		
		sll	$t7, $t7, 2
		add	$t5, $t5, $t7
		lw	$t4, 0($t5)
		
		j	Resume
	Row3:
		lw	$t5, cardsRow0
		
		sll	$t7, $t7, 2
		add	$t5, $t5, $t7
		lw	$t4, 0($t5)
	
	Resume:
	#goes to the if statement
	beq	$t4, $t3, If
	j	Else
	
	If: 
		addi	$a0, $a0, 1 # 1 for matching
		# incrementing the count
		addi	$s0, $s0, 1
		
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
	
	TempPrint: 
		
		j	Prompt
	
	MatchPrint: # permanantly change the board
	
		lw	$t0, firstCard
		lw	$t2, secondCard
		lw	$t6, 4($t0) #the column index for the first card
		lw	$t7, 4($t2) #the column index for the second card
	
		# $t3 and $t4 for the values of the cards
		# finding the row for card one, and then its values
		beq	$t0, 0, Row0
		beq	$t0, 1, Row1
		beq	$t0, 2, Row2
		beq    	$t0, 3, Row3
	
		Row0: 
			lw	$t5, displayCardsR0
		
			sll	$t6, $t6, 2
			add	$t5, $t5, $t6
			lw	$t3, 0($t5)
		
			j	Card2
		Row1: 
			lw	$t5, displayCardsR1
		
			sll	$t6, $t6, 2
			add	$t5, $t5, $t6
			lw	$t3, 0($t5)
		
			j	Card2
		Row2: 
			lw	$t5, displayCardsR2
		
			sll	$t6, $t6, 2
			add	$t5, $t5, $t6
			lw	$t3, 0($t5)
		
			j	Card2
		Row3:
			lw	$t5, displayCardsR3
		
			sll	$t6, $t6, 2
			add	$t5, $t5, $t6
			lw	$t3, 0($t5)
	
		Card2:
		#card 2
		beq	$t2, 0, Row0
		beq	$t2, 1, Row1
		beq	$t2, 2, Row2
		beq    	$t2, 3, Row3
	
		Row0: 
			lw	$t5, displayCardsR0
		
			sll	$t7, $t7, 2
			add	$t5, $t5, $t7
			lw	$t4, 0($t5)
		
			j	Resume
		Row1: 
			lw	$t5, displayCardsR1
		
			sll	$t7, $t7, 2
			add	$t5, $t5, $t7
			lw	$t4, 0($t5)
		
			j	Resume
		Row2: 
			lw	$t5, displayCardsR2
		
			sll	$t7, $t7, 2
			add	$t5, $t5, $t7
			lw	$t4, 0($t5)
		
			j	Resume
		Row3:
			lw	$t5, displayCardsR3
		
			sll	$t7, $t7, 2
			add	$t5, $t5, $t7
			lw	$t4, 0($t5)

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
	
	Prompt:
	
		la	$a0, prompt
		syscall
	
		li	$v0, 1
		syscall
		move	$t0, $v0
		lw	$t0, 0(firstCard)
	
		li	$v0, 1
		syscall
		move	$t0, $v0
		lw	$t0, 4(firstCard)
	
		la	$a0, prompt
		syscall
	
		li	$v0, 1
		syscall
		move	$t0, $v0
		lw	$t0, 0(secondCard)
	
		li	$v0, 1
		syscall
		move	$t0, $v0
		lw	$t0, 4(secondCard)
	
	j	cardCheck
	
exit: 
	li	$v0, 10
	syscall

