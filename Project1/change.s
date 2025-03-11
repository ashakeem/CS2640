#
#     Name:    Hakeem, Ayomide
#     Project: 1
#     Due:     March 11, 2025
#     Course:  cs-2640-03-sp25
#
#     Description:
#              A program to calculate change for any amount between 0 and 99 cents.
#

		.data
title:          .asciiz "Change-Machine-by-A. Hakeem\n"
receiptPrompt:  .asciiz "Enter the receipt amount? #"
tenderedPrompt: .asciiz "Enter the amount tendered? #\n"
quarterOutput:  .asciiz "Quarters: "
dimeOutput:     .asciiz "Dimes:   "
nickelOutput:   .asciiz "Nickels:  "
pennyOutput:    .asciiz "Pennies:  "
noChangeMsg:    .asciiz "No change"
newline:        .asciiz "\n"

        	.text
main:
        	# Display title
	    	li	$v0, 4
	    	la	$a0, title
	    	syscall
	
	    	# Prompt for receipt amount
	    	li	$v0, 4
	    	la	$a0, receiptPrompt
	    	syscall
	
	    	# Read receipt amount
	    	li	$v0, 5
	    	syscall
	    	move	$t0, $v0   # $t0 = receipt amount in cents
	
	    	# Prompt for tendered amount
	    	li	$v0, 4
	    	la	$a0, tenderedPrompt
	    	syscall
	
		# Read tendered amount
		li	$v0, 5
		syscall
		move	$t1, $v0   # $t1 = tendered amount in cents
	
		# Calculate change amount
		sub	$t2, $t1, $t0   # $t2 = change amount
	
		# Print newline
		li	$v0, 4
		la	$a0, newline
		syscall
	
		# Check if there is any change to give
		beqz	$t2, no_change
	
		# Calculate number of quarters (25 cents)
		li	$t3, 25
		div	$t2, $t3
		mflo	$t4        # $t4 = number of quarters
		mfhi	$t2        # $t2 = remaining change
	
		# Display quarters if greater than 0
		beqz	$t4, skip_quarters
		li	$v0, 4
		la	$a0, quarterOutput
		syscall
	
		li	$v0, 1
		move	$a0, $t4
		syscall
	
		li	$v0, 4
		la	$a0, newline
		syscall
	
skip_quarters:
		# Calculate number of dimes (10 cents)
		li	$t3, 10
		div	$t2, $t3
		mflo	$t4        # $t4 = number of dimes
		mfhi	$t2        # $t2 = remaining change
		
		# Display dimes if greater than 0
		beqz	$t4, skip_dimes
		li	$v0, 4
		la	$a0, dimeOutput
		syscall
		
		li	$v0, 1
		move	$a0, $t4
		syscall
		
		li	$v0, 4
		la	$a0, newline
		syscall
	
skip_dimes:
		# Calculate number of nickels (5 cents)
		li	$t3, 5
		div	$t2, $t3
		mflo	$t4        # $t4 = number of nickels
		mfhi	$t2        # $t2 = remaining change (pennies)
		
		# Display nickels if greater than 0
		beqz	$t4, skip_nickels
		li	$v0, 4
		la	$a0, nickelOutput
		syscall
		
		li	$v0, 1
		move	$a0, $t4
		syscall
		
		li	$v0, 4
		la	$a0, newline
		syscall
	
skip_nickels:
		# Remaining cents are pennies
		# Display pennies if greater than 0
		beqz	$t2, skip_pennies
		li	$v0, 4
		la	$a0, pennyOutput
		syscall
		
		li	$v0, 1
		move	$a0, $t2
		syscall
		
		li	$v0, 4
		la	$a0, newline
		syscall
		
skip_pennies:
		j	exit
	
no_change:
		# Display "No change" message
		li	$v0, 4
		la	$a0, noChangeMsg
		syscall
	
exit:
		# Exit program
		li	$v0, 10
		syscall 