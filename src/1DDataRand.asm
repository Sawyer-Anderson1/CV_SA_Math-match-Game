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
# IDEA OF 2D IMPLEMENTATION
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
# IDEA OF 2D IMPLEMENTATION

card1:      .asciiz "4"
card2:      .asciiz "2x2"
card3:      .asciiz "6"
card4:      .asciiz "2x3"
card5:      .asciiz "8"
card6:      .asciiz "2x4"
card7:      .asciiz "9"
card8:      .asciiz "3x3"
card9:      .asciiz "10"
card10:     .asciiz "2x5"
card11:     .asciiz "12"
card12:     .asciiz "3x4"
card13:     .asciiz "15"
card14:     .asciiz "3x5"
card15:     .asciiz "16"
card16:     .asciiz "3x4"

cardDisArr: .word 0, card1, card2, card3, card4, card5, card6, card7, card8
            .word card9, card10, card11, card12, card13, card14, card15, card16
newDisArr:  .word 

cardValArr: .word 0, 4, 4, 6, 6, 8, 8, 9, 9, 10, 10, 12, 12, 15, 15, 16, 16  # Array of integer values
newValArr:  .word

arraySize:  .word 16                         # Number of elements in the array

#------------------
# Main program body
#------------------
.text

main:
    # Load array size
    la   $t0, arraySize         # Load the address of array size
    lw   $t1, 0($t0)            # Load array size into $t1 (array length)
    addi $t4, $t1, -1           # Set $t4 to size-1 (last index for shuffling)

    # Set up base addresses
    la $t2, cardDisArr          # $t2, Base address of cardDisArr
    la $t3, cardValArr          # $t3, Base address of cardValArr
    #la $s2, newDisArr		# $s2, Base address of newDisArr
    #la $s3, newValArr		# $23, Base address of newValArr

shuffle_loop:
    # Check if the loop counter ($t4) is below 1
    bltz $t4, print_arrays      # If $t4 < 0, go to print arrays

    # Generate a random index within bounds (0 to $t4)
    #addi $a0, $zero, 0          # Set lower bound for random index
    addi $a1, $t4, 1            # Set upper bound for random index
    li   $v0, 42                # Syscall for generating random integer
    syscall
    move $t5, $v0               # Store random index in $t5

    # Calculate memory positions for the elements to be swapped
    mul $t6, $t4, 4             # $t6 = Offset for cardDisArr[$t4]
    mul $t7, $t5, 4             # $t7 = Offset for cardDisArr[$t5]
    
    add $s0, $t2, $t6           # Memory position for cardDisArr[$t4]
    add $s1, $t2, $t7           # Memory position for cardDisArr[$t5]
    
    # Swap elements in cardDisArr at positions $t4 and $t5
    lw $t8, 0($s0)              # Load cardDisArr[$t4]
    lw $t9, 0($s1)              # Load cardDisArr[$t5]
    sw $t9, 0($s0)              # Store cardDisArr[$t5] in cardDisArr[$t4]
    sw $t8, 0($s1)              # Store cardDisArr[$t4] in cardDisArr[$t5]
    
    # Calculate memory positions in cardValArr for $t4 and $t5
    add $s0, $t3, $t6           # Memory position for cardValArr[$t4]
    add $s1, $t3, $t7           # Memory position for cardValArr[$t5]

    # Swap integers in cardValArr at positions $t4 and $t5
    lw $t8, 0($s0)              # Load cardValArr[$t4]
    lw $t9, 0($s1)              # Load cardValArr[$t5]	
    sw $t9, 0($s0)              # Store cardValArr[$t5] in cardValArr[$t4]
    sw $t8, 0($s1)              # Store cardValArr[$t4] in cardValArr[$t5]

    # Decrement loop counter and continue
    sub $t4, $t4, 1
    j shuffle_loop

print_arrays:
    # Reset array size and load for print loop
    la $t0, arraySize           # Reload array size address
    lw $t1, 0($t0)              # Reload array size into $t1
    li $t4, 0                   # Initialize index counter to 0

print_loop:
    # Check if we are done printing
    beq $t4, 15, Exit          # If index == array size, go to exit

    # Calculate memory positions for printing card description and value
    mul $t5, $t4, 4             # Calculate offset for cardDisArr[$t4]	
    add $s0, $t2, $t5           # Memory position for cardDisArr[$t4]
    add $s1, $t3, $t5           # Memory position for cardValArr[$t4]
    
    # Print card description (string) at cardDisArr[$t4]
    lw $a0, 0($s0)              # Load the pointer to the string
    li $v0, 4                   # Syscall for printing a string
    syscall

    # Print corresponding value in cardValArr[$t4]
    lw $a0, 0($s1)              # Load integer value at cardValArr[$t4]
    li $v0, 1                   # Syscall for printing an integer
    syscall

    # Print newline
    li $a0, 10                  # ASCII code for newline
    li $v0, 11                  # Syscall for printing a character
    syscall
    
    # Increment index and repeat
    addi $t4, $t4, 1
    j print_loop

Exit:
    # Exit program
    li $v0, 10                  # Syscall for exit
    syscall
