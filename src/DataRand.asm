#-----------------------------------------------------------
# Program File: DataRand.asm
# Written by: Sawyer Anderson and Carlos Vazquez
# Date Created: 9/12/2024
# Description: The file that randomizes the indexes
#-----------------------------------------------------------

#-----------------------
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

#cardDisArr: 	.word card1, card2, card3, card4, card5, card6, card7, card8		# Array of cards that point to their String representation
#            	.word card9, card10, card11, card12, card13, card14, card15, card16	
cardDisArr: 	.asciiz "4\0\0","2x2","6\0\0","2x3","8\0\0","2x4","9\0\0","3x3","10\0","2x5","12\0","3x4","15\0","3x5","16\0","4x4"

cardValArr: 	.word 4, 4, 6, 6, 8, 8, 9, 9, 10, 10, 12, 12, 15, 15, 16, 16  		# Array of card values
indexArr:	.word 0, 1, 2, 3, 4, 5, 6, 7,  8,  9, 10, 11, 12, 13, 14, 15		# The Array to be shuffled
newIndArr: 	.word 
Offset:		.word

arraySize:  	.word 16                        # Number of elements in the array

#------------------
# Main program body
#------------------
.text

main:
	# Load array size
 	lw   $t1, arraySize         # Load array size into $t1 (array length)
    	addi $t0, $t1, -1           # $t0 = 15, the last index in the array. Done to decrement to the first index

    	# Set up base addresses
    	la $t2, cardDisArr          # $t2, Base address of cardDisArr
    	la $t3, cardValArr          # $t3, Base address of cardValArr
    	la $s0, indexArr
    	la $s1, newIndArr

		
	# Initialize random seed (simple example, usually based on a timer or other source)
   	li $v0, 40                # Set $v0 to 40 for syscall to set seed
    	#li $a0, 1                 # Seed value (could be any number)
    	syscall
    	
	shuffle_loop:
    		# Check if the loop counter ($t0) is below 1
    		bltz $t0, print_arrays      # If $t0 < 0, go to print arrays
    		
    		# Generate a random index within bounds (0 to $t0)
    		li $a1, 16            	# Set upper bound for random index
		li $v0, 42             	# Syscall for generating random integer
    		syscall
		move $s6 $a0
		#rem $s6, $v0, $t1

    		# Print random number
    		move $a0, $s6
		li $v0, 1
		syscall
    		
    		# Print newline
    		la $a0, newLine
		li $v0, 4
		syscall
		
		mul $t5, $t0, 4		# $t5 = Offset for indexArr[$t0], last index to first
    		mul $t6, $s6, 4		# $t6 = Random Offset for indexArr[$s6]
    
    		add $s2, $s0, $t5	# Memory position for indexArr[$t0] = base address + offset
		add $s3, $s0, $t6	# Memory position for indexArr[$s6]
		add $s4, $s1, $t5	# Memory position for newIndArr[$t0]
		add $s5, $s1, $t6	# Memory position for newIndArr[$s6]
		
    
   		# Swap elements in cardDisArr at positions $t0 and $t4
    		lw $t7, 0($s2)              # Load indexArr[$t0]
    		lw $t8, 0($s3)              # Load indexArr[$s6]
		sw $t7, 0($s4)              # Store indexArr[$s6] in newIndArr[$t0]
		sw $t8, 0($s5)              # Store indexArr[$t0] in newIndArr[$s6]

    		# Decrement loop counter and continue
    		addi $t0, $t0, -1
    		j shuffle_loop
    		
	print_arrays:
    	# Reset array size and load for print loop
    	
    	# Print newline					New line added to seperate the Random numbers and the Array numbers
    	la $a0, newLine
	li $v0, 4
	syscall
    		
    	li $t0, 0                   # Initialize index counter to 0

	print_loop:
    		# Check if we are done printing
    		beq $t0, 16, Exit          # If index == array size, go to exit
    		
		# Calculate memory positions for printing card description and value
		mul 	$t4, $t0, 4             # Calculate offset for new index array
		#lw 	$t6, newIndArr($t4)	# Load current index from the new index array
		add 	$t6, $s1, $t4
		lw	$s5, 0($t6)
		mul	$t4, $s5, 4		# Offset to actual current index
		
		add	$s2, $t2, $t4		# Memory position for indexArr[$t0]
    		add	$s3, $t3, $t4
    		
		# Print card description (string) at cardDisArr[$t0]
		la $a0, 0($s2)              # Load the string
		li $v0, 4                   # Syscall for printing a string
		syscall
		
		# Print whitespace
    		la $a0, space 
		li $v0, 4
		syscall

    		# Print corresponding value in cardValArr[$t0]
    		lw $a0, 0($s3)              # Load integer value at cardValArr[$t0]
    		li $v0, 1                   # Syscall for printing an integer
		syscall

    		# Print newline
    		la $a0, newLine
		li $v0, 4
		syscall
    
    		# Increment index and repeat
    		addi $t0, $t0, 1
    		j print_loop

Exit:
    # Exit program
    li $v0, 10                  # Syscall for exit
    syscall
