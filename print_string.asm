
; bx is a pointer to a character.
print_string:
	pusha
	mov ah, 0x0e ; teletype output
print_string_loop:
	mov al, [bx]
	cmp al, 0
	je print_string_fin
	int 0x10 ; print character
	add bx, 1
	jmp print_string_loop
print_string_fin:
	popa
	ret

