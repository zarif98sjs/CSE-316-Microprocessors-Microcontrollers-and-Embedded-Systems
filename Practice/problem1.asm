.MODEL SMALL


.STACK 100H


.DATA
    CR EQU 0DH
    LF EQU 0AH
    
    NEWLINE DB CR, LF
    
    X DW ?
    Y DW ?
    Z DW ?

.CODE

MAIN PROC
	;DATA SEGMENT INITIALIZATION
    MOV AX, @DATA
    MOV DS, AX
    
;INPUT X
    MOV AH, 1
    INT 21H
    
    ; TRANSFER input to variable
    SUB AX, 30H
    MOV X, AX ; output is stored in AX
    
;INPUT Y
    MOV AH, 1
    INT 21H
    
    ; TRANSFER input to variable
    SUB AX, 30H
    MOV Y, AX ; output is stored in AX
    

                
;OPERATION 1 : Z = X-2Y

    MOV AX,X
    SUB AX,Y
    SUB AX,Y
    ADD AX,30H
    MOV Z,AX
    
    ;display Z  
    MOV AH, 2
    MOV DX, Z
    INT 21H
    
    ; OUTPUT string
    LEA DX, NEWLINE ;DX : USED IN IO and MUL,DIV
    MOV AH,9 ; AH,9 used for character string output
    INT 21H
    
    
    ;DOS EXIT
    MOV AH, 4CH
    INT 21H

MAIN ENDP
END MAIN
