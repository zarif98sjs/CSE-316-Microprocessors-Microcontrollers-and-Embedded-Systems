.MODEL SMALL


.STACK 100H


.DATA
    CR EQU 0DH
    LF EQU 0AH
    
    NEWLINE DB CR, LF , '$'  
    
    PROMPT1 DB 'Enter First Number : $' 
    

    X DW ?
    Y DW ?
    GUN DW ?
    
    TEMP DW ?
    DG DW ?
    

.CODE

MAIN PROC
	;DATA SEGMENT INITIALIZATION
    MOV AX, @DATA
    MOV DS, AX
    

    ;print user prompt
    LEA DX, PROMPT1
    MOV AH, 9
    INT 21H
    
    CALL INPUT
    
    MOV BX , TEMP
    MOV X , BX
    
    CALL INPUT
    
    MOV BX , TEMP
    MOV Y , BX     
    
EXIT:
    ;DOS EXIT
    MOV AH, 4CH
    INT 21H

MAIN ENDP



INPUT PROC
    
        MOV TEMP , 0D
        XOR BX , BX
        MOV BX , TEMP 
    
    INPUT_LOOP:
    
        MOV AH, 1
        INT 21H
        
        CMP AL , 0DH ; ENTER is pressed
        JE EXIT_INPUT
        
        CMP AL, 30H
        JL INPUT_LOOP ; <30H
        
        CMP AL, 39H
        JG INPUT_LOOP ; >39H
                    
        SUB AL , 30H
        XOR AH , AH
        MOV DG , AX
                  
        XOR AX , AX
        MOV AX , 10D
        MOV BX , TEMP
        IMUL BX  ; LSB in AX , MSB in DX  : NOOOOOOOOOOO
        ADD AX , DG
        MOV TEMP , AX
        
        ;MOV AH, 2
        ;MOV DX, BX ; stored in DL for display 
        ;INT 21H
        
        
        ;LEA DX, NEWLINE ; DX : USED IN IO and MUL,DIV
        ;MOV AH, 9 ; AH,9 used for character string output
        ;INT 21H;
            
        
        JMP INPUT_LOOP
        
        
    EXIT_INPUT:
       
     
        RET
        
INPUT ENDP
                
                

END MAIN