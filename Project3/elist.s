# Name: Hakeem, Ayomide
# Project: 3
# Due: April 29, 2025
# Course: cs-2640-03-sp25
#
# Description:
# This program implements a linked list to store and print element names from enames.dat
#


        .data
head:           .word 0         # Head ptr
input:          .space 80       # Input buffer
ptfname:        .asciiz "/Users/ayomidehakeem/Desktop/CS2640/Project3/enames.dat"
count:          .word 0         # Element count
title:          .asciiz "Elements by A. Hakeem v0.1\n\n\n"
countMsg:       .asciiz "# elements\n\n\n"
separator:      .asciiz ":"
newline:        .asciiz "\n"
malloc_err:     .asciiz "Error: Failed to allocate memory.\n"
file_err:       .asciiz "Error: Failed to open file.\n"

        .text
        .globl main

main:
        la $a0, title           # Print title
        li $v0, 4
        syscall

        la $a0, ptfname         # Open file
        li $a1, 0
        jal open
        move $s0, $v0

        bltz $s0, file_error    # Check file open

read_loop:
        move $a0, $s0           # Read line
        la $a1, input
        jal fgetln

        blez $v0, end_read      # Check EOF

        la $a0, input           # Dup string
        jal strdup
        beqz $v0, malloc_error

        move $s1, $v0           # Save str addr

        move $a0, $s1           # Create node
        lw $a1, head
        jal getnode
        beqz $v0, malloc_error

        sw $v0, head            # Update head

        lw $t0, count           # Inc count
        addi $t0, $t0, 1
        sw $t0, count

        j read_loop

end_read:
        move $a0, $s0           # Close file
        jal close

        la $a0, countMsg        # Print count msg
        li $v0, 4
        syscall

        lw $a0, head            # Print list
        la $a1, print
        jal traverse

exit:
        li $v0, 10              # Exit
        syscall

file_error:
        la $a0, file_err        # Print err
        li $v0, 4
        syscall
        j exit_error

malloc_error:
        la $a0, malloc_err      # Print err
        li $v0, 4
        syscall
        j exit_error

exit_error:
        li $v0, 17              # Exit err
        li $a0, 1
        syscall

getnode:
        addi $sp, $sp, -4       # Save ra
        sw $ra, 0($sp)

        move $t0, $a0           # Save params
        move $t1, $a1

        li $a0, 8               # Alloc node
        jal malloc
        beqz $v0, getnode_fail

        sw $t0, 0($v0)          # Init node
        sw $t1, 4($v0)
        j getnode_ret

getnode_fail:
        move $v0, $zero

getnode_ret:
        lw $ra, 0($sp)          # Restore ra
        addi $sp, $sp, 4
        jr $ra

# traverse: recursively calls proc on nodes from end to head (original read order)
traverse:
        beqz $a0, traverse_done # Check null

        addi $sp, $sp, -12      # Save regs
        sw $ra, 8($sp)
        sw $a0, 4($sp)      # Save current node addr
        sw $a1, 0($sp)      # Save proc addr

        # --- Recurse first ---
        lw $a0, 4($a0)          # $a0 = list->next
        # $a1 (proc addr) is already set for recursive call
        jal traverse

        # --- Process node AFTER recursion returns ---
        lw $a1, 0($sp)          # Restore proc addr
        lw $t0, 4($sp)          # Restore current node addr into $t0
        lw $a0, 0($t0)          # $a0 = current_node->data (arg for proc)
        jalr $a1                    # Call proc($a0)

        # Restore registers for return
        lw $a1, 0($sp)          # Not strictly needed, but restores state
        lw $a0, 4($sp)      # Not strictly needed, but restores state
        lw $ra, 8($sp)
        addi $sp, $sp, 12

traverse_done:
        jr $ra

print:
        addi $sp, $sp, -8       # Save regs
        sw $ra, 4($sp)
        sw $s0, 0($sp)

        move $s0, $a0           # Save str

        jal strlen              # Get len

        move $a0, $v0           # Print len
        li $v0, 1
        syscall

        la $a0, separator       # Print sep
        li $v0, 4
        syscall

        move $a0, $s0           # Print str
        li $v0, 4
        syscall


        lw $s0, 0($sp)          # Restore regs
        lw $ra, 4($sp)
        addi $sp, $sp, 8
        jr $ra

strlen:
        li $v0, 0               # Init len
        move $t1, $a0

strlen_loop:
        lb $t0, 0($t1)          # Get byte
        beqz $t0, strlen_done
        addi $v0, $v0, 1
        addi $t1, $t1, 1
        j strlen_loop

strlen_done:
        jr $ra

strdup:
        addi $sp, $sp, -12      # Save regs
        sw $ra, 8($sp)
        sw $s0, 4($sp)
        sw $s1, 0($sp)

        move $s0, $a0           # Save src

        jal strlen              # Get len

        move $t0, $v0           # Alloc mem
        addi $a0, $t0, 1
        jal malloc
        beqz $v0, strdup_fail

        move $s1, $v0           # Save dst

        move $t2, $s0           # Copy str ptrs
        move $t3, $s1

strdup_loop:
        lb $t1, 0($t2)          # Copy byte
        sb $t1, 0($t3)
        addi $t2, $t2, 1
        addi $t3, $t3, 1
        bnez $t1, strdup_loop   # Loop until null copied

        move $v0, $s1           # Ret dst
        j strdup_ret

strdup_fail:
        move $v0, $zero

strdup_ret:
        lw $s1, 0($sp)          # Restore regs
        lw $s0, 4($sp)
        lw $ra, 8($sp)
        addi $sp, $sp, 12
        jr $ra

malloc:
        li $v0, 9
        syscall
        jr $ra