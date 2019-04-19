.386
.model flat, stdcall
option casemap :none

include \masm32\include\masm32.inc
include \masm32\include\kernel32.inc
includelib \masm32\lib\masm32.lib
includelib \masm32\lib\kernel32.lib

.data
    plainText db "encrypt this", 0 ; 
    counter dd 0
    keyCounter dd 0
    isDecrypted dd 0

.data?  
    len dd ?
    keyLen dd ?
    plainTextChar db ?
    encryptedWith db ?
    key db 100 dup(?)

.const
    enterKeyPrompt db "Please enter a key:", 0
    plainTextPrompt db "Plaintext: ",0
    keyPrompt db "Key: ",0
    encryptedPrompt db "Encrypted: ",0
    newline db 10d,0
    decryptedPrompt db "Decrypted: ",0
    
       
.code

start:

    push offset enterKeyPrompt 
    call StdOut

    ; get key from user
    push 100
    push offset key
    call StdIn

    push offset plainTextPrompt 
    call StdOut

    push offset plainText
    call StdOut

    push offset newline
    call StdOut

    push offset keyPrompt
    call StdOut

    push offset key
    call StdOut

    push offset newline
    call StdOut

    ; get length of plainText
    push offset plainText
    call StrLen
    mov len, eax
    
    ; get length of key
    push offset key
    call StrLen
    mov keyLen, eax

_loop:

    ; if at end of key, reset key counter to 0
    mov ecx, [keyCounter]
    cmp ecx, [keyLen]
    je _resetKeyCounter

    ; get key char to encrypt with
    mov eax, offset key
    add eax, [keyCounter]
    xor ecx, ecx
    mov cl, [eax]
    mov encryptedWith, cl

    ; encrypt plaintext at counter offset
    mov eax, offset plainText
    add eax, [counter]
    xor ecx, ecx
    mov cl, [eax]
    xor cl, [encryptedWith]
    mov [eax], cl

    ; increase keyCounter
    inc [keyCounter]

    ; increase counter
    inc [counter]
    jmp _checkCounter

_resetKeyCounter:
    mov [keyCounter], 0
    jmp _loop
  
_checkCounter:
    ; check counter
    mov ecx, [counter]
    cmp ecx, len
    jne _loop

_printEncrypted:
    ; skip if decrypting
    cmp [isDecrypted], 1
    je _exit

    ; print encrypted text
    push offset encryptedPrompt 
    call StdOut

    push offset newline 
    call StdOut

    push offset plainText
    call StdOut

_decrypt:
    ; set decrypted flag and reset counters
    mov [isDecrypted], 1
    mov [keyCounter], 0
    mov [counter], 0
    jmp _loop

_exit:
    ; print decrypted
    push offset newline
    call StdOut

    push offset decryptedPrompt 
    call StdOut

    push offset plainText 
    call StdOut

    ;exit
    push 0
    call ExitProcess

end start 