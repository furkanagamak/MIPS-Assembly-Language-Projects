###### Furkan Agamak ######
###### FAGAMAK ######
###### 114528166 ######

############################ DO NOT CREATE A .data SECTION ############################
############################ DO NOT CREATE A .data SECTION ############################
############################ DO NOT CREATE A .data SECTION ############################
.text:

.globl create_network
create_network:
	addi $sp, $sp, -36
	sw $ra, 0($sp)	
	sw $s0, 4($sp)	
	sw $s1, 8($sp)	
	sw $s2, 12($sp)	
	sw $s3, 16($sp)	
	sw $s4, 20($sp)	
	sw $s5, 24($sp)
	sw $s6, 28($sp)
	sw $s7, 32($sp)
	
	move $s0, $0
	move $s1, $0
	move $s2, $0
	move $s3, $0
	move $s4, $0
	move $s5, $0
	move $t0, $0
	move $t1, $0
	move $t2, $0
	move $t3, $0
	move $t4, $0
	move $t5, $0
	move $t6, $0
	move $t7, $0
	move $t8, $0
	move $t9, $0	
	
	move $s0, $a0 ## set $s0 to the total no. of nodes possible in the network
	move $s1, $a1 ## set $s1 to the total no. of edges possible in the network
	
	bltz $s0, createNetworkError ## throw error if I < 0
	bltz $s1, createNetworkError ## throw error if J < 0
	
	addiu $t4, $0, 4 ## set $t4 to 4 for multiplication
	
	mult $s0, $t4 ## num of nodes * 4
	mflo $t0
	mult $s1, $t4 ## num of edges * 4
	mflo $t1
	add $t2, $t0, $t1 ## (num of nodes * 4) + (num of edges * 4)
	addi $t2, $t2, 16 ## (num of nodes * 4) + (num of edges * 4) + 16
	
	addu $a0, $t2, $0 ## move $a0 to number of bytes to be allocated in the heap
	li $v0, 9
	syscall
	
	move $s3, $v0 ## set $s3 to heap address from the syscall
	
	li $t5, 0 ## counter
	initializeNetworkLoop:
		beq $t5, $t2, initializeDone ## end loop if we filled the heap with zeroes
		sw $0, 0($s3) ## set each element in the heap to zero
		addi $s3, $s3, 4 ## increment heap address
		addi $t5, $t5, 4 ## increment counter
		j initializeNetworkLoop
	
	initializeDone:
		sw $s0, 0($v0) ## store total no. of nodes possible in the network
		sw $s1, 4($v0) ## store total no. of edges possible in the network
		j createNetworkEnd

	createNetworkError:
		addiu $v0, $0, -1
		j createNetworkEnd
	
	createNetworkEnd: 
		lw $ra, 0($sp)
		lw $s0, 4($sp)
		lw $s1, 8($sp)
		lw $s2, 12($sp)
		lw $s3, 16($sp)
		lw $s4, 20($sp)
		lw $s5, 24($sp)
		lw $s6, 28($sp)
		lw $s7, 32($sp)
		addi $sp, $sp, 36
 		jr $ra

.globl add_person
add_person:
	addi $sp, $sp, -36
	sw $ra, 0($sp)	
	sw $s0, 4($sp)	
	sw $s1, 8($sp)	
	sw $s2, 12($sp)	
	sw $s3, 16($sp)	
	sw $s4, 20($sp)	
	sw $s5, 24($sp)
	sw $s6, 28($sp)
	sw $s7, 32($sp)
	
	move $s0, $0
	move $s1, $0
	move $s2, $0
	move $s3, $0
	move $s4, $0
	move $s5, $0
	move $t0, $0
	move $t1, $0
	move $t2, $0
	move $t3, $0
	move $t4, $0
	move $t5, $0
	move $t6, $0
	move $t7, $0
	move $t8, $0
	move $t9, $0	
	
	addu $s0, $a0, $0 ## set $s0 to the address of the Network
	addu $s1, $a1, $0 ## set $s1 to the null terminated string
	
	jal get_person
	addiu $t0, $0, 1
	beq $v1, $t0, addPersonError
	
	lw $t0, 0($s0) ## set $t0 to the max number of nodes
	lw $t1, 8($s0) ## set $t1 to the current number of nodes
	
	beq $t0, $t1, addPersonError
	
	move $t2, $0 ## initialize counter which will count num of chars in the string
	addu $t4, $s1, $0 ## store string address
	
	stringLoop:
		lb $t3, 0($t4) ## load char
		beq $t3, $0 stringLoopDone ## if null terminator then done
		addiu $t2, $t2, 1 ## increment num of chars
		addiu $t4, $t4, 1 ## increment string address
		j stringLoop
	
	stringLoopDone:
	beq $t2, $0, addPersonError ## if num of chars is 0, throw error
	
	addiu $a0, $0, 4 ## allocate 4 bytes in the heap to store num of chars
	addiu $v0, $0, 9
	syscall
	
	move $t5, $v0 ## store the initial heap address of the person in $t5
	sw $t2, 0($t5)
	
	addi $a0, $t2, 1 ## allocate num of chars + 1 bytes in the heap
	li $v0, 9
	syscall
	
	addu $t6, $v0, $0 ## store the heap address after allocating bytes for the string in $t6
	addu $t4, $s1, $0 ## store string address
	
	stringLoop2:
		lb $t3, 0($t4) ## load char
		sb $t3, 0($t6) ## store char in the heap
		beq $t3, $0, stringLoopDone2 ## if null terminator then done
		addiu $t4, $t4, 1 ## increment string address
		addiu $t6, $t6, 1 ## increment heap address
		j stringLoop2
	
	stringLoopDone2:
	move $t9, $s0 ## store the network address in $t9
	
	lw $t7, 8($t9) ## load the num of nodes
	addiu $t7, $t7, 1 ## increment num of nodes
	sw $t7, 8($t9) ## store incremented num of nodes in the network
	
	addiu $s4, $0, 4 ## store 4 in $s4 for multiplication
	mult $t7, $s4 ## num of nodes * 4
	mflo $t8
	addiu $t8, $t8, 12 # + 12
	
	addu $t9, $t9, $t8 ## increment network address
	sw $t5, 0($t9) ## store the address of the node in the network
	
	move $v0, $s0 ## return network address in $v0
	li $v1, 1 ## return 1 in $v1
	j addPersonEnd
	
	addPersonError:
		li $v0, -1
		j addPersonEnd

	addPersonEnd:
		lw $ra, 0($sp)
		lw $s0, 4($sp)
		lw $s1, 8($sp)
		lw $s2, 12($sp)
		lw $s3, 16($sp)
		lw $s4, 20($sp)
		lw $s5, 24($sp)
		lw $s6, 28($sp)
		lw $s7, 32($sp)
		addi $sp, $sp, 36
 		jr $ra

.globl get_person
get_person:
	addi $sp, $sp, -36
	sw $ra, 0($sp)	
	sw $s0, 4($sp)	
	sw $s1, 8($sp)	
	sw $s2, 12($sp)	
	sw $s3, 16($sp)	
	sw $s4, 20($sp)	
	sw $s5, 24($sp)
	sw $s6, 28($sp)
	sw $s7, 32($sp)
	
	move $s0, $0
	move $s1, $0
	move $s2, $0
	move $s3, $0
	move $s4, $0
	move $s5, $0
	move $t0, $0
	move $t1, $0
	move $t2, $0
	move $t3, $0
	move $t4, $0
	move $t5, $0
	move $t6, $0
	move $t7, $0
	move $t8, $0
	move $t9, $0	
	
	addu $s0, $a0, $0 ## set $s0 to the address of the Network
	addu $s1, $a1, $0 ## set $s1 to the null terminated string
	
	lw $t4, 8($s0) ## set $t1 to the current number of nodes
	addiu $t0, $s0, 16 ## increment network address to get the array of nodes
	
	move $t3, $0 ## counter for outer loop
	addu $t5, $s1, $0 ## set $t5 to the null terminated string
	
	getPersonOuterLoop:
		move $t1, $0
		lw $t1, 0($t0) ## set $t1 to the address of the current node + 4
		addi $t1, $t1, 4
		lw $t2, 0($t0) ## set $t2 to the address of the current node
		beq $t3, $t4, getPersonOuterLoopDone ## done if we iterated through the whole array
		addi $t3, $t3, 1 ## increment counter
		
		getPersonInnerLoop:
			move $t6, $0 
			lb $t6, 0($t1) ## get the char from the current string
			move $t7, $0
			lb $t7, 0($t5) ## get the char from the input string
			bne $t6, $t7, getPersonInnerLoopDone
			
			beq $t6, $0, foundPerson
			addiu $t1, $t1, 1
			addiu $t5, $t5, 1
			j getPersonInnerLoop
			
		getPersonInnerLoopDone:
			addu $t5, $s1, $0 ## set $t5 to the null terminated string
			addiu $t0, $t0, 4
			j getPersonOuterLoop
			
	getPersonOuterLoopDone:	
		li $v0, -1
		li $v1, -1
		j getPersonEnd
	
	foundPerson:
		move $v0, $t2
		li $v1, 1
		j getPersonEnd
	
	getPersonEnd:		
		lw $ra, 0($sp)
		lw $s0, 4($sp)
		lw $s1, 8($sp)
		lw $s2, 12($sp)
		lw $s3, 16($sp)
		lw $s4, 20($sp)
		lw $s5, 24($sp)
		lw $s6, 28($sp)
		lw $s7, 32($sp)
		addi $sp, $sp, 36
 		jr $ra

.globl add_relation
add_relation:
	addi $sp, $sp, -36
	sw $ra, 0($sp)	
	sw $s0, 4($sp)	
	sw $s1, 8($sp)	
	sw $s2, 12($sp)	
	sw $s3, 16($sp)	
	sw $s4, 20($sp)	
	sw $s5, 24($sp)
	sw $s6, 28($sp)
	sw $s7, 32($sp)
	
	move $s0, $0
	move $s1, $0
	move $s2, $0
	move $s3, $0
	move $s4, $0
	move $s5, $0
	move $t0, $0
	move $t1, $0
	move $t2, $0
	move $t3, $0
	move $t4, $0
	move $t5, $0
	move $t6, $0
	move $t7, $0
	move $t8, $0
	move $t9, $0	
	
	move $s0, $a0 ## store the network address in $s0
	move $s1, $a1 ## store name1 in $s1
	move $s2, $a2 ## store name2 in $s2
	move $s3, $a3 ## store relation type in $s3
	
	addu $a0, $s0, $0 ## store the network address for the method call
	addu $a1, $s1, $0 ## store name1 for the method call
	jal get_person
	bltz $v1, addRelationError ## jump to error if name1 doesn't exist
	move $s4, $v0 ## store the address of person1 with name1 in $s4
	
	addu $a0, $s0, $0 ## store the network address for the method call
	addu $a1, $s2, $0 ## store name2 for the method call
	jal get_person
	bltz $v1, addRelationError ## jump to error if name2 doesn't exist
	move $s5, $v0 ## store the address of person1 with name2 in $s5
	
	beq $s4, $s5, addRelationError ## throw error if person1 == person2
	
	move $t0, $0
	move $t1, $0
	
	lw $t0, 4($s0) ## set $t0 to the max number of edges
	lw $t1, 12($s0) ## set $t1 to the current number of edges
	
	beq $t0, $t1, addRelationError ## throw error if the network is at capacity
	
	li $t3, 3 ## store 3 in $t3
	bltz $s3, addRelationError ## throw error if relation type < 0
	bgt $s3, $t3, addRelationError ## throw error if relation type > 3
	
	
	move $t9, $s0 ## store network address in $t9
	li $t4, 4 ## store 4 in $t4 for multiplication
	
	lw $t6, 0($s0) ## set $t1 to the max number of nodes
	mult $t6, $t4 ## max num of nodes * 4
	mflo $t8
	addiu $t8, $t8, 16 ## + 16
	addu $t9, $t9, $t8 ## increment network address
	
	move $t2, $0 ## counter
	
	checkSameRelationLoop:
		beq $t2, $t1, checkSameRelationLoopDone ## done if the counter is equal to the current number of edges
		
		move $t5, $0
		lw $t5, 0($t9) ## load the address of the current edge
		move $t6, $0
		lw $t6, 0($t5) ## load the address of the current person1
		move $t7, $0
		lw $t7, 4($t5) ## load the address of the current person2
		
		beq $t6, $s4, checkPerson2 ## check if current person1 is equal to input person1
		beq $t6, $s5, checkPerson1 ## check if current person1 is equal to input person2
		addiu $t9, $t9, 4 ## increment network address
		addiu $t2, $t2, 1 ## increment counter
		j checkSameRelationLoop
		
		checkPerson2:
			beq $t7, $s5, addRelationError ## throw error if current person2 is equal to input person2
			addiu $t9, $t9, 4 ## increment network address
			addiu $t2, $t2, 1 ## increment counter
			j checkSameRelationLoop
			
		checkPerson1:
			beq $t7, $s4, addRelationError ## throw error if current person2 is equal to input person1
			addiu $t9, $t9, 4 ## increment network address
			addiu $t2, $t2, 1 ## increment counter
			j checkSameRelationLoop
	
	checkSameRelationLoopDone:
	li $a0, 12 ## allocate 12 bytes in the heap
	li $v0, 9
	syscall
	
	move $t2, $v0 ## store the address of the heap in $t2
	
	addi $t1, $t1, 1 ## increment the current number of edges
	sw $t1, 12($s0) ## store incremented num of nodes in the network
	
	sw $s4, 0($t2) ## store person1 address in the heap
	sw $s5, 4($t2) ## store person2 address in the heap
	sw $s3, 8($t2) ## store relation type in the heap
	
	addu $t9, $s0, $0 ## store network address in $t9
	addiu $t4, $0, 4 ## store 4 in $t4 for multiplication
	
	lw $t6, 0($s0) ## set $t1 to the max number of nodes
	mul $t8, $t6, $t4 ## max num of nodes * 4
	addi $t8, $t8, 12 ## + 12
	
	mult $t1, $t4 ## current num of edges * 4
	mflo $t7
	addu $t8, $t8, $t7 ## (max num of nodes * 4) + 12 + (current num of edges * 4)
	
	addu $t9, $t9, $t8 ## increment network address
	sw $t2, 0($t9) ## store the address of the node in the network
	
	move $v0, $s0 ## return network address in $v0
	li $v1, 1 ## return 1 in $v1
	j addRelationEnd
	
	addRelationError:
		li $v0, -1
		li $v1, -1
		j addRelationEnd
	
	addRelationEnd:
		lw $ra, 0($sp)
		lw $s0, 4($sp)
		lw $s1, 8($sp)
		lw $s2, 12($sp)
		lw $s3, 16($sp)
		lw $s4, 20($sp)
		lw $s5, 24($sp)
		lw $s6, 28($sp)
		lw $s7, 32($sp)
		addi $sp, $sp, 36
 		jr $ra

.globl get_distant_friends
get_distant_friends:
	addi $sp, $sp, -36
	sw $ra, 0($sp)	
	sw $s0, 4($sp)	
	sw $s1, 8($sp)	
	sw $s2, 12($sp)	
	sw $s3, 16($sp)	
	sw $s4, 20($sp)	
	sw $s5, 24($sp)
	sw $s6, 28($sp)
	sw $s7, 32($sp)
	
	addu $s0, $a0, $0 ## store the network address in $s0
	addu $s1, $a1, $0 ## store the person name in $s1
	
	jal get_person
	bltz $v1, PersonNameDoesNotExist ## jump to error if the person does not exist
	
	move $s2, $v0 ## store the address of the person in $s2
	
	li $t4, 4 ## set $t4 to 4 for multiplication
	lw $t1, 12($s0) ## set $t1 to the current number of edges
	beq $t1, $0, noEdges
	mult $t4, $t1 ## (current num of edges) * 4
	mflo $t0
	
	addu $t7, $sp, $0 ## store the initial stack pointer in $t7
	addu $t5, $sp, $0 ## store the initial stack pointer in $t5
	
	addu $t9, $s0, $0 ## store network address in $t9
	lw $t6, 0($s0) ## set $t1 to the max number of nodes
	mult $t6, $t4 ## max num of nodes * 4
	mflo $t8
	addu $a2, $a1, $0
	addiu $t8, $t8, 16 ## + 16
	addu $t9, $t9, $t8 ## increment network address
	
	move $t2, $0 ## counter
	storeEdgesOnStackLoop:
		addiu $a2, $a2, 1
		beq $t2, $t1, storeEdgesOnStackLoopDone ## done if iterated through the edges array
		move $t3, $0
		lw $t3, 0($t9) ## load the current edge address
		addi $sp, $sp, -4
		sw $t3, 0($sp) ## store the current edge address
		addiu $t9, $t9, 4
		move $a1, $0
		addiu $t2, $t2, 1
		move $a0, $0
		j storeEdgesOnStackLoop
		
	storeEdgesOnStackLoopDone:
		addiu $s7, $t7, -4 ## set $s7 to the first edge address
		
		addu $s3, $s0, $t8
		lw $s1, 12($s0)
		addiu $s4, $0, 2
		
		
	  lw $s1, 8($s0)
	  addiu $t1, $0, -4
		mult $t1, $s1
		mflo $t1
		addu $a3, $sp, $t1
		
		move $s6, $0
		move $t9, $t7
		
	initialDepthFirstSearchLoop:
			move $a2, $0
			move $a1, $0
			move $a0, $0
			lw $t7, 12($s0)
			addiu $s4, $0, 4
			mult $s4, $t7
			mflo $s4
			addu $t4, $a3, $0
			subu $t4, $t4, $s4
			move $t2, $0
			addu $s1, $s0, $t8
			
			storeInitialEdgesArrayLoop:
				addu $a1, $a0, $0
				beq $t2, $t7, storeInitialEdgesArrayLoopDone
				addiu $a2, $a2, 1
				lw $s5, 0($s1)
				addiu $a0, $a0, 1
				sw $s5, 0($t4)
				move $a0, $a1
				addiu $t2, $t2, 1
				move $a1, $0
				addiu $t4, $t4, 4
				move $a2, $a0
				addiu $s1, $s1, 4
				addu $a2, $a1, $a0
				j storeInitialEdgesArrayLoop
				
			storeInitialEdgesArrayLoopDone:
			addu $s4, $s2, $0
			addiu $t5, $0, 2
			move $t4, $0
			move $t3, $0
			move $t2, $0
			move $a0, $a1
			
			firstInnerDepthFirstSearchLoop:
				addu $s1, $s3, $0
				lw $t7, 12($s0)
				addiu $a0, $a0, 1

				secondInnerDepthFirstSearchLoop:
					addiu $t0, $0, 1
					lw $s5, 0($s1)
					addiu $a0, $a0, 1
					beq $s5, $0 secondInnerDepthFirstSearchLoopDone
					addiu $a1, $a1, 1
					beq $s5, $t4, secondInnerDepthFirstSearchLoopDone
					addiu $a2, $a2, 1
					lw $t6, 8($s5)
					addu $a2, $a0, $a1
					bne $t6, $t0, secondInnerDepthFirstSearchLoopDone
					
					move $a2, $a0
					lw $t1, 0($s5)
					addiu $a0, $a0, 1
					bne $t1, $s4, checkSecondNode
					addu $a1, $a0, $0
					addiu $a2, $a2, 1
					lw $t1, 4($s5)
					
					move $a1, $0
					beq $t2, $0, secondInnerDepthFirstSearchContinue
					addiu $a2, $a2, 1
					beq $t1, $s2, secondInnerDepthFirstSearchLoopDone
					addiu $a0, $a0, 1
					
					secondInnerDepthFirstSearchContinue:
					addu $s4, $t1, $0
					addu $t4, $s5, $0
					sw $0, 0($s1)
					addu $t3, $s1, $0
					addiu $t2, $t2, 1
					addu $a2, $a0, $a1
					j distantFriendLocated
					
					checkSecondNode:
						addu $a0, $a1, $0
						lw $t1, 4($s5)
						move $a2, $a1
						bne $t1, $s4, secondInnerDepthFirstSearchLoopDone
						addu $a2, $a0, $a1
						lw $t1, 0($s5)
						
						move $a1, $0
						beq $t2, $0 checkSecondNodeContinue
						addiu $a2, $a2, 1
						beq $t1, $s2, secondInnerDepthFirstSearchLoopDone
						addiu $a0, $a0, 1
						
						checkSecondNodeContinue:
						addu $s4, $t1, $0
						addu $t4, $s5, $0
						sw $0, 0($s1)
						addu $t3, $s1, $0
						addiu $t2, $t2, 1
						addu $a2, $a0, $a1
						j distantFriendLocated
						
					secondInnerDepthFirstSearchLoopDone:
						move $a0, $0
						move $a1, $0
						move $a2, $0
						addiu $t7, $t7, -1
						bne $s4, $s2, distantFriendNotLocated
						addiu $a0, $a0, 1
						beq $t7, $0, initialDepthFirstSearchLoopDone
						
						distantFriendNotLocated:
							addiu $a0, $a0, 1
							addiu $a1, $a1, 1
							beq $t7, $0, firstInnerDepthFirstSearchLoopDone
							addu $a2, $a1, $a0
							addiu $s1, $s1, 4
							move $a0, $0
							j secondInnerDepthFirstSearchLoop
					
					distantFriendLocated:
						move $a0, $0
						move $a1, $0
						move $a2, $0
						j firstInnerDepthFirstSearchLoop
						
				firstInnerDepthFirstSearchLoopDone:
					addu $s1, $s0, $t8
					lw $t7, 12($s0)
					addiu $t5, $0, 4
					mult $t5, $t7
					mflo $t5
					move $a2, $a0
					sub $t5, $a3, $t5
					addiu $a2, $a2, 1
					move $t1, $0
					
					restoreInitialEdgesArrayLoop:
						addu $a1, $a0, $0
						beq $t1, $t7, restoreInitialEdgesArrayLoopDone
						addiu $a2, $a2, 1
						lw $s5, 0($t5)
						addiu $a0, $a0, 1
						sw $s5, 0($s1)
						move $a0, $a1
						addiu $t1, $t1, 1
						move $a1, $0
						addiu $t5, $t5, 4
						move $a2, $a0
						addiu $s1, $s1, 4
						addu $a2, $a1, $a0
						j restoreInitialEdgesArrayLoop
						
					restoreInitialEdgesArrayLoopDone:
					move $a0, $0
					move $a1, $0
					move $a2, $0
					addiu $t5, $0, 2
					sw $0, 0($t3)
					addiu $a1, $a1, 1
					blt $t2, $t5, initialDepthFirstSearchLoop
					
					addu $t5, $sp, $0
					move $t1, $0
					addu $a2, $a0, $0
					
					distantDuplicateChecker:
						addu $a1, $a0, $0
						beq $t1, $s6, distantDuplicateCheckerDone
						addiu $a2, $a2, 1
						lw $s1, 0($t5)
						addiu $a0, $a0, 1
						beq $s1, $s4, duplicateDistantFriend
						move $a2, $a0
						addiu $t5, $t5, 4
						addu $a1, $a2, $0
						addiu $t1, $t1, 1
						move $a0, $0
						j distantDuplicateChecker
						
				  distantDuplicateCheckerDone:																							
						addiu $sp, $sp, -4
						move $a0, $0
						move $a2, $0		
						sw $s4, 0($sp)
						addu $a2, $a1, $0
						addiu $s6, $s6, 1
					
					duplicateDistantFriend:
						move $a0, $0
						move $a1, $0
						move $a2, $0
						j initialDepthFirstSearchLoop
					
				initialDepthFirstSearchLoopDone:

				  move $s5, $t9 ## store original sp in $s5
				  
					add $t9, $s0, $t8 ## find the initial address of edge arr
					lw $t1, 12($s0) ## set $t1 to the current number of edges
					move $t2, $0 ## counter
					restoreEdgesArrayLoop:
						addu $a2, $a0, $0
						beq $t2, $t1, restoreEdgesArrayLoopDone
						addiu $a1, $a1, 1
						lw $t3, 0($s7)
						addiu $a0, $a0, 1
						sw $t3, 0($t9)
						addu $a2, $a1, $a0
						addi $s7, $s7, -4
						addu $a1, $a0, $0
						addi $t9, $t9, 4
						move $a0, $a2
						addi $t2, $t2, 1
						move $a2, $a1
						j restoreEdgesArrayLoop
						
					restoreEdgesArrayLoopDone:
						beq $s6, $0, noDistantFriends
						
						addu $s3, $sp, $0 ## store stack pointer in $s3
						addu $s4, $s6, $0 ## store num of distant in $s4
						addu $s7, $s6, $0 ## store num of distant in $s7
						
						outerCheckDistant:
							beq $s7, $0, outerCheckDistantDone
						
							add $t9, $s0, $t8 ## find the initial address of edge arr
							move $t2, $0 ## counter
							lw $t1, 12($s0) ## set $t1 to the current number of edges
							addi $s7, $s7, -1
					
						checkSameRelationLoopDistant:
							move $a0, $0
							beq $t2, $t1, checkSameRelationLoopDoneDistant ## done if the counter is equal to the current number of edges
							move $a1, $0
							lw $t0, 0($s3)
							addiu $a1, $a1, 1
							lw $t5, 0($t9) ## load the address of the current edge
							addiu $a0, $a0, 1
							lw $t6, 0($t5) ## load the address of the current person1
							addiu $a2, $a2, 1
							lw $t7, 4($t5) ## load the address of the current person2
							addu $a2, $a1, $a0
						
							li $t3, 1
							lw $s6, 8($t5) ## load relation type
							addiu $a2, $a2, 1
							beq $s6, $t3, continueCheckingValid ## if relation type is 1 then continue checking
							move $a0, $a1
							addu $a2, $a0, $0
					 		addiu $t9, $t9, 4 ## increment network address
					 		addu $a2, $a2, $a0
							addiu $t2, $t2, 1 ## increment counter
							j checkSameRelationLoopDistant
						
							continueCheckingValid:
		
								beq $t6, $s2, checkPerson2Distant ## check if current person1 is equal to input person1
								beq $t6, $t0, checkPerson1Distant ## check if current person1 is equal to input person2
								addiu $t9, $t9, 4 ## increment network address
								addiu $t2, $t2, 1 ## increment counter
								j checkSameRelationLoopDistant
		
							checkPerson2Distant:
								beq $t7, $t0, invalidDistant ## throw error if current person2 is equal to input person2
								addiu $t9, $t9, 4 ## increment network address
								addiu $t2, $t2, 1 ## increment counter
								j checkSameRelationLoopDistant
			
							checkPerson1Distant:
								beq $t7, $s2, invalidDistant ## throw error if current person2 is equal to input person1
								addiu $t9, $t9, 4 ## increment network address
								addiu $t2, $t2, 1 ## increment counter
								j checkSameRelationLoopDistant
							
							invalidDistant:
								addiu $s4, $s4, -1
								sw $0, 0($s3)
								addiu $s3, $s3, 4
								j outerCheckDistant
						checkSameRelationLoopDoneDistant:
							move $a0, $0
							move $a1, $0
							move $a2, $0
							addi $s3, $s3, 4 ## increment stack
							j outerCheckDistant

					outerCheckDistantDone:
						beq $s4, $0, noDistantFriends
						move $a0, $0
						
						getNextDistantLoop:
							move $t0, $0
							addi $a1, $a1, 1
							lw $t0, 0($sp) ## load distant friend person from the stack
							bne $t0, $0, continueStoringDistant ## continue if not 0
							addi $sp, $sp, 4 ## keep incrementing to find
							j getNextDistantLoop
						
						continueStoringDistant:
							move $a0, $0
							move $a1, $0
							move $a2, $0
							addiu $a1, $a1, 1
							lw $t1, 0($t0) ## get the num of chars from the person
							addu $a2, $a1, $a2
							addiu $t1, $t1, 1 ## get the total amount of chars including null terminator
							addiu $t5, $0, 4 ## load 4 for division
							move $a0, $a2
							addu $a1, $a1, $a2
							div $t1, $t5 ## k mod 4
							move $a2, $a1
							mfhi $t7 ## get the remainder
		
							beqz $t7, skipFurtherCalculations
							subu $t9, $t5, $t7
							addu $t9, $t9, $t1
							addiu $t9, $t9, 4
							j continueFirstDistant
							
							skipFurtherCalculations:
								addiu $t9, $t1, 4
							continueFirstDistant:
								addu $a0, $t9, $0 ## allocate bytes in the heap
								addiu $v0, $0, 9
								syscall
								
								addu $t7, $v0, $0
								addu $t6, $v0, $0 ## store the heap address after allocating bytes for the string in $t6
								addiu $t4, $t0, 4
								addu $a0, $a1, $a2
								stringLoopFirstDistant:
									move $a0, $0
									addu $a2, $a2, $a1
									lb $t3, 0($t4) ## load char
									addiu $a1, $a1, 1
									sb $t3, 0($t6) ## store char in the heap
									move $a0, $a1
									beq $t3, $0, stringLoopFirstDistantDone ## if null terminator then done
									addu $a0, $a1, $0
									addiu $t4, $t4, 1 ## increment string address
									move $a2, $a0
									addiu $t6, $t6, 1 ## increment heap address
									move $a1, $a0
									j stringLoopFirstDistant
	
							stringLoopFirstDistantDone:
							li $t1, 1
							beq $t1, $s4, oneDistantFriend
							
							move $s3, $t7
							add $t5, $t7, $t9
							addi $t5, $t5, -4
							move $s7, $t5
							move $t2, $0 ## counter
							
							addi $s6, $s4, -1
			
							storeDistantFriendsListLoop:
									beq $t2, $s6, storeDistantFriendsListLoopDone ## done if counter == num of distant friends
									addi $sp, $sp, 4 ## increment stack
									lw $t0, 0($sp) ## load distant friend person from the stack
									beq $t0, $0, storeDistantFriendsListLoop ## go back to start if the address is zero
									
									move $a0, $0
									move $a1, $0
									move $a2, $0
									
									lw $t1, 0($t0) ## get the num of chars from the person
									addu $a2, $a2, $a1
									addiu $t1, $t1, 1 ## get the total amount of chars including null terminator
									addiu $t5, $0, 4 ## load 4 for division
									div $t1, $t5 ## k mod 4
									addiu $a1, $a1, 1
									mfhi $t7 ## get the remainder
		
									beq $t7, $0, skipFurtherCalculationsDistantLoop
									subu $t9, $t5, $t7 ## 4 - (k mod 4)
									addu $t9, $t9, $t1 ## 4 - (k mod 4) + k
									addiu $t9, $t9, 4 ## 4 - (k mod 4) + 4
									move $a2, $0
									j continueDistantListLoop
									move $a1, $0
							
								skipFurtherCalculationsDistantLoop:
									move $a0, $0
									addiu $t9, $t1, 4
								continueDistantListLoop:
									move $a0, $t9 ## allocate bytes in the heap
									li $v0, 9
									syscall
									
									addu $t7, $v0, $0 ## store this at the end
									addu $t6, $v0, $0 ## store the heap address after allocating bytes for the string in $t6
									addiu $t4, $t0, 4
									move $a0, $0
									move $a1, $0
									move $a2, $0
									
									stringLoopDistantList:
										addiu $a1, $a1, 1
										lb $t3, 0($t4) ## load char
										addiu $a0, $a0, 1
										sb $t3, 0($t6) ## store char in the heap
										addiu $a2, $a2, 1
										beq $t3, $0, stringLoopDistantListDone ## if null terminator then done
										addu $a0, $a2, $0
										addiu $t4, $t4, 1 ## increment string address
										move $a2, $a1
										addiu $t6, $t6, 1 ## increment heap address
										move $a1, $a0
										j stringLoopDistantList
	
							stringLoopDistantListDone:
								sw $v0, 0($s7)
								add $s7, $t7, $t9
								addi $s7, $s7, -4
								addi $t2, $t2, 1
								j storeDistantFriendsListLoop
								
							storeDistantFriendsListLoopDone:
								sw $0, 0($s7) ## store zero at the end of the linked list
								move $v0, $s3
								move $sp, $s5
								j getDistantFriendsEnd
												
	oneDistantFriend:
		add $t5, $t7, $t9
		addi $t5, $t5, -4
		sw $0, 0($t5) ## store zero at the end of friendndoe
		move $v0, $t7 ## store starting address of friendnode in $v0
		move $sp, $s5 ## restore the stack
		j getDistantFriendsEnd				
		
	noDistantFriends:
		li $v0, -1	 ## return -1 in $v0 if no distant friends
		move $sp, $s5
		j getDistantFriendsEnd
	
	PersonNameDoesNotExist:
		li $v0, -2 ## return -2 in $v0 if name doesn't exist
		j getDistantFriendsEnd
		
	noEdges:
		li $v0, -1
		j getDistantFriendsEnd
		
	getDistantFriendsEnd:
		lw $ra, 0($sp)
		lw $s0, 4($sp)
		lw $s1, 8($sp)
		lw $s2, 12($sp)
		lw $s3, 16($sp)
		lw $s4, 20($sp)
		lw $s5, 24($sp)
		lw $s6, 28($sp)
		lw $s7, 32($sp)
		addi $sp, $sp, 36
 		jr $ra
