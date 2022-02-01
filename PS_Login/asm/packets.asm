CUser_OnRecv_Return     equ     0x404374    ; The address to return to if we didn't handle a handle ourselves.
CUser_OnRecv_Exit       equ     0x404555    ; The address to jump to if we successfully handled a packet.
LoginRequestHandle      equ     0x4044B5    ; The address for handling a login request.
OAuth_Init_Opcode       equ     0xA114      ; Some sort of OAuth initialisation opcode.
OAuth_Opcode            equ     0xA110      ; The OAuth login packet opcode.
Login_Opcode            equ     0xA102      ; The normal login opcocde.
Separator               equ     "/"         ; The character used for separating the username and password
UsernameLength          equ     32          ; The length of a username (with padding).
PasswordLength          equ     20          ; The length of a password (with padding).

; A trampoline function for intercepting function calls to CUser::OnRecv.
; edi = user
; ebp = packet
CUser_OnRecv:
    ; Load the opcode into eax.
    movzx eax, word [ebp + 2]
    add ebp, 2  ; Add 2 to ebp so that future functions ignore the length.

    ; If the opcode is the OAuth packet, we should handle it here.
    cmp eax, OAuth_Opcode
    je CUser_OnRecv_OAuth

    ; If the opcode is an initialisation opcode, skip it.
    cmp eax, OAuth_Init_Opcode
    je CUser_OnRecv_Exit

    ; Exit the function and continue processing packets as normal.
    jmp CUser_OnRecv_Return

; Handle the OAuth login request. This is actually a really cheap fix - it just reads the username and password onto the stack,
; and then modifies the packet held at ebp to look like a normal `A102` login packet, then passes it to the normal login handler.
CUser_OnRecv_OAuth:
    ; Preserve the state of the registers we're going to need
    push edx
    push ecx
    push ebx
    push esi

    ; Allocate 32 bytes each for the username and the password.
    lea edx, [esp - 64] ; Username
    lea ecx, [esp - 32] ; Password

    ; Replace the opcode of the packet
    mov word [ebp], Login_Opcode
    add ebp, 2

    ; Read the username.
    xor eax, eax
    .username_loop:
        mov bl, byte [ebp + eax]    
        cmp bl, Separator
        je .username_exit
        cmp eax, UsernameLength
        jge .username_exit
        mov byte [ebp + eax], bl
        inc eax
        jmp .username_loop
    .username_exit:
        mov byte [ebp + eax], 0
        inc eax

    ; Read the password.
    xor esi, esi
    .password_loop:
        mov bl, byte [ebp + eax]    
        cmp bl, Separator
        je .password_exit
        cmp esi, PasswordLength
        jge .password_exit
        mov byte [ebp + esi + UsernameLength], bl
        inc eax
        inc esi
        jmp .password_loop
    .password_exit:
        mov byte [ebp + esi + UsernameLength], 0

    ; Restore the state of the registers we were using.
    pop esi
    pop ebx
    pop ecx
    pop edx

    ; Handle the packet as if it were a normal login.
    sub ebp, 2
    jmp LoginRequestHandle