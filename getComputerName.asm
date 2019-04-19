.386
.model flat, stdcall
option casemap :none

include \masm32\include\windows.inc
include \masm32\include\masm32.inc
include \masm32\include\kernel32.inc

includelib \masm32\lib\masm32.lib
includelib \masm32\lib\kernel32.lib

.data
    computerNameLength dd MAX_COMPUTERNAME_LENGTH
    computerName db MAX_COMPUTERNAME_LENGTH+1 dup(0)

.const
    computerNameLabel db "Computer name: ", 0

.code

start:

    push offset computerNameLength
    push offset computerName
    call GetComputerNameA

    push offset computerNameLabel
    call StdOut

    push offset computerName
    call StdOut

    push 0
    call ExitProcess

end start 