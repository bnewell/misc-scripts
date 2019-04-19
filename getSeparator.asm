.386
.model flat, stdcall
option casemap :none

include \masm32\include\windows.inc
include \masm32\include\masm32.inc
include \masm32\include\kernel32.inc

includelib \masm32\lib\masm32.lib
includelib \masm32\lib\kernel32.lib

.data?
    listSeparator db 4 dup(?)


.const
    separatorLabel db "Current separator: ", 0

.code

start:

    push 4d
    push offset listSeparator
    push LOCALE_SLIST
    push LOCALE_USER_DEFAULT
    call GetLocaleInfoA

    push offset separatorLabel
    call StdOut

    push offset listSeparator
    call StdOut

    push 0
    call ExitProcess

end start 