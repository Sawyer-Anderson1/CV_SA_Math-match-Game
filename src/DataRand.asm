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
#indexArr:	.word 0, 1, 2, 3, 4, 5, 6, 7,  8,  9, 10, 11, 12, 13, 14, 15	

newLine:	.asciiz "\n"
flagArr: 	.word  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0	# Array to keep track of randomized indices
newIndArr: 	.word  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0	# Array to keep the new randomly shuffled indices

#------------------
# Main program body
#------------------
.text
.globl DataRand
DataRand:
	# Load array size
 	li   	$t0, 16         		# Load array size into $t0 (array length)
    	addi 	$t1, $t0, -1           	# $t1 = 15, the last index in the array. Done to decrement to the first index


    	# Set up base addresses
    	la 	$s2, newIndArr		# $s2, Base address of newIndArr
    	la 	$s3, flagArr			# $s3, Base address of flagArr

		
	# Initialize random seed (simple example, usually based on a timer or other source)
   	li 	$v0, 40                # Set $v0 to 40 for syscall to set seed
    	li 	$a1, 1                 # Seed value (could be any number)
    	syscall
    	
	shuffle_loop:
    		# Check if the loop counter ($t1) is below 0
    		bltz 	$t1, Exit      # If $t1 < 0, go to print arrays,	$t1 = the current rightmost index
    		
    		# Generate a random index within bounds (0 to $t1)
    		#li $a1, 16		# Set upper bound for random index
    		addi 	$a1, $zero, 16
		li 	$v0, 42             	# Syscall for generating random integer
    		syscall
		#move $t2 $a0		# $t2, the random integer 0 - 15
		rem 	$t2, $a0, 16
		
    		# Print random number			To view generated random numbers 
    		move 	$a0, $t2
		li 	$v0, 1
		syscall
    		
    		# Print newline
    		la 	$a0, newLine
		li 	$v0, 4
		syscall
		
    		mul 	$t3, $t2, 4		# $t3 = Offset for Random Index for arrays
    		
    		# Calculate Memory positions
		add 	$t6, $s2, $t3	# Memory position for newIndArr[$t2], random index address in newIndArr to store
		add 	$t8, $s3, $t3	# Memory position for flagArr[$t2],   random index address in newIndArr to prevent wrong storing 
		
		# Check if Memory position for newIndArr[$t2] is available to store in
		lw 	$t7, 0($t8)		# $t7, the random number to flag check
		bnez 	$t7, redo		# If the memory position is not available (random number != 0), redo the random number generation
		
		sw 	$t2, ($t8)			# Flag random element if so
		sw 	$t1, 0($t6)			# Store $t1 into $t6, store current righmost element in newIndArr[$t2], a random index in newIndArr

    		# Decrement loop counter and continue
    		addi 	$t1, $t1, -1	# Decrement the rightmost index, if a available random position was found 
    		
    		redo:		# Label to skip if random index is the same as previous flagged indices  
    		j 	shuffle_loop
    	
Exit:
	move	$v0, $s2
	
    	jr	$ra
