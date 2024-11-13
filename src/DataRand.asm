#-----------------------------------------------------------
# Program File: DataRand.asm
# Written by: Sawyer Anderson and Carlos Vazquez
# Date Created: 9/12/2024
# Description: The file that randomizes the indexes
#--------------------------------------------------
# Registers:
#	$t0: 16, the arraysize for the arrays
#	$t1: 15, the last index in the arrays
#	$t2: memory address for cardDisArr
#	$t3: memory address for cardDisArr
#	$t4: Randomly generated index integer, 0 to 15 
#		Later becomes: Offset for the newIndArr
#	$t5: Decrementing Offset for indexArr[$t1], from index 15 to 0
#	$t6: Randomized Offset for indexArr[$t4] 
#	$t7: integer given from indexArr
#	$t8: random index into rightmost index in newIndArr
#
#	$s0: indexArr
#	$s1: newIndArr
#	$s2: current rightmost index address in indexArr
#	$s3: randomized index address in indexArr
#	$s4: randomized index address in newIndArr
# 	$s5: current index from the new index array
# 	$s6: flagArr
#--------------------------------------------------
# Declare some constants
#-----------------------   
     .data
# IDEA OF 2D DISPLAY, 1D DATA
promptC1:	.asciiz "Card 1, Enter an input from 1 - 16: "
promptC2:	.asciiz "Card 2, Enter an input from 1 - 16: "
promptMatch: 	.asciiz "Cards Match!!\n"

BoardHeader: 	.asciiz " ___________________ \n"
row1: 		.asciiz "| 1  |  2 |  3 |  4 |\n"
row2: 		.asciiz "|____|____|____|____|\n"
row3: 		.asciiz "| 5  |  6 |  7 |  8 |\n"
row4: 		.asciiz "|____|____|____|____|\n"
row5: 		.asciiz "| 9  | 10 | 11 | 12 |\n"
row6: 		.asciiz "|____|____|____|____|\n"
row7: 		.asciiz "| 13 | 14 | 15 | 16 |\n"
row8: 		.asciiz "|____|____|____|____|\n"
# IDEA OF 2D DISPLAY, 1D DATA

space:		.asciiz " "
newLine:	.asciiz "\n"

card1:      	.asciiz "4"
card2:      	.asciiz "2x2"
card3:      	.asciiz "6"
card4:      	.asciiz "2x3"
card5:      	.asciiz "8"
card6:      	.asciiz "2x4"
card7:      	.asciiz "9"
card8:      	.asciiz "3x3"
card9:      	.asciiz "10"
card10:     	.asciiz "2x5"
card11:     	.asciiz "12"
card12:     	.asciiz "3x4"
card13:     	.asciiz "15"
card14:    	.asciiz "3x5"
card15:     	.asciiz "16"
card16:     	.asciiz "4x4"

cardDisArr: 	.word card1, card2, card3, card4, card5, card6, card7, card8		# Array of cards that point to their String representation
           	.word card9, card10, card11, card12, card13, card14, card15, card16	
#cardDisArr: 	.asciiz "4\0\0","2x2","6\0\0","2x3","8\0\0","2x4","9\0\0","3x3","10\0","2x5","12\0","3x4","15\0","3x5","16\0","4x4"
cardValArr: 	.word 4, 4, 6, 6, 8, 8, 9, 9, 10, 10, 12, 12, 15, 15, 16, 16  		# Array of card values
#indexArr:	.word 0, 1, 2, 3, 4, 5, 6, 7,  8,  9, 10, 11, 12, 13, 14, 15		# The Array to be shuffled, 1-16 instead of 0-15 flag checking default indices that use 0

flagArr: 	.word 		# Array to keep track of randomized indices
newIndArr: 	.word 		# Array to keep the new randomly shuffled indices

#------------------
# Main program body
#------------------
.text
.globl DataRand
DataRand:
	# Load array size
 	li   $t0, 16         		# Load array size into $t0 (array length)
    	addi $t1, $t0, -1           	# $t1 = 15, the last index in the array. Done to decrement to the first index

    	# Set up base addresses
    	la $t2, cardDisArr		# $t2, Base address of cardDisArr
    	la $t3, cardValArr		# $t3, Base address of cardValArr
    	#la $s0, indexArr		# $s0, Base address of IndexArr
    	la $s1, newIndArr		# $s1, Base address of newIndArr
    	la $s6, flagArr			# $s6, Base address of flagArr

		
	# Initialize random seed (simple example, usually based on a timer or other source)
   	li $v0, 40                # Set $v0 to 40 for syscall to set seed
    	li $a1, 1                 # Seed value (could be any number)
    	syscall
    	
	shuffle_loop:
    		# Check if the loop counter ($t1) is below 0
    		bltz $t1, print_arrays      # If $t1 < 0, go to print arrays,	$t1 = the current rightmost index
    		
    		# Generate a random index within bounds (0 to $t1)
    		#li $a1, 16		# Set upper bound for random index
    		addi $a1, $zero, 16
		li $v0, 42             	# Syscall for generating random integer
    		syscall
		#move $t4 $a0		# $t4, the random integer 0 - 15
		rem $t4, $a0, 16
		
    		# Print random number			To view generated random numbers 
    		move $a0, $t4
		li $v0, 1
		syscall
    		
    		# Print newline
    		la $a0, newLine
		li $v0, 4
		syscall
		
		mul $t5, $t1, 4		# $t5 = Offset for Current rightmost index indexArr[$t1]
    		mul $t6, $t4, 4		# $t6 = Offset for Random Index in indexArr[$t4]
    		
    		# Calculate Memory positions
		add $s5, $s1, $t6	# Memory position for newIndArr[$t4], random index address in newIndArr to store
		add $s7, $s6, $t6	# Memory position for flagArr[$t4],   random index address in newIndArr to prevent wrong storing 
		
		# Check if Memory position for newIndArr[$t4] is available to store in
		lw $t7, ($s7)
		bnez $t7, redo		# If the memory position is not available, redo the random number generation
		
		sw $t4, ($s7)			# Flag random element if so
		sw $t1, 0($s5)			# Store $t1 into $s5, store current righmost element in newIndArr[$t4], a random index in newIndArr

    		# Decrement loop counter and continue
    		addi $t1, $t1, -1	# Decrement the rightmost index, if a available random position was found 
    		
    		redo:		# Label to skip if random index is the same as previous flagged indices  
    		j shuffle_loop
    	
	print_arrays:
    	# Reset array size and load for print loop
    	
    	# Print newline					New line added to seperate the Random numbers and the Array numbers
    	la $a0, newLine
	li $v0, 4
	syscall
    		
    	li $t1, 0                   # Initialize index counter to 0

	print_loop:
    		# Check if we are done printing
    		beq $t1, 16, Exit          # If index == array size, go to exit
    		
		# Calculate memory positions for printing card description and value
		mul 	$t4, $t1, 4             # Calculate offset for new index array
		lw 	$s5, newIndArr($t4)	# Load current index from the new index array
		#add 	$t6, $s1, $t4
		#lw	$s5, 0($t6)
		mul	$t4, $s5, 4		# Offset to actual current index
		
		add	$s2, $t2, $t4		# Memory position for cardDisArr[$t1]
    		add	$s3, $t3, $t4		# Memory position for cardValArr[$t1]
    		
		# Print card description (string) at cardDisArr[$t1]
		lw $a0, 0($s2)              	# Load the string, pointer implementation
		#la $a0, 0($s2)			# Load the string, Array of asciiz values
		li $v0, 4                   	# Syscall for printing a string
		syscall
		
		# Print whitespace
    		la $a0, space 
		li $v0, 4
		syscall

    		# Print corresponding value in cardValArr[$t1]
    		lw $a0, 0($s3)              # Load integer value at cardValArr[$t1]
    		li $v0, 1                   # Syscall for printing an integer
		syscall

    		# Print newline
    		la $a0, newLine
		li $v0, 4
		syscall
    
    		# Increment index and repeat
    		addi $t1, $t1, 1
    		j print_loop

Exit:
    # Exit program
    li $v0, 10                  # Syscall for exit
    syscall
