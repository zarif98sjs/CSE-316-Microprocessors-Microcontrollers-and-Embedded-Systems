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
    FOR_PRINT DW ?
    DG DW ? 
    
    DIV_RES DW ?
    DIV_REM DW ?
    
    MARKER DW 0DH
    

.CODE

MAIN PROC
	;DATA SEGMENT INITIALIZATION
    MOV AX, @DATA
    MOV DS, AX
    

    ;print user prompt
    LEA DX, PROMPT1
    MOV AH, 9
    INT 21H
    
    ; INPUT X
    CALL INPUT 
    MOV BX , TEMP
    MOV X , BX 
    
       
    ; OUTPUT X
    MOV BX , X
    MOV FOR_PRINT, BX
    CALL OUTPUT
    
    ; INPUT Y
    CALL INPUT 
    MOV BX , TEMP
    MOV Y , BX
    
    
    ; OUTPUT Y
    MOV BX , Y
    MOV FOR_PRINT, BX
    CALL OUTPUT     
    
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


OUTPUT PROC
               
        MOV CX , MARKER     
        PUSH CX ; marker
    

    OUTPUT_LOOP:
    
        ;MOV AH, 1
        ;INT 21H
        
        MOV AX , FOR_PRINT
        CWD
        MOV BX , 10D
        IDIV BX ; QUOTIENT : AX  , REMAINDER : DX     
        
        MOV FOR_PRINT , AX
    
        MOV DIV_RES , AX
        MOV DIV_REM , DX 
        
        PUSH DX
        
        CMP AX , 0H
        JNE OUTPUT_LOOP
        
        
        LEA DX, NEWLINE ; DX : USED IN IO and MUL,DIV
        MOV AH, 9 ; AH,9 used for character string output
        INT 21H;
            
        
    OP_STACK_PRINT:
    
        ;MOV AH, 1
        ;INT 21H
    
        POP BX
        
        CMP BX , MARKER
        JE EXIT_OUTPUT
        
       
        MOV AH, 2
        MOV DX, BX ; stored in DL for display 
        ADD DX , 30H
        INT 21H
        
        JMP OP_STACK_PRINT

    EXIT_OUTPUT:
    
        LEA DX, NEWLINE ; DX : USED IN IO and MUL,DIV
        MOV AH, 9 ; AH,9 used for character string output
        INT 21H;

        ;POP CX 
    
        RET     
      
OUTPUT ENDP
                

END MAIN