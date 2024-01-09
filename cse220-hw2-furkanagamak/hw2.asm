########### Furkan Agamak ############
########### FAGAMAK ################
########### 114528166 ################

###################################
##### DO NOT ADD A DATA SECTION ###
###################################

.text
.globl hash
hash:
	move $t0, $a0  
	li $t1, 0 
	li $t2, 0 
	
	hashingLoop:
		lb $t2, 0($t0)
		beqz $t2, hashingDone
		add $t1, $t1, $t2
		addi $t0, $t0, 1
		j hashingLoop
		
	hashingDone:
		move $v0, $t1
  jr $ra

.globl isPrime
isPrime:
	li $t9, 0
	li $t8, 1
	li $t1, 2
	bge $a0, $t1, primeContinue
	li $v0, 0
	jr $ra
	
primeContinue:
	slt $t2, $t1, $a0
	bne $t2, $t9, primeLoop
	li $v0, 1
	jr $ra

primeLoop:	
	div $a0, $t1	
	mfhi $t0
	slt $t5, $t0, $t8
	beqz $t5, primeLoopDone
	li $v0, 0
	jr $ra

primeLoopDone:		
	addi $t1, $t1, 1	
	j primeContinue
	jr $ra
	
.globl lcm
lcm:
	addi $sp, $sp, -4 
	sw $ra, 0($sp)
	
	move	 $t7, $a0
	move $t8, $a1
	move $a0, $t7
	move $a1, $t8
	jal gcd 
	
	move $t1, $v0
	mult $t7, $t8
	mflo $t5
	div $t5, $t1
	mflo $v0
	
	lw $ra, 0($sp)
	addi $sp, $sp, 4	
	
	jr $ra	

.globl gcd
gcd:
	move $t1, $a0
	move $t2, $a1
	beqz $t2, gcdDone
	
	move $t3, $t2
	div $t1, $t2
	mfhi $a1
	addi $a0, $t3, 0		
	j gcd
	
	gcdDone:		
	addi $v0, $t1, 0
  jr $ra

.globl pubkExp
pubkExp:
	addi $sp, $sp, -4 
	sw $ra, 0($sp)
	
	move $t4, $a0
	li $t9, 1
	pubkLoop:
		move $a1, $t4
		li $v0, 42
		syscall
		addi $a0, $a0, 2
		bge $a0, $t4, pubkLoop
		move $t5, $a0
		
		jal gcd
		
		move $t0, $v0
		beq $t0, $t9, pubkDone
		j pubkLoop
		
	pubkDone:
	move $v0, $t5
	
	lw $ra, 0($sp)
	addi $sp, $sp, 4	
		
  jr $ra

.globl prikExp
prikExp:
	addi $sp, $sp, -4 
	sw $ra, 0($sp)
	
	li $t6, 1
	move $t7, $a0 ## original x
	move $t8, $a1 ## original y
	jal gcd
	
	move $t9, $v0 
	bne $t9, $t6, invalidArgs
	
	move $a1, $t8 ## setting $a1 to original y
	
	## steps 1 and 2
	move $t6, $t7 ## new x
	move $t5, $a1 ## new y
	div $t5, $t6 ## divide y by x
	mflo $t4 ## divided
	mfhi $t3 ## modulo
	move $t5, $t6 ## y = x
	move $t6, $t3 ## x = modulo
	move $t2, $t4 ## Q2 = divided from step 1
	
	div $t5, $t6 ## divide y by x
	mflo $t4 ## divided
	mfhi $t3 ## modulo
	move $t5, $t6 ## y = x
	move $t6, $t3 ## x = modulo
	move $t1, $t4 ## Q1 = divided from step 2
	li $t0, 0 ## Pi2 = 0
	li $t9, 1 ## Pi1 = 1
	
	beqz $t3, privateKeyLoopDone ## initially checking if modulo = 0 
	
	privateKeyLoop:
		div $t5, $t6 ## divide y by x
		mflo $t4 ## divided
		mfhi $t3 ## modulo
		move $t5, $t6 ## y = x
		move $t6, $t3 ## x = modulo
		mult $t9, $t2 ## Pi1 * Q2
		mflo $t7 ## store result of Pi1 * Q2
		sub $t7, $t0, $t7 ## (Pi2 - (Pi1 *Q2))
		div $t7, $a1 ## (Pi2 - (Pi1 *Q2)) % original y
		mfhi $t8 ## store result of modulo for currentP
		
	  bltz $t7, negativeDivisionLoop
			
		j privateLoopContinue
			
		negativeDivisionLoop:
			add $t8, $t8, $a1 
			div $t8, $a1
			mfhi $t8
		
		privateLoopContinue:
			move $t0, $t9 ## Pi2 = Pi1
			move $t9, $t8 ## Pi1 = currentP
			move $t2, $t1 ## Q2 = Q1
			move $t1, $t4 ## Q1 = divided
			beqz $t3, privateKeyLoopDone
			j privateKeyLoop
		
		privateKeyLoopDone:
			## the last step of the algorithm
			div $t5, $t6 ## divide y by x
			mflo $t4 ## divided
			mfhi $t3 ## modulo
			move $t5, $t6 ## y = x
			move $t6, $t3 ## x = modulo
			mult $t9, $t2 ## Pi1 * Q2
			mflo $t7 ## store result of Pi1 * Q2
			sub $t7, $t0, $t7 ## (Pi2 - (Pi1 *Q2))
			div $t7, $a1 ## (Pi2 - (Pi1 *Q2)) % original y
			mfhi $t8 ## store result of modulo for currentP
			bltz $t7, negativeDivision
			
			j finalResult
			
			negativeDivision:
				add $t8, $t8, $a1 
				div $t8, $a1
				mfhi $t8
			
			finalResult:
			move $v0, $t8 ## currentP is the final result
			lw $ra, 0($sp)
			addi $sp, $sp, 4	
			jr $ra
			
	invalidArgs:
		li $v0, -1
		lw $ra, 0($sp)
		addi $sp, $sp, 4	
	
  jr $ra

.globl encrypt
encrypt:
	addi $sp, $sp, -4 
	sw $ra, 0($sp)
	
	mult $a1, $a2
	mflo $t9 ## storing n = p * q
	move $t4, $a0 ## storing hashed message m
	
	addi $a0, $a1, -1 ## p = p - 1
	addi $a1, $a2, -1 ## q = q - 1
	jal lcm ## finding lcm(p-1, q-1)
	
	move $t7, $t9 ## storing n = p * q in $t7
	move $t8, $t4 ## storing hashed message m in $t8
	
	move $a0, $v0 ## k = lcm(p-1, q-1)
	jal pubkExp
	
	move $t1, $v0 ## storing public key e
	addi $t2, $t1, -1 ## exponent counter
	div $t8, $t7 
	mfhi $t3 ## initializing u' = u mod w
	
	exponentLoop:
		mult $t8, $t3 ## multiply m by the result we found in the previous step
		mflo $t4 ## store the result of multiplication
		div $t4, $t7 ## divide m*previous step by n
		mfhi $t3 ## store the resulting remainder in $t3
		addi $t2, $t2, -1 ## decrement the exponent counter
		beqz $t2, exponentLoopDone
		j exponentLoop
		
	exponentLoopDone:
		move $v0, $t3 ## storing the final result c
		move $v1, $t1 ## storing public key e
 	
		lw $ra, 0($sp)
		addi $sp, $sp, 4	
		jr $ra

.globl decrypt
decrypt:
	addi $sp, $sp, -4 
	sw $s2, 0($sp)
	addi $sp, $sp, -4 
	sw $s1, 0($sp)
	addi $sp, $sp, -4 
	sw $s0, 0($sp)
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	move $s0, $a0 ## storing c in $s0
	move $s1, $a1 ## storing the public key in $s1
	
	mult $a2, $a3
	mflo $s2 ## storing n = p * q in $s2
	
	addi $a0, $a2, -1 ## p = p - 1
	addi $a1, $a3, -1 ## q = q - 1
	jal lcm ## finding lcm(p-1, q-1)
	
	move $a0, $s1 ## storing the public key in $a0
	move $a1, $v0 ## storing lcm(p-1, q-1) in $a1
	
	jal prikExp ## getting private key d
	
	move $t0, $v0 ## storing d in $t0
	addi $t2, $t0, -1 ## exponent counter
	div $s0, $s2
	mfhi $t3
	
	exponentLoop2:
		mult $s0, $t3 ## multiply c by the result we found in the previous step
		mflo $t4 ## store the result of multiplication
		div $t4, $s2 ## divide c*previous step by n
		mfhi $t3 ## store the resulting remainder in $t3
		addi $t2, $t2, -1 ## decrement the exponent counter
		beqz $t2, exponentLoopDone2
		j exponentLoop2
		
	exponentLoopDone2:
		move $v0, $t3
		
		lw $s2, 12($sp)
		lw $s1, 8($sp)
		lw $s0, 4($sp)
		lw $ra, 0($sp)
		addi $sp, $sp, 16
		jr $ra