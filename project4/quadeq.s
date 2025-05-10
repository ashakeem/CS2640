# Name:         Hakeem, Ayomide
# Project:      4
# Due:          May 9, 2025
# Course:       cs-2640-03-sp25
#
# Description:
#               Solves quadratic equations of the form ax^2 + bx + c = 0.
#

.data
header_msg:     .asciiz "Quadratic Equation Solver v0.25 by A. Hakeem\n\n"
prompt_a:       .asciiz "Enter value for a? "
prompt_b:       .asciiz "Enter value for b? "
prompt_c:       .asciiz "Enter value for c? "
blank_line:     .asciiz "\n\n"

not_quadratic_msg:      .asciiz "Not a quadratic equation.\n\n"
linear_msg_prefix:      .asciiz "x = "
imaginary_msg:  .asciiz "Roots are imaginary.\n\n"
x1_msg: .asciiz "x1 = "
x2_msg: .asciiz "x2 = "
newline:        .asciiz "\n\n"

fp_zero:        .float  0.0
fp_two: .float  2.0
fp_four:        .float  4.0

.text
.globl main
main:
        li      $v0, 4
        la      $a0, header_msg
        syscall

        li      $v0, 4
        la      $a0, prompt_a
        syscall
        li      $v0, 6
        syscall
        mov.s   $f12, $f0

        li      $v0, 4
        la      $a0, prompt_b
        syscall
        li      $v0, 6
        syscall
        mov.s   $f14, $f0

        li      $v0, 4
        la      $a0, prompt_c
        syscall
        li      $v0, 6
        syscall
        mov.s   $f16, $f0

        jal     solve

        move    $s0, $v0
        mov.s   $f20, $f0
        mov.s   $f22, $f1

        li      $v0, 4
        la      $a0, blank_line
        syscall

        li      $t0, -1
        beq     $s0, $t0, case_imaginary

        li      $t0, 0
        beq     $s0, $t0, case_not_quadratic

        li      $t0, 1
        beq     $s0, $t0, case_linear

        li      $t0, 2
        beq     $s0, $t0, case_two_roots

        j       exit_program

case_imaginary:
        li      $v0, 4
        la      $a0, imaginary_msg
        syscall
        j       exit_program

case_not_quadratic:
        li      $v0, 4
        la      $a0, not_quadratic_msg
        syscall
        j       exit_program

case_linear:
        li      $v0, 4
        la      $a0, linear_msg_prefix
        syscall
        mov.s   $f12, $f20
        li      $v0, 2
        syscall
        li      $v0, 4
        la      $a0, newline
        syscall
        j       exit_program

case_two_roots:
        li      $v0, 4
        la      $a0, x1_msg
        syscall
        mov.s   $f12, $f20
        li      $v0, 2
        syscall
        li      $v0, 4
        la      $a0, newline
        syscall

        li      $v0, 4
        la      $a0, x2_msg
        syscall
        mov.s   $f12, $f22
        li      $v0, 2
        syscall
        li      $v0, 4
        la      $a0, newline
        syscall
        j       exit_program

exit_program:
        li      $v0, 10
        syscall

# solve(float a, float b, float c)
# Args: $f12=a, $f14=b, $f16=c
# Returns: $v0=code, $f0=x1, $f1=x2
# Codes: -1=imaginary, 0=not_quadratic, 1=linear, 2=two_roots

solve:
        addi    $sp, $sp, -4
        sw      $ra, 0($sp)

        l.s     $f2, fp_zero

        c.eq.s  $f12, $f2
        bc1t    a_is_zero

a_is_not_zero:
        mul.s   $f4, $f14, $f14
        l.s     $f6, fp_four
        mul.s   $f8, $f6, $f12
        mul.s   $f8, $f8, $f16
        sub.s   $f10, $f4, $f8

        c.lt.s  $f10, $f2
        bc1t    d_is_negative

        sqrt.s  $f18, $f10

        neg.s   $f4, $f14

        l.s     $f6, fp_two
        mul.s   $f8, $f6, $f12

        add.s   $f6, $f4, $f18
        div.s   $f0, $f6, $f8

        sub.s   $f6, $f4, $f18
        div.s   $f1, $f6, $f8

        li      $v0, 2
        j       solve_epilogue

d_is_negative:
        li      $v0, -1
        j       solve_epilogue

a_is_zero:
        c.eq.s  $f14, $f2
        bc1t    b_is_zero_too

        neg.s   $f4, $f16
        div.s   $f0, $f4, $f14
        li      $v0, 1
        j       solve_epilogue

b_is_zero_too:
        li      $v0, 0
        j       solve_epilogue

solve_epilogue:
        lw      $ra, 0($sp)
        addi    $sp, $sp, 4
        jr      $ra