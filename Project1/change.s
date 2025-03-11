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
title:		.asciiz "Change Machine by A. Hakeem\n"
receiptPrompt:	.asciiz "Enter the receipt amount? #"
tenderedPrompt:	.asciiz "Enter the amount tendered? #"
quarterOutput:	.asciiz "Quarters: "
dimeOutput:	.asciiz "Dimes:   "
nickelOutput:	.asciiz "Nickels:  "
pennyOutput:	.asciiz "Pennies:  "
noChangeMsg:	.asciiz "No change"
newline:	.asciiz "\n"

		.text
main:
		li	$v0, 4
		la	$a0, title	# Display title
		syscall
	
		li	$v0, 4		# Prompt for receipt amount
		la	$a0, receiptPrompt
		syscall
	
		li	$v0, 5
		syscall
		move	$t0, $v0	# $t0 = receipt amount in cents
	
		li	$v0, 4		# Prompt for tendered amount
		la	$a0, tenderedPrompt
		syscall
	
		li	$v0, 5
		syscall
		move	$t1, $v0	# $t1 = tendered amount in cents
	
		sub	$t2, $t1, $t0	# $t2 = change amount
	
		li	$v0, 4
		la	$a0, newline	# Print newline
		syscall
	
		
		beqz	$t2, no_change	# If no change, display "No change" message
	
		li	$t3, 25
		div	$t2, $t3
		mflo	$t4		# $t4 = number of quarters
		mfhi	$t2		# $t2 = remaining change
	
		beqz	$t4, skip_quarters
		li	$v0, 4		# Display quarters if greater than 0
		la	$a0, quarterOutput
		syscall
	
		li	$v0, 1
		move	$a0, $t4
		syscall
	
		li	$v0, 4
		la	$a0, newline
		syscall
	
skip_quarters:
		li	$t3, 10
		div	$t2, $t3
		mflo	$t4		# $t4 = number of dimes
		mfhi	$t2		# $t2 = remaining change
		
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
		li	$t3, 5
		div	$t2, $t3
		mflo	$t4		# $t4 = number of nickels
		mfhi	$t2		# $t2 = remaining change (pennies)
		
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
		beqz	$t2, skip_pennies
		li	$v0, 4		# Display pennies if greater than 0
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
		li	$v0, 4		# Display "No change" message
		la	$a0, noChangeMsg
		syscall
	
exit:
		li	$v0, 10		# Exit program
		syscall