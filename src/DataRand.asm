#-----------------------------------------------------------
# Program File: DataRand.asm
# Written by: Sawyer Anderson and Carlos Vazquez
# Date Created: 9/12/2024
# Description: The file that randomizes the indices
#--------------------------------------------------
# Registers:
#	$t0: 16, the arraysize for the arrays
#	$t1: 15, the last index in the arrays
#		decremented to store, then incremented to print
#	$t2: Randomly generated index integer, 0 to 15
#		Later becomes: Offset for the newIndArr
#	$t3: Randomized Offset for arrays
#	$t4: Memory address for current index in cardDisArr
#		Memory position for cardDisArr[$t1]
#	$t5: Memory position for cardValArr[$t1]		
# 	$t6: random index address in newIndArr to store
#		current index from the new index array
#	$t7: The random number to flag check
#	$t8: The memory address of the random number in flag check
#
#	$s2: memory address for newIndArr
# 	$s3: memory address for flagArr
#--------------------------------------------------
# Declare some constants
#-----------------------   
     .data
     
newLine:	.asciiz "\n"
# flagArr: 	.word  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0	# Array to keep track of randomized indices
newIndArr: 	.word  0, 1, 2, 3, 4, 5, 6, 7,  8,  9, 10, 11, 12, 13, 14, 15	# Array to keep the new randomly shuffled indices

#------------------
# Main program body
#------------------
.text
.globl DataRand
DataRand:
    	# Load array size
    	li    $t0, 16              # Load array size into $t0 (array length)
    	#addi  $t1, $t0, -1         # $t1 = 15, the last index in the array. Done to decrement to the first index

    	# Set up base addresses
    	la    $t1, newIndArr       # $s2, Base address of newIndArr
    	#la    $s3, flagArr         # $s3, Base address of flagArr

	# set the seed, to system time
    	li    $v0, 30           # Syscall for time
	syscall
	move  $a0, $a1
	li    $v0, 40           # Syscall for random seed
	syscall


	shuffleLoop:
    		subi $t0, $t0, 1      # Decrement i
    		beqz $t0, Exit # Exit if i == 0

    		# Generate random index j
   		li $v0, 42           # Syscall: Random
    		syscall
    		rem $t2, $a0, $t0    # $t2 = random(0, i)

    		# Swap array[i] and array[j]
   	 	mul $t3, $t0, 4      # Calculate offset for array[i]
    		add $t3, $t1, $t3    # Address of array[i]
    		lw $t4, 0($t3)       # Load array[i]

    		mul $t5, $t2, 4      # Calculate offset for array[j]
    		add $t5, $t1, $t5    # Address of array[j]
    		lw $t6, 0($t5)       # Load array[j]

    		sw $t6, 0($t3)       # array[i] = array[j]
    		sw $t4, 0($t5)       # array[j] = array[i]

    		j shuffleLoop
	
Exit:	
    	move  $v0, $t1              # Move the base address of newIndArr to $v0 for syscall (if needed)
    	jr    $ra                   # Return from function
