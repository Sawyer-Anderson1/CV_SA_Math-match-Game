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
promptC1:	.asciiz "Card 1, Enter a input from 1 - 16: "
promptC2:	.asciiz "Card 2, Enter a input from 1 - 16: "
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

# 1-D Arrays to test board with 1-D data, 2-D display of the board
cardOrder:	.word 		1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16				# Order of the cards as shown on the board

cardDisArr:	.asciiz 	"1", "1x1", "2", "1x2", "3", "1x3", "4", "2x2", "5", "1x5", "6", "1x6", "7", "1x7", "8", "1x8"	# Values to Display
cardValArr:	.word 		1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6, 7, 7, 8, 8
size:		.word		16	# 16 elements in both Value and Display arrays

RandDisCards: 	.word		
RandCardVals:	.word

newline:	.asciiz "\n"	# newline for formatting
WrInput:	.asciiz "Incorrect input, please try again"		# Display for same card inputted or out of range

#------------------
# Main program body
#------------------

.text
main:	
	# Display to demonstrate 1D data 2D Display Board
	li $v0 4
	la $a0 BoardHeader
	syscall
	la $a0 row1
	syscall
	la $a0 row2
	syscall
	la $a0 row3
	syscall
	la $a0 row4
	syscall
	la $a0 row5
	syscall
	la $a0 row6
	syscall
	la $a0 row7
	syscall
	la $a0 row8
	syscall
	
	# Load the address of the array and the size of the array
   	la      $t0, cardValArr	  # load address of array into $t0
    	lw      $t1, size         # load size of the array into $t1
	addi    $t1, $t1, -1      # set $t1 to size-1 (last index)

shuffle_loop:
    	# Check if we've processed all elements (i >= 0)
    	bltz    $t1, display_loop    # exit if $t1 < 0 (i < 0)

    	# Generate a random index between 0 and $t1 (inclusive)
    	addi    $a1, $t1, 1       # set upper bound (t1 + 1) for syscall 42
    	li      $v0, 42           # system call to generate a random number
    	syscall
    	rem     $t2, $v0, $t1     # $t2 = random index (j) in range [0, i]

    	# Swap array[i] with array[j]
    	mul     $t3, $t1, 4       # $t3 = i * 4 (offset for array[i])
    	mul     $t4, $t2, 4       # $t4 = j * 4 (offset for array[j])
    	
    	add     $t5, $t0, $t3     # $t5 = address of array[i]
    	add     $t6, $t0, $t4     # $t6 = address of array[j]

    	lw      $t7, 0($t5)       # $t7 = array[i]
    	lw      $t8, 0($t6)       # $t8 = array[j]
    	
    	sw      $t8, 0($t5)       # array[i] = array[j]
    	sw      $t7, 0($t6)       # array[j] = array[i]

	# Decrement $t1 (move to the next element)
    	addi    $t1, $t1, -1
	j       shuffle_loop      # repeat the loop

display_loop:
    lw      $t1, size         # reload size of the array into $t1
    li      $t2, 0            # set $t2 = 0 (index)

print_loop:
    bge     $t2, $t1, exit  # exit if index >= size

    # Calculate the address of array[$t2]
    mul     $t3, $t2, 4       # $t3 = $t2 * 4 (index * 4)
    add     $t4, $t0, $t3     # $t4 = address of array[$t2]

    # Load the value of array[$t2] and print it
    lw      $a0, 0($t4)       # load array[$t2] into $a0
    li      $v0, 1            # syscall for print_int
    syscall

    # Print a newline after each element for readability
    la      $a0, newline      # load newline into $a0
    li      $v0, 4            # syscall for print_string
    syscall

    # Increment the index
    addi    $t2, $t2, 1
    j       print_loop        # repeat the loop


exit:
    # Exit the program
    li      $v0, 10           # exit syscall
    syscall