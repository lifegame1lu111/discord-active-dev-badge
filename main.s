    .globl main

    .data
    .p2align 3
token:
    .asciz "TOKEN"
    .p2align 3
S1:
    .asciz "activatebadge"
    .p2align 3
S2:
    .asciz "Successfully fulfilled the requirements for the active bot developer badge!"
    .p2align 3
S3:
    .asciz "Become eligible for the active bot developer badge"
    .p2align 3
command1:
    .quad S1
    .quad S3
    .quad 0, 2048, 1, 0, 0
    .p2align 4
embed:
    .quad S2
    .quad 0, 0, 0, 0
    .quad 1181375
    .quad 0, 0, 0, 0, 0, 0, 0
embeds:
    .quad 1
    .quad embed
    .p2align 4
response_data:
    .quad 0, 0, 0
    .quad embeds
    .quad 0, 0, 0, 0, 0
response:
    .quad 4
    .quad response_data

    .text
    .p2align 2
on_interaction:
    ldr x2, [x1, 64]
    ldr x1, [x1]
    adrp x3, response
    add x3, x3, :lo12:response
    mov x4, xzr
    b discord_create_interaction_response

on_login:
    stp x29, x30, [sp, -32]!
    str x0, [sp, 16]
    bl discord_get_self
    ldr x1, [x0]
    ldr x0, [sp, 16]
    adrp x2, command1
    add x2, x2, :lo12:command1
    mov x3, xzr
    ldp x29, x30, [sp], 32
    b discord_create_global_application_command

main:
    adrp x0, token
    add x0, x0, :lo12:token
    bl getenv
    bl discord_init
    mov x8, x0
    adrp x1, on_interaction
    add x1, x1, :lo12:on_interaction
    bl discord_set_on_interaction_create
    mov x0, x8
    adrp x1, on_login
    add x1, x1, :lo12:on_login
    bl discord_set_on_ready
    mov x0, x8
    b discord_run
