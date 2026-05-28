.data
inaddr:   .word 0x80
outaddr:  .word 0x84
stacktop: .word 0x1000
wordbuf:  .word 0x400
databuf:  .word 0x800

    .text
    .org 0x200
_start:
    movea.l  stacktop, A0
    move.l   (A0), D0
    movea.l  D0, A7

    movea.l  inaddr, A0
    move.l   (A0), D0
    movea.l  D0, A0
    movea.l  outaddr, A1
    move.l   (A1), D0
    movea.l  D0, A1

    move.l   (A0), D1
    move.l   D1, D3
    cmp.l    0, D1
    blt      errorexit
    beq      zerocase

    move.l   D1, D0
    add.l    3, D0
    lsr.l    2, D0
    movea.l  wordbuf, A2
    move.l   (A2), D4
    movea.l  D4, A2
readall:
    move.l   (A0), (A2)+
    sub.l    1, D0
    bne      readall

    move.l   D3, D0
    and.l    1, D0
    bne      errorexit

    movea.l  wordbuf, A0
    move.l   (A0), D0
    movea.l  D0, A0
    movea.l  databuf, A2
    move.l   (A2), D0
    movea.l  D0, A2

    move.l   0, D2
    move.l   0, D7
    move.l   0, D0

decodeloop:
    cmp.l    0, D1
    ble      finishdecode
    jsr      readbyte
    move.l   D4, D5
    sub.l    1, D1
    cmp.l    0, D5
    beq      errorexit
    jsr      readbyte
    move.l   D4, D6
    and.l    255, D6
    sub.l    1, D1
unpack:
    move.b   D6, (A2)+
    add.l    1, D2
    sub.l    1, D5
    bne      unpack
    jmp      decodeloop

finishdecode:
    move.l   D2, (A1)
    movea.l  databuf, A2
    move.l   (A2), D0
    movea.l  D0, A2
    move.l   0, D5
    move.l   0, D6
sendloop:
    cmp.l    0, D2
    beq      checklast
    move.l   0, D4
    move.b   (A2)+, D4
    and.l    255, D4
    lsl.l    8, D5
    or.l     D4, D5
    add.l    1, D6
    sub.l    1, D2
    cmp.l    4, D6
    bne      sendloop
    move.l   D5, (A1)
    move.l   0, D5
    move.l   0, D6
    jmp      sendloop

checklast:
    cmp.l    0, D6
    beq      stop
padword:
    cmp.l    4, D6
    beq      lastsend
    lsl.l    8, D5
    add.l    1, D6
    jmp      padword
lastsend:
    move.l   D5, (A1)
stop:
    halt

zerocase:
    move.l   0, (A1)
    halt

errorexit:
    move.l   0, D0
    sub.l    1, D0
    move.l   D0, (A1)
    halt

readbyte:
    cmp.l    0, D7
    bne      extract
    move.l   (A0)+, D0
    move.l   4, D7
extract:
    move.l   D0, D4
    lsr.l    24, D4
    and.l    255, D4
    lsl.l    8, D0
    sub.l    1, D7
    rts