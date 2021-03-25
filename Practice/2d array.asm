.MODEL SMALL


.STACK 100H   


.DATA
    CR EQU 0DH
    LF EQU 0AH
    
    NEWLINE DB CR, LF , '$'  
    
    PROMPT1 DB 'Enter N : $'        

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
    
    VAR DW 0H
    
    
.CODE

MAIN PROC   
    
    
    ;DATA SEGMENT INITIALIZATION
    MOV AX, @DATA
    MOV DS, AX  
    
    
    ;print user prompt
    LEA DX, PROMPT1
    MOV AH, 9
    INT 21H
            
    ; INPUT N
    CALL INPUT 
    MOV BX , TEMP
    MOV N , BX 
    
    LEA DX, NEWLINE ; DX : USED IN IO and MUL,DIV
    MOV AH, 9 ; AH,9 used for character string output
    INT 21H;
    
    ;OUTPUT N
    ;MOV BX , N
    ;MOV FOR_PRINT, BX
    ;CALL OUTPUT
    
    
COMPUTE_FIB:

    MOV BX, N
    CMP BX, VAR
    JE DOS_EXIT
            
    MOV AX,VAR ; N = 4
    PUSH AX  ; pushing N to stack
    
    CALL FIBONACCI ; when this is called , address of next line is pushed into the stack
    
    ;OUTPUT FIB
    MOV FOR_PRINT, AX
    CALL OUTPUT 
    
    MOV AH, 2
    MOV DL, ',' ; stored in DL for display 
    INT 21H
    
    
    INC VAR 
    JMP COMPUTE_FIB
    
DOS_EXIT:
    
    MOV AH,4CH
    INT 21H 
    
MAIN ENDP

FIBONACCI PROC NEAR

    PUSH BP
    MOV BP,SP ; BP now points to the top of the stack
    CMP WORD PTR[BP+4],1 ; N = 1 ? : as we stored in AX(WORD) we need to explicitly mention that when using PTR
    
    JG END_IF

    MOV AX,[BP+4]    ;BASE CASE : if( n<=1 ) return n
    JMP RETURN

END_IF:
; COMPUTE F(N-1)
    MOV CX, [BP+4]  ; get N
    DEC CX          ; N = N - 1
    PUSH CX         ; save N - 1

    CALL FIBONACCI  ; RES1 in AX
     
    PUSH AX         ; save RES1
    
; COMPUTE F(N-2)
    MOV CX, [BP+4]  ; get N
    DEC CX          ; N = N - 1   
    DEC CX          ; N = N - 2
    PUSH CX         ; save N - 2
    
    CALL FIBONACCI
    
    POP BX
    ADD AX,BX

RETURN:
    POP BP
    RET 2
    
FIBONACCI ENDP   



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

    END MAIN