%define a nand
%define c16 copy
%define x xor
%define nop copy 0,0,0

%macro not 1
    a %1,%1
%endm
%macro set0 1
    x %1,%1
%endm
%macro set1 1
    set0 %1
    not %1
%endm

%macro cpy 2
    xor %2,%2
    xor %1,%2
%endm

    ;; jumps to "main"
    ;; requires .org 4 at begining
    ;; main <-(args)
%macro init 1
    .org 2
    .db by2(labels[%1])
    .org 0
    c 1, 0, 1
%endm

    ;; wait for reg to become 1
    ;; reg, trash
%macro wait_for 2
    .org alignto(here,4,0)
    cpy %1, %2
    not %2
    a %2, 13
%endm

    ;; wait for reg to become 0
    ;; reg, trash
%macro wait_forn 2
    .org alignto(here,4,0)
    cpy %1, %2
    nop
    a %2, 13
%endm

    ;; set "input" to STDOUT
    ;; input, trash
%macro set_out_b 2
    wait_forn OU_A, %2
    cpy %1,OU
    not OU_A
%endm

    ;; get "output" from STDIN
    ;; output, trash
%macro get_in_b 2
    wait_for IN_A, %2
    cpy IN, %1
%endm

    ;; add together 2 addreses, store in second, 3 is carry
    ;; generated by brute force
    ;; A => A, B => A+B, Carry
    ;; 5 cycles
%macro add 3
    a %3, %3
    x %3, %2
    x %1, %3
    a %2, %3
    a %2, %2
    x %1, %2
    x %2, %3
%endm

%macro call 1
    set1 0x6e
    set0 0x6f
    c 0, 0x70, 0
    add 0x6e,0x7a,0x6f
    add 0x6e,0x79,0x6f
    not 0x6e
    add 0x6e,0x78,0x6f
    add 0x6e,0x77,0x6f
    add 0x6e,0x76,0x6f
    add 0x6e,0x75,0x6f
    add 0x6e,0x74,0x6f
    add 0x6e,0x73,0x6f
    add 0x6e,0x72,0x6f
    add 0x6e,0x71,0x6f
    add 0x6e,0x70,0x6f
    c labels[%1], 0, 1
    .orgr 34
%endm

%macro ret 0
    c 0x70, 0, 0
%endm

%macro exit 0
    .org alignto(here,2, 0)
    not 0xf
%endm

%macro printc_m 2
    set_out_b %1+ 0 , %2
    set_out_b %1+ 1 , %2
    set_out_b %1+ 2 , %2
    set_out_b %1+ 3 , %2
    set_out_b %1+ 4 , %2
    set_out_b %1+ 5 , %2
    set_out_b %1+ 6 , %2
    set_out_b %1+ 7 , %2
%endm
