.data

low_sum:    .word 0
high_sum:   .word 0
const_1:    .word 1
temp:       .word 0

    .text
_start:
main_loop:
    load_addr    0x80
    beqz         finish
    store_addr   temp
    load_addr    low_sum
    add          temp
    store_addr   low_sum
    bcc          check_sign
    load_addr    high_sum
    add          const_1
    store_addr   high_sum

check_sign:
    load_addr    temp
    bgt          main_loop 
    beqz         main_loop  
    load_addr    high_sum
    sub          const_1
    store_addr   high_sum
    jmp          main_loop

finish:
    load_addr    high_sum
    store_addr   0x84
    load_addr    low_sum
    store_addr   0x84
    halt