.386
.model flat, stdcall
option casemap :none

include \masm32\include\windows.inc
include \masm32\include\kernel32.inc
include \masm32\include\masm32.inc
includelib \masm32\lib\kernel32.lib
includelib \masm32\lib\masm32.lib

.data
    ten dd 10d ; newline
    thirteen dd 13d ; carriage return
    colonSpace dd 093Ah
    header db "Dec", 09h, "Symbol", 0Ah, 0

.data?
    buffer dd ? ; ascii symbol - actual number
    idx dd ? ; ascii counter - number in ascii (ie 31 = 1, 12 = 31 32)
       
.code
start:
    push offset header
    call StdOut
    xor ecx, ecx
_loop:
    push ecx
    pop buffer
    push ecx
    pop idx
    ; save ecx as stdout wipes it
    push ecx

    ; convert our index to ascii
    push offset idx
    push ecx
    call dwtoa
    
    ; print ascii index
    push offset idx
    call StdOut
    
    ; print colon and space
    push offset colonSpace
    call StdOut
    
    ; print symbol
    push offset buffer
    call StdOut

    ; skip newline if we're on newline symbol (10d)
    cmp buffer, 0Ah
    je _checkCounter
    
_printNewline:
    ; LF / New Line
    push offset ten
    call StdOut
    ; CR / Carriage Return
    push offset thirteen
    call StdOut

_checkCounter:
    ; get ecx back
    pop ecx
    inc ecx
    cmp ecx, 128
    jne _loop

    ; loop done
    invoke ExitProcess, 0

end start 