[org 0x7c00]

; A simple boot sector that prints a message.
mov ah, 0x0e ; Enter teletype mode for interrupt 0x10

mov al, 'H' ; interrupt 0x10 character argument
int 0x10
mov al, 'e' ; interrupt 0x10 character argument
int 0x10
mov al, 'l' ; interrupt 0x10 character argument
int 0x10
mov al, 'l' ; interrupt 0x10 character argument
int 0x10
mov al, 'o' ; interrupt 0x10 character argument
int 0x10

jmp $

; Padding + magic boot number
times 510-($-$$) db 0
dw 0xaa55 ; magic number