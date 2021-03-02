.MODEL SMALL


.STACK 100H


.DATA
    CR EQU 0DH
    LF EQU 0AH
    
    NEWLINE DB CR, LF , '$'  
    
    PROMPT DB 'Enter an upper case letter : $'
    
    OUTPUT1 DB 'Previous lowercase letter : $'   
    OUTPUT2 DB '1s compliments  : $'
    
    CHAR DB ?
    P_LO DB ?
    COMP DB ?

.CODE

MAIN PROC
	;DATA SEGMENT INITIALIZATION
    MOV AX, @DATA
    MOV DS, AX
    
;print user prompt
    LEA DX, PROMPT
    MOV AH, 9
    INT 21H
    
;INPUT UPPER CASE
    MOV AH, 1
    INT 21H
   
    ; STORE IN CHAR           
    MOV CHAR,AL
    
; CONVERT TO LOWER CASE
    ADD AL, 20H
    SUB AL, 1D
    MOV P_LO, AL ; output is stored in AL 
    
    ; OUTPUT NEWLINE
    LEA DX, NEWLINE 
    MOV AH,9 
    INT 21H
    
    ; OUTPUT STRING
    LEA DX, OUTPUT1 
    MOV AH,9 
    INT 21H 
            
    ;DISPLAY LOWER CASE  
    MOV AH, 2
    MOV DL, P_LO
    INT 21H
            
    ; OUTPUT NEWLINE
    LEA DX, NEWLINE 
    MOV AH,9 
    INT 21H 
    
; CONVERT TO 1's COMPLIMENT
    MOV AL,0FFH
    SUB AL,CHAR
    MOV CHAR,AL
    
    
    ; OUTPUT NEWLINE
    LEA DX, NEWLINE 
    MOV AH,9 
    INT 21H
    
    ; OUTPUT STRING
    LEA DX, OUTPUT2 
    MOV AH,9 
    INT 21H 
            
    ;DISPLAY LOWER CASE  
    MOV AH, 2
    MOV DL, CHAR
    INT 21H
    

    
    
;DOS EXIT
MOV AH, 4CH
INT 21H

MAIN ENDP
END MAIN
