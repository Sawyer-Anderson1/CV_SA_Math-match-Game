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
columnHeader: 	.asciiz "_|  0   1   2   3\n\0"
space: 		.asciiz " "
newLine: 	.asciiz "\n"
row0: 		.asciiz "0|\0", " + ", " + ", " + ", " + ", "\n\0\0"
row1:		.asciiz "1|\0", " + ", " + ", " + ", " + ", "\n\0\0"
row2:		.asciiz "2|\0", " + ", " + ", " + ", " + ", "\n\0\0"
row3:		.asciiz "3|\0", " + ", " + ", " + ", " + ", "\n\0\0"

cardDisArr: 	.asciiz "  4", "2x2", "  6", "2x3", "  8", "2x4", "  9", "3x3", " 10", "2x5", " 12", "3x4", " 15", "3x5", " 16", "4x4"
flippedCards:	.word 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 # zero indicates that the card isn't permanently flipped, 1 does
#		      0  4  8  12 16 20 24 28 32 36 40 44 48 52 56 60
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
	# move the first argument to another register
	move 	$t3, $a0
	
	# save the return address
	move	$s2, $ra
	
	li	$v0, 4
	la	$a0, space
    	syscall
	la	$a0, columnHeader
	syscall
	
	la	$s5, flippedCards
	
	la	$t1, row0
	li	$t0, 0
	
	Row0Loop:
		add	$t2, $t1, $t0
		
		beq	$t0, 0, Else0
		beq	$t0, 20, Else0
		
		# to change the index to account for the offest of the row ascii array (the row labels)
		subi	$t6, $t0, 4
		add	$t4, $s5, $t6
		lw	$t5, 0($t4)
		
		# check for temp cards to be flipped
		beq	$t3, 0, If0
		beq	$a2, 0, If0
		# check for permanent 
		beq	$t5, 1, correct0
		j	Else0
		If0:	
			# edit the column number of cards 1 and 2 for the word offset/indexing
			mul 	$s6, $t6, 4
			mul	$s7, $t6, 4
			
			beq 	$s6, $t6, correct0
			bne 	$s7, $t6, Else0
			
			correct0:
			move	$a0, $t6
			jal	flippedCardPrint
			j	End_if0
		Else0: 
			la	$a0, space
    			syscall
			la 	$a0, 0($t2)      # Load address of each cell in row0   
    			syscall              # Print the cell content
    		End_if0:
    			addi 	$t0, $t0, 4
    		
    	blt $t0, 24, Row0Loop # Print all 5 elements in row
	
	la	$s5, flippedCards+16
	
	la	$t1, row1
	li	$t0, 0
	
	Row1Loop:
		add	$t2, $t1, $t0
		
		beq	$t0, 0, Else1
		beq	$t0, 20, Else1
		
		# to change the index to account for the offest of the row ascii array (the row labels)
		subi	$t6, $t0, 4
		add	$t4, $s5, $t6
		lw	$t5, 0($t4)
		
		# check for temp cards to be flipped
		beq	$t3, 1, If1
		beq	$a2, 1, If1
		beq	$t5, 1, correct1
		j	Else1
		If1:
			# edit the column number of cards 1 and 2 for the word offset/indexing
			mul 	$s6, $t6, 4
			mul	$s7, $t6, 4
			
			beq 	$s6, $t6, correct1
			bne 	$s7, $t6, Else1
			
			correct1:
			addi	$t6, $t6, 16
			move	$a0, $t6
			jal	flippedCardPrint
			j	End_if1
		Else1: 
			la	$a0, space
    			syscall
			la 	$a0, 0($t2)      # Load address of each cell in row0   
    			syscall              # Print the cell content
    		End_if1:
  			addi 	$t0, $t0, 4
		
	blt	$t0, 24, Row1Loop
	
	la	$s5, flippedCards+32
	
	la	$t1, row2
	li	$t0, 0
	
	Row2Loop:
		add	$t2, $t1, $t0
		
		beq	$t0, 0, Else2
		beq	$t0, 20, Else2
		
		# to change the index to account for the offest of the row ascii array (the row labels)
		subi	$t6, $t0, 4
		add	$t4, $s5, $t6
		lw	$t5, 0($t4)
		
		# check for temp cards to be flipped
		beq	$t3, 2, If2
		beq	$a2, 2, If2
		beq	$t5, 1, correct2
		j	Else2
		If2:
			# edit the column number of cards 1 and 2 for the word offset/indexing
			mul 	$s6, $t6, 4
			mul	$s7, $t6, 4
			
			beq 	$s6, $t6, correct2
			bne 	$s7, $t6, Else2
			
			correct2:
			addi	$t6, $t6, 32
			move	$a0, $t6
			jal	flippedCardPrint
			j	End_if2
		Else2: 
			la	$a0, space
    			syscall
			la 	$a0, 0($t2)      # Load address of each cell in row0   
    			syscall              # Print the cell content
    		End_if2:
  			addi 	$t0, $t0, 4
		
	blt	$t0, 24, Row2Loop
	
	la	$s5, flippedCards+48
	
	la	$t1, row3
	li	$t0, 0
	
	Row3Loop:
		add	$t2, $t1, $t0
		
		beq	$t0, 0, Else3
		beq	$t0, 20, Else3
		
		# to change the index to account for the offest of the row ascii array (the row labels)
		subi	$t6, $t0, 4
		add	$t4, $s5, $t6
		lw	$t5, 0($t4)
		
		# check for temp cards to be flipped
		beq	$t3, 3, If3
		beq	$a2, 3, If3
		beq	$t5, 1, correct3
		j	Else3
		If3:
			# edit the column number of cards 1 and 2 for the word offset/indexing
			mul 	$s6, $t6, 4
			mul	$s7, $t6, 4
			
			beq 	$s6, $t6, correct3
			bne 	$s7, $t6, Else3
			
			correct3:
			addi	$t6, $t6, 48
			move	$a0, $t6
			jal	flippedCardPrint
			j	End_if3
		Else3: 
			la	$a0, space
    			syscall
			la 	$a0, 0($t2)      # Load address of each cell in row0   
    			syscall              # Print the cell content
    		End_if3:     
  			addi 	$t0, $t0, 4
		
	blt	$t0, 24, Row3Loop
	
	# move saved $ra value into $ra again
	move 	$ra, $s2
	
	# to show the incorrect cards for a bit before flipping them back
	la	$a0, 5
	li	$v0, 32
	syscall
	
	li	$v0, 4
	la	$a0, newLine
	syscall
	
	jr	$ra
	
# Registers for just MatchPrint:
#	t0: the flipped cards array address space
#	t1: register to hold an immediate (1) for the flipped cards array

MatchPrint: # permanantly change the board
	# this doesn't actually change the values in rows 0-3 but instead changes the flipped cards array
	# that indicates where the card value is to be shown
	
	# move $a0 to a register, to keep the debugging matchIndicator
	# move	$t3, $a0
	
	# for debugging
	# li	$v0, 4
	# la	$a0, matchIndicator
	# syscall	
	
	# to get the position for card 1 in the flipped card array
	Card1:
	beq	$a0, 0, R0
	beq	$a0, 1, R1
	beq	$a0, 2, R2
	beq    	$a0, 3, R3
	
	R0:	
		la	$t0, flippedCards
		
		mul	$t1, $a1, 4
		add	$t2, $t1, $t0
		
		j	Card2
	R1:
		la	$t0, flippedCards+16
		
		mul	$t1, $a1, 4
		add	$t2, $t1, $t0
		
		j	Card2
	R2:
		la	$t0, flippedCards+32
		
		mul	$t1, $a1, 4
		add	$t2, $t1, $t0
		
		j	Card2
	R3:
		la	$t0, flippedCards+48
		
		mul	$t1, $a1, 4
		add	$t2, $t1, $t0
		
	# to get the position for card 2 in the flipped card array
	Card2:
	# adjust the flipped cards array for card 1
	li	$t1, 1
	sw	$t1, 0($t2)
		
	beq	$a2, 0, r0
	beq	$a2, 1, r1
	beq	$a2, 2, r2
	beq    	$a2, 3, r3
	
	r0:	
		la	$t0, flippedCards
		
		mul	$t1, $a3, 4
		add	$t2, $t1, $t0
		
		j	EndCard2
	r1:
		la	$t0, flippedCards+16
		
		mul	$t1, $a3, 4
		add	$t2, $t1, $t0
		
		j	EndCard2
	r2:
		la	$t0, flippedCards+32
		
		mul	$t1, $a3, 4
		add	$t2, $t1, $t0
		
		j	EndCard2
	r3:
		la	$t0, flippedCards+48
		
		mul	$t1, $a3, 4
		add	$t2, $t1, $t0
	
	EndCard2:	
		# adjust the flag for card 2 in the flipped cards array
		li	$t1, 1
		sw	$t1, 0($t2)
	
	jr	$ra
	
# Registers for boardUpdate:
#	$t1 for the row formats
#	$t0 for the iterator counters
#	$t2 for the address of value(s)
# 	$t3 for the flipped cards flag array
#	$t4 for the flipped card address
#	$t5 for the flipped card value

currBoard:
	li	$v0, 4
	la	$a0, space
    	syscall
	la	$a0, columnHeader
	syscall
	
	# saving $ra into $s2
	move	$s2, $ra
	
	la	$t3, flippedCards
    			
	la	$t1, row0
	li	$t0, 0
	
	row0Loop:
		add	$t2, $t1, $t0
		
		beq	$t0, 0, else0
		beq	$t0, 20, else0
		
		# check the flipped cards value
		subi	$t6, $t0, 4
		add	$t4, $t3, $t6
		lw	$t5, 0($t4)
		
		beq	$t5, 0, else0
		if0:
			move	$a0, $t6
			jal	flippedCardPrint
			j	end_if0
		else0: 
			la	$a0, space
    			syscall
			la 	$a0, 0($t2)      # Load address of each cell in row0   
    			syscall              # Print the cell content
    		end_if0:
    			addi 	$t0, $t0, 4
    		
    	blt $t0, 24, row0Loop # Print all 5 elements in row
	
	la	$t3, flippedCards+16
	
	la	$t1, row1
	li	$t0, 0
	
	row1Loop:
		add	$t2, $t1, $t0
		
		beq	$t0, 0, else1
		beq	$t0, 20, else1
		
		# check the flipped cards value
		subi	$t6, $t0, 4
		add	$t4, $t3, $t6
		lw	$t5, 0($t4)
		
		beq	$t5, 0, else1
		if1:
			addi	$t6, $t6, 16
			move	$a0, $t6
			jal	flippedCardPrint
			j	end_if1
		else1: 
			la	$a0, space
    			syscall
			la 	$a0, 0($t2)      # Load address of each cell in row0   
    			syscall              # Print the cell content
    		end_if1:
  			addi 	$t0, $t0, 4
		
	blt	$t0, 24, row1Loop
	
	la	$t3, flippedCards+32
	
	la	$t1, row2
	li	$t0, 0
	
	row2Loop:
		add	$t2, $t1, $t0
		
		beq	$t0, 0, else2
		beq	$t0, 20, else2
		
		# check the flipped cards value
		subi	$t6, $t0, 4
		add	$t4, $t3, $t6
		lw	$t5, 0($t4)
		
		beq	$t5, 0, else2
		if2:
			addi	$t6, $t6, 32
			move	$a0, $t6
			jal	flippedCardPrint
			j	end_if2
		else2: 
			la	$a0, space
    			syscall
			la 	$a0, 0($t2)      # Load address of each cell in row0   
    			syscall              # Print the cell content
    		end_if2:
  			addi 	$t0, $t0, 4
		
	blt	$t0, 24, row2Loop
	
	la	$t3, flippedCards+48

	la	$t1, row3
	li	$t0, 0
	
	row3Loop:
		add	$t2, $t1, $t0
		
		beq	$t0, 0, else3
		beq	$t0, 20, else3
		
		# check the flipped cards value
		subi	$t6, $t0, 4
		add	$t4, $t3, $t6
		lw	$t5, 0($t4)
		
		beq	$t5, 0, else3
		if3:
			addi	$t6, $t6, 48
			move	$a0, $t6
			jal	flippedCardPrint
			j	end_if3
		else3: 
			la	$a0, space
    			syscall
			la 	$a0, 0($t2)      # Load address of each cell in row0   
    			syscall              # Print the cell content
    		end_if3:     
  			addi 	$t0, $t0, 4
		
	blt	$t0, 24, row3Loop
	
	# move saved $ra value into $ra again
	move 	$ra, $s2
	jr	$ra
	
# Registers:
#	$a0: the adjusted index position
#	$s1: the base address of the card display array (cardDisArr)

flippedCardPrint:
	la	$t7, cardDisArr
	
	add	$s1, $t7, $a0 # get to the actual index position
	
	# display the value at that position
	li	$v0, 4
	la	$a0, 0($s1)
	syscall
	
	la	$a0, space
	syscall
	
	jr	$ra
