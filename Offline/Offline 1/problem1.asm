.MODEL SMALL


.STACK 100H


.DATA
    CR EQU 0DH
    LF EQU 0AH
    
    NEWLINE DB CR, LF , '$'  
    
    PROMPT1 DB 'X = ? $'  
    PROMPT2 DB 'Y = ? $'
    
    
    OP1 DB 'Z = X-2Y = $' 
    OP2 DB 'Z = 25-(X+Y) = $'
    OP3 DB 'Z = 2X-3Y = $'
    OP4 DB 'Z = Y-X+1 = $'
    
    X DB ?
    Y DB ?
    Z DB ?

.CODE

MAIN PROC
	;DATA SEGMENT INITIALIZATION
    MOV AX, @DATA
    MOV DS, AX
    
;print user prompt
    LEA DX, PROMPT1
    MOV AH, 9
    INT 21H
    
;INPUT X
    MOV AH, 1
    INT 21H
    
    ; TRANSFER input to variable
    SUB AL, 30H
    MOV X, AL ; output is stored in AX
    
    ; OUTPUT NEWLINE
    LEA DX, NEWLINE 
    MOV AH,9 
    INT 21H 
    
    
;print user prompt
    LEA DX, PROMPT2
    MOV AH, 9
    INT 21H
    
;INPUT Y
    MOV AH, 1
    INT 21H
    
    ; TRANSFER input to variable
    SUB AL, 30H
    MOV Y, AL ; output is stored in AX
    
    ; OUTPUT NEWLINE
    LEA DX, NEWLINE 
    MOV AH,9 
    INT 21H
    

                
;OPERATION 1 : Z = X-2Y

    MOV AL,X
    SUB AL,Y
    SUB AL,Y
    ADD AL,30H
    MOV Z,AL
    
    ;print string
    LEA DX, OP1
    MOV AH, 9
    INT 21H
    
    ;display Z  
    MOV AH, 2
    MOV DL, Z
    INT 21H
    
    ; OUTPUT NEWLINE
    LEA DX, NEWLINE ;DX : USED IN IO and MUL,DIV
    MOV AH,9 ; AH,9 used for character string output
    INT 21H
    
    
    
;OPERATION 2 : Z = 25-(X+Y)

    MOV AL,25d
    SUB AL,X
    SUB AL,Y
    ADD AL,30H
    MOV Z,AL 
    
    ;print string
    LEA DX, OP2
    MOV AH, 9
    INT 21H
    
    ;display Z  
    MOV AH, 2
    MOV DL, Z
    INT 21H
    
    ; OUTPUT string
    LEA DX, NEWLINE ;DX : USED IN IO and MUL,DIV
    MOV AH,9 ; AH,9 used for character string output
    INT 21H
    
    
;OPERATION 3 : Z = 2X-3Y

    MOV AL,X
    ADD AL,X
    SUB AL,Y 
    SUB AL,Y
    SUB AL,Y
    ADD AL,30H
    MOV Z,AL 
    
    ;print string
    LEA DX, OP2
    MOV AH, 9
    INT 21H
    
    ;display Z  
    MOV AH, 2
    MOV DL, Z
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
