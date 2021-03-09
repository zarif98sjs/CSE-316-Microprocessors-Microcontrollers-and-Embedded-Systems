.MODEL SMALL


.STACK 100H


.DATA
    CR EQU 0DH
    LF EQU 0AH
    
    MSG1 DB 'FIRST NUMBER :$'
    MSG2 DB 'SECOND NUMBER :$'
    NUM1 DB ?
    NUM2 DB ? 

.CODE

MAIN PROC
    
	; DATA SEGMENT INITIALIZATION
    MOV AX, @DATA ;AX : ACCUMULATOR DATA REGISTER : preffered register to use in arithmetic logic and transfer operation
    MOV DS, AX ;DS : DATA SEGMENT
    
    
    ; OUTPUT string
    LEA DX, MSG1 ;DX : USED IN IO and MUL,DIV
    MOV AH,9 ; AH,9 used for character string output
    INT 21H;  
        
    ; INPUT single key from user
    MOV AH, 1
    INT 21H
    
    ; TRANSFER input to variable
    MOV NUM1, AL ; output is stored in AL
    
    ; OUTPUT string
    LEA DX, MSG2 ;DX : USED IN IO and MUL,DIV
    MOV AH,9 ; AH,9 used for character string output
    INT 21H;  
        
    ; INPUT single key from user
    MOV AH, 1
    INT 21H
    
    ; TRANSFER input to variable
    MOV NUM2, AL ; output is stored in AL
    
    
    ;display the lower case character  
    MOV DL, NUM1   
    MOV AH, 2
    INT 21H
    
    ;display the lower case character  
    MOV AH, 2
    MOV DL, NUM2
    INT 21H
    

    
    ;DOS EXIT
    MOV AH, 4CH
    INT 21H

MAIN ENDP
END MAIN
