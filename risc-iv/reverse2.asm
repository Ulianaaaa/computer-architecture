.data
    .org 0x00
buffer:  .byte 95,95,95,95,95,95,95,95,95,95,95,95,95,95,95,95,95,95,95,95,95,95,95,95,95,95,95,95,95,95,95,95
    .org 0x40
input_ptr:  .word 0x80
output_ptr: .word 0x84
error_val:  .word 0xCCCCCCCC

    .text
    .org 0x100
_start:
    lui      t0, %hi(input_ptr)
    addi     t0, t0, %lo(input_ptr)
    lw       s1, 0(t0)
    lw       s5, 4(t0)
    lw       s6, 8(t0)
    addi     s2, zero, 512
    mv       s4, s2
    addi     t1, zero, 10
    addi     t3, zero, 0
    addi     s7, zero, 0

read_loop:
    addi     t4, zero, 32
    beq      t3, t4, overflow_case
    lw       t0, 0(s1)
    beq      t0, t1, start_processing
    sb       t0, 0(s2)
    bnez     t0, not_null
    bnez     s7, not_null
    mv       s7, s2
not_null:
    addi     s2, s2, 1
    addi     t3, t3, 1
    j        read_loop

start_processing:
    addi     s3, zero, 0
    mv       s8, s2
    bnez     s7, reverse_prep
    mv       s7, s8
reverse_prep:
    mv       s9, s7
reverse_loop:
    beq      s9, s4, after_reverse
    addi     s9, s9, -1
    lw       t0, 0(s9)
    addi     t2, zero, 255
    and      t0, t0, t2
    sb       t0, 0(s3)
    sw       t0, 0(s5)
    addi     s3, s3, 1
    j        reverse_loop

after_reverse:
    addi     t0, zero, 0
    sb       t0, 0(s3)
    addi     s3, s3, 1
    beq      s7, s8, stop_prog
    addi     s9, s7, 1
copy_rest:
    beq      s9, s8, end_copy
    lw       t0, 0(s9)
    addi     t2, zero, 255
    and      t0, t0, t2
    sb       t0, 0(s3)
    addi     s3, s3, 1
    addi     s9, s9, 1
    j        copy_rest
end_copy:
    addi     t0, zero, 0
    sb       t0, 0(s3)
stop_prog:
    halt

overflow_case:
    sw       s6, 0(s5)
    halt