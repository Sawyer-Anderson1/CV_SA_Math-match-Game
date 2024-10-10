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
promptC1:	.asciiz "Card 1, Enter a row index 0-3 and a column index 0-3: "
promptC2:	.asciiz "Card 2, Enter a row index 0-3 and a column index 0-3: "
promptMatch: 	.asciiz "Cards Match!!\n"

columnHeader: 	.asciiz "_|0 1 2 3\n"
row0: 		.asciiz "0|+ + + +\n"
row1:		.asciiz "1|+ + + +\n"
row2:		.asciiz "2|+ + + +\n"
row3:		.asciiz "3|+ + + +\n"

firstCard:	.word 0, 0
secondCard: 	.word 0, 0
remMatches:	.word 8

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
	# load needed lables into registers
	lw	$s0, remMatches
	# lw 	$s2, cards		(No cards label)
	# lw	$s3, displayCards	(displayCards was split into rows)
	
	addi	$a0, $zero, 0 # $a0 arguement indicates there were no correct flips
	jal	_boardUpdate
	
cardCheck:
	#$s4 for the boolean
	
	#if card1 == card2:
	#	boolean = 1
	#else:
	#	boolean = 0
	
	lw	$t0, firstCard		# $t0 = row index of the firstCard
	lw	$t1, secondCard 	# $t1 = row index of the secondCard
	lw	$t2, firstCard+4 	# $t2 = the column index for the firstCard
	lw	$t3, secondCard+4 	# $t3 = the column index for the secondCard
	
	
	# $t3 and $t4 for the values of the cards
	# finding the row for card one, and then its values
	beq	$t0, 0, Row0
	beq	$t0, 1, Row1
	beq	$t0, 2, Row2
	beq    	$t0, 3, Row3
	
	Row0: 
		la	$t5, cardsRow0		# $t5, the memory address of the current card row 
						# $t2, column integer input converted to an offset
		sll	$t2, $t2, 2	
		add	$t5, $t5, $t2
		lw	$t6, ($t5)		# $t6, the firstCard value is stored in $t6
		
		j	Card2
	Row1: 
		la	$t5, cardsRow1
		
		sll	$t2, $t2, 2
		add	$t5, $t5, $t2
		lw	$t6, ($t5)
		
		j	Card2
	Row2: 
		la	$t5, cardsRow2
		
		sll	$t2, $t2, 2
		add	$t5, $t5, $t2
		lw	$t6, ($t5)
		
		j	Card2
	Row3:
		la	$t5, cardsRow3
		
		sll	$t2, $t2, 2
		add	$t5, $t5, $t2
		lw	$t6, ($t5)
	
	Card2:
	# finding the row for card one, and then its values
		beq	$t1, 0, Row2_0
		beq	$t1, 1, Row2_1
		beq	$t1, 2, Row2_2
		beq    	$t1, 3, Row2_3
	
	Row2_0: 
		la	$t5, cardsRow0
		
		sll	$t3, $t3, 2			# $t2, column integer input converted to an offset
		add	$t5, $t5, $t3
		lw	$t7, ($t5)			# $t7, the secondCard value is stored in $t7 
		
		j	Resume
	Row2_1: 
		la	$t5, cardsRow1
		
		sll	$t3, $t3, 2
		add	$t5, $t5, $t3
		lw	$t7, ($t5)
		
		j	Resume
	Row2_2: 
		la	$t5, cardsRow2
		
		sll	$t3, $t3, 2
		add	$t5, $t5, $t3
		lw	$t7, ($t5)
		
		j	Resume
	Row2_3:
		lw	$t5, cardsRow3
		
		sll	$t3, $t3, 2
		add	$t5, $t5, $t3
		lw	$t7, ($t5)
	
	Resume:
		# jump to If, if $t6 == $t7, firstCard and secondCard are matching
		beq	$t6, $t7, If
		
		j	Else
	
	If: 
		addi	$a0, $a0, 1 # 1 for matching
		# incrementing the count
		addi	$s0, $s0, 1
		
		# TEMPORARY - to check data of the 2d array
		li 	$v0, 4		# load immediate to print the string
		la	$a0, promptMatch	
		syscall
		# TEMPORARY
		
		jal _boardUpdate
	Else:
		addi	$a0, $a0, 0 # 0 for not matching
	
		#beq	$t0, $zero, _boardUpdate
	
		jal	_boardUpdate

_boardUpdate:
	
	beq	$s0, 0, exit # when all the cards have been matched a flipped
	
	beq	$a0, 1, MatchPrint
	#else flip for a bit then return
	
	j	Prompt # MatchPrint
	
	TempPrint: 
		
		j	Prompt
	
	MatchPrint: # permanantly change the board
	
		la	$t0, firstCard  	# $t0 = row index of the firstCard
		la	$t1, secondCard 	# $t1 = row index of the secondCard
		la	$t2, firstCard+4	# $t2 = the column index for the firstCard
		la	$t3, secondCard+4 	# $t3 = the column index for the secondCard
	
		# $t3 and $t4 for the values of the cards
		# finding the row for card one, and then its values
		beq	$t0, 0, BRow0
		beq	$t0, 1, BRow1
		beq	$t0, 2, BRow2
		beq    	$t0, 3, BRow3
	
		BRow0: 
			la	$t5, displayCardsR0
		
			sll	$t2, $t2, 2
			add	$t5, $t5, $t2
			lw	$t3, ($t5)
		
			j	BCard2
		BRow1: 
			la	$t5, displayCardsR1
		
			sll	$t2, $t2, 2
			add	$t5, $t5, $t2
			lw	$t3, ($t5)
		
			j	BCard2
		BRow2: 
			la	$t5, displayCardsR2
		
			sll	$t2, $t2, 2
			add	$t5, $t5, $t2
			lw	$t3, ($t5)
		
			j	BCard2
		BRow3:
			la	$t5, displayCardsR3
		
			sll	$t2, $t2, 2
			add	$t5, $t5, $t2
			lw	$t3, ($t5)
	
		BCard2:
		beq	$t1, 0, BRow0
		beq	$t1, 1, BRow1
		beq	$t1, 2, BRow2
		beq    	$t1, 3, BRow3
	
		BRow2_0: 
			la	$t5, displayCardsR0
		
			sll	$t3, $t3, 2
			add	$t5, $t5, $t3
			lw	$t4, ($t5)
		
			j	Resume2
		BRow2_1: 
			la	$t5, displayCardsR1
		
			sll	$t3, $t3, 2
			add	$t5, $t5, $t3
			lw	$t4, ($t5)
		
			j	Resume2
		BRow2_2: 
			la	$t5, displayCardsR2
		
			sll	$t3, $t3, 2
			add	$t5, $t5, $t3
			lw	$t4, ($t5)
		
			j	Resume2
		BRow2_3:
			la	$t5, displayCardsR3
		
			sll	$t3, $t3, 2
			add	$t5, $t5, $t3
			lw	$t4, ($t5)
	Resume2:

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
		# Prompt for firstCard
		li 	$v0, 4		# load immediate to print the string
		la	$a0, promptC1
		syscall
	
		li 	$v0, 5
		syscall
		move	$t0, $v0
		sw	$t0, firstCard	# Store row integer input for firstCard
	
		li 	$v0, 5
		syscall
		move	$t1, $v0
		sw	$t1, firstCard+4	# Store column integer input for firstCard
	
		# Prompt for secondCard
		li 	$v0, 4		# load immediate to print the string
		la	$a0, promptC2
		syscall
	
		li 	$v0, 5
		syscall
		move	$t2, $v0
		sw	$t2, secondCard	# Store row integer input for secondCard
	
		li 	$v0, 5
		syscall
		move	$t3, $v0
		sw	$t3, secondCard+4	# Store column integer input for secondCard
	
	j	cardCheck
	
exit: 
	li	$v0, 10
	syscall

