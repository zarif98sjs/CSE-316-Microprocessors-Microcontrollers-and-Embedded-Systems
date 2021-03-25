.MODEL SMALL


.STACK 100H   


.DATA
    CR EQU 0DH
    LF EQU 0AH
    
    NEWLINE DB CR, LF , '$'  
    
    PROMPT1 DB 'Enter First Matrix : ' , CR, LF , '$'
    PROMPT2 DB 'Enter Second Matrix : ', CR, LF , '$'       
    PROMPT3 DB 'Resultant Matrix : ', CR, LF , '$'
    
    N DW ?
    Y DW ?
    RES DW ? 
    
    IS_NEG DB ?
    
    TEMP DW ?
    FOR_PRINT DW ?
    DG DW ? 
    
    DIV_RES DW ?
    DIV_REM DW ?
    
    MARKER DW 0DH 
    
    OP DB ?
    
    ARA_A DW 10,20
          DW 40,50
          
    ARA_B DW 10,20
          DW 40,50
    
    
.CODE

MAIN PROC   
    
    
    ;DATA SEGMENT INITIALIZATION
    MOV AX, @DATA
    MOV DS, AX
    
    ;print user prompt
    LEA DX, PROMPT1
    MOV AH, 9
    INT 21H
    
            
; INPUT 2D ARRAY
    MOV BX , 0 ; BASE POINTER TO 0
    XOR SI , SI
    MOV CX , 4 ; NUMBER OF ELEMENTS
ARA_A_INPUT:

    MOV AH,1
    INT 21H 
    
    XOR AH,AH
    SUB AL,30H
      
    MOV ARA_A[BX][SI] , AX 
    ADD SI,2
    
    MOV AH, 2
    MOV DL, ' ' ; stored in DL for display 
    INT 21H
    
    MOV AX , SI
    XOR DX , DX
    MOV BX , 4D
    DIV BX
    
    CMP DX , 0
    JNE NO_NEWLINE1
    
    ; NEWLINE 
    LEA DX, NEWLINE ; DX : USED IN IO and MUL,DIV
    MOV AH, 9 ; AH,9 used for character string output
    INT 21H;
              
NO_NEWLINE1:
    
    XOR BX , BX
    LOOP ARA_A_INPUT
    
    ; NEWLINE 
    LEA DX, NEWLINE ; DX : USED IN IO and MUL,DIV
    MOV AH, 9 ; AH,9 used for character string output
    INT 21H; 
            
            
    ;print user prompt
    LEA DX, PROMPT2
    MOV AH, 9
    INT 21H     

; INPUT 2D ARRAY
    MOV BX , 0 ; BASE POINTER TO 0
    XOR SI , SI
    MOV CX , 4 ; NUMBER OF ELEMENTS
ARA_B_INPUT:

    MOV AH,1
    INT 21H 
    
    XOR AH,AH
    SUB AL,30H
      
    MOV ARA_B[BX][SI] , AX 
    ADD SI,2
           
    MOV AH, 2
    MOV DL, ' ' ; stored in DL for display 
    INT 21H
      
    MOV AX , SI
    XOR DX , DX
    MOV BX , 4D
    DIV BX
    
    CMP DX , 0
    JNE NO_NEWLINE2
    
    ; NEWLINE 
    LEA DX, NEWLINE ; DX : USED IN IO and MUL,DIV
    MOV AH, 9 ; AH,9 used for character string output
    INT 21H;
              
NO_NEWLINE2:
    
    XOR BX , BX
    LOOP ARA_B_INPUT
        
    ; NEWLINE 
    LEA DX, NEWLINE ; DX : USED IN IO and MUL,DIV
    MOV AH, 9 ; AH,9 used for character string output
    INT 21H;
    
    
    ;print user prompt
    LEA DX, PROMPT3
    MOV AH, 9
    INT 21H                   
                 
           
; SUM two 2x2 array
    MOV BX , 0
    XOR SI , SI
    XOR DI , DI
    MOV CX , 4 
    
SUM_ARA:
    MOV AX , ARA_A[BX][SI]
    ADD AX , ARA_B[BX][DI]
    
    ADD SI,2 
    ADD DI,2
    
    MOV FOR_PRINT,AX
    CALL OUTPUT
    
    MOV AH, 2
    MOV DL, ' ' ; stored in DL for display 
    INT 21H

    MOV AX , SI
    XOR DX , DX
    MOV BX , 4D
    DIV BX
    
    CMP DX , 0
    JNE NO_NEWLINE_SUM
    
    ; NEWLINE 
    LEA DX, NEWLINE ; DX : USED IN IO and MUL,DIV
    MOV AH, 9 ; AH,9 used for character string output
    INT 21H;
              
NO_NEWLINE_SUM:

    XOR BX , BX
    LOOP SUM_ARA      
    
DOS_EXIT:
    
    MOV AH,4CH
    INT 21H 
    
MAIN ENDP


INPUT PROC
    
        MOV TEMP , 0D
        XOR BX , BX
        MOV BX , TEMP
        
        MOV IS_NEG , 0H
        
        MOV AH, 1
        INT 21H
        
        CMP AL , '-'   ; - sign
        JNE CHK_INPUT    
        MOV IS_NEG,1
    
    INPUT_LOOP:
    
        MOV AH, 1
        INT 21H
        
        CMP AL , 0DH ; ENTER is pressed
        JE MINUS
        
        CHK_INPUT:
        
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
        
    MINUS:
    
        MOV AL , IS_NEG
        CMP AL , 1H
        JNE EXIT_INPUT
        
        MOV AX , 0FFFFH
        SUB AX , TEMP
        ADD AX , 1H
        MOV TEMP , AX
        
    EXIT_INPUT:
    
        RET
        
INPUT ENDP


OUTPUT PROC
               
        PUSH BX
        PUSH CX 
               
        MOV CX , MARKER     
        PUSH CX ; marker
        
        MOV IS_NEG, 0H
        MOV AX , FOR_PRINT
        TEST AX , 8000H
        JE OUTPUT_LOOP
                    
        MOV IS_NEG, 1H
        MOV AX , 0FFFFH
        SUB AX , FOR_PRINT
        ADD AX , 1H
        MOV FOR_PRINT , AX

    OUTPUT_LOOP:
    
        ;MOV AH, 1
        ;INT 21H
        
        MOV AX , FOR_PRINT
        XOR DX,DX
        MOV BX , 10D
        DIV BX ; QUOTIENT : AX  , REMAINDER : DX     
        
        MOV FOR_PRINT , AX
    
        MOV DIV_RES , AX
        MOV DIV_REM , DX 
        
        PUSH DX
        
        CMP AX , 0H
        JNE OUTPUT_LOOP
        
        ;LEA DX, NEWLINE ; DX : USED IN IO and MUL,DIV
        ;MOV AH, 9 ; AH,9 used for character string output
        ;INT 21H;

        MOV AL , IS_NEG
        CMP AL , 1H
        JNE OP_STACK_PRINT
        
        MOV AH, 2
        MOV DX, '-' ; stored in DL for display 
        INT 21H
            
        
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
    
        POP CX       
        POP BX
    
        RET     
      
OUTPUT ENDP

    END MAIN