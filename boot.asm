; Simple boot: Loads other sectors into memory and jumps to them.
[org 0x7c00]

mov bx, HELLO
call print_string

mov [BOOT_DRIVE], dl
mov bp, 0x8000 ; Move stack elsewhere
mov sp, bp


mov bx, 0x9000 ; (es:bx) is memory location to write to
mov dh, 5 ; read 5 sectors from disk
mov dl, [BOOT_DRIVE] ; read from boot drive
call disk_load

; [0x9000] now contains the loaded memory, starting at sector after us

mov bx, 0x9000
call print_string ; expect "second"


call disk_load
mov bx, LOADED
call print_string
jmp $

HELLO: db "Booting", 0
LOADED: db "Disk loaded", 0

BOOT_DRIVE: db 0

%include "print_string.asm"

; load DH sectors to ES:BX from drive DL
disk_load:
	push dx ; Store DX on stack so later we can recall
	; how many sectors were request to be read ,
	; even if it is altered in the meantime
	mov ah, 0x02 ; BIOS read sector function
	mov al, dh ; Read DH sectors
	mov ch, 0x00 ; Select cylinder 0
	mov dh, 0x00 ; Select head 0
	mov cl, 0x02 ; Start reading from second sector ( i.e.
	; after the boot sector )
	int 0x13 ; BIOS interrupt
	jc disk_error ; Jump if error ( i.e. carry flag set )
	pop dx ; Restore DX from the stack
	cmp dh, al ; if AL ( sectors read ) != DH ( sectors expected )
	jne disk_error ; display error message
	ret

disk_error:
	mov bx, DISK_ERROR_MSG
	call print_string
	jmp $


DISK_ERROR_MSG: db " Disk read error !" , 0

; Padding + magic boot number
times 510 - ($ - $$) db 0
dw 0xaa55 ; magic number

; Becomes address 9000
db "second", 0

times 512 db 0
times 512 db 0
times 512 db 0
times 512 db 0
times 512 db 0
times 512 db 0