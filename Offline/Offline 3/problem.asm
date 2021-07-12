.MODEL SMALL


.STACK 100H


.DATA
    CR EQU 0DH
    LF EQU 0AH
    
    NEWLINE DB CR, LF , '$'  
    
    PROMPT1 DB 'Enter First Number : $'      
    PROMPT2 DB 'Enter Second Number : $'    
    DEBUG DB 'DEBUG $' 
    
    PROMPT_OP DB 'Enter Operator : $'      

    WRONG DB 'Wrong operator$'
    
    X DW ?
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

    ;OUTPUT X
    ;MOV BX , X
    ;MOV FOR_PRINT, BX
    ;CALL OUTPUT
    
    LEA DX, NEWLINE ; DX : USED IN IO and MUL,DIV
    MOV AH, 9 ; AH,9 used for character string output
    INT 21H;
    
    ;print user prompt
    LEA DX, PROMPT_OP
    MOV AH, 9
    INT 21H
    
    MOV AH, 1
    INT 21H
    
    MOV OP , AL
         
    CMP AL , '+'
    JE INPUT_Y  
    
    CMP AL , '-'
    JE INPUT_Y
    
    CMP AL , '*'
    JE INPUT_Y
    
    CMP AL , '/'
    JE INPUT_Y
    
    CMP AL , 'q'
    JE EXIT 
    
WRONG_OP:

    LEA DX, NEWLINE ; DX : USED IN IO and MUL,DIV
    MOV AH, 9 ; AH,9 used for character string output
    INT 21H;

    ;print user prompt
    LEA DX, WRONG
    MOV AH, 9
    INT 21H
    
    JMP DOS_EXIT            
            
            
INPUT_Y:

    LEA DX, NEWLINE ; DX : USED IN IO and MUL,DIV
    MOV AH, 9 ; AH,9 used for character string output
    INT 21H;
    
    ;print user prompt
    LEA DX, PROMPT2
    MOV AH, 9
    INT 21H
    
    ; INPUT Y
    CALL INPUT 
    MOV BX , TEMP
    MOV Y , BX
    
    ; OUTPUT Y
    ;MOV BX , Y
    ;MOV FOR_PRINT, BX
    ;CALL OUTPUT   
    
    LEA DX, NEWLINE ; DX : USED IN IO and MUL,DIV
    MOV AH, 9 ; AH,9 used for character string output
    INT 21H;
    
    MOV AL , OP
         
    CMP AL , '+'
    JE ADD_BLOCK  
    
    CMP AL , '-'
    JE SUB_BLOCK
    
    CMP AL , '*'
    JE MUL_BLOCK
    
    CMP AL , '/'
    JE DIV_BLOCK
    
ADD_BLOCK: 

    CALL ADD_INT
    JMP EXIT
SUB_BLOCK:

    CALL SUB_INT 
    JMP EXIT
MUL_BLOCK:

    CALL MUL_INT
    JMP EXIT    
DIV_BLOCK:    
           
    CALL DIV_INT
    JMP EXIT
EXIT:

    MOV AH, 2
    MOV DL, '[' ; stored in DL for display 
    INT 21H

    ;OUTPUT X
    MOV BX , X
    MOV FOR_PRINT, BX
    CALL OUTPUT
    
    MOV AH, 2
    MOV DL, ']' ; stored in DL for display 
    INT 21H   
    
    MOV AH, 2
    MOV DL, OP ; stored in DL for display 
    INT 21H
    
    MOV AH, 2
    MOV DL, '[' ; stored in DL for display 
    INT 21H

    ;OUTPUT Y
    MOV BX , Y
    MOV FOR_PRINT, BX
    CALL OUTPUT
    
    MOV AH, 2
    MOV DL, ']' ; stored in DL for display 
    INT 21H
    
    MOV AH, 2
    MOV DL, '=' ; stored in DL for display 
    INT 21H

    ; OUTPUT RES
    MOV BX , RES
    MOV FOR_PRINT, BX
    CALL OUTPUT 

DOS_EXIT:
    
    ;DOS EXIT
    MOV AH, 4CH
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
    
        ;POP CX 
    
        RET     
      
OUTPUT ENDP

ADD_INT PROC
    
        MOV AX , X
        ADD AX , Y
        
        MOV RES , AX 
    
        RET
ADD_INT ENDP 


SUB_INT PROC
    
        MOV AX , X
        SUB AX , Y
        
        MOV RES , AX 
    
        RET
SUB_INT ENDP

MUL_INT PROC
    
        MOV AX , X
        MOV BX , Y
        
        IMUL BX ; Y * X
        MOV RES , AX
       
        RET
MUL_INT ENDP

DIV_INT PROC
    
        MOV AX , X
        CWD
        MOV BX , Y
        
        IDIV BX ; X / Y
        MOV RES , AX
       
        RET
DIV_INT ENDP

END MAIN