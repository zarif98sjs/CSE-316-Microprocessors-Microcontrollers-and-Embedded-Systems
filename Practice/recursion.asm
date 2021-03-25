.MODEL SMALL


.STACK 100H


.CODE

MAIN PROC

    MOV AX,4 ; N = 4
    PUSH AX  ; pushing N to stack
    
    CALL FACTORIAL ; when this is called , address of next line is pushed into the stack
    MOV AH,4CH
    INT 21H 
    
MAIN ENDP

FACTORIAL PROC NEAR

    PUSH BP
    MOV BP,SP ; BP now points to the top of the stack
    CMP WORD PTR[BP+4],1 ; N = 1 ? : as we stored in AX(WORD) we need to explicitly mention that when using PTR
    
    JG END_IF

    MOV AX,1    ; MULTIPLY : as one input is in AX , we initialize that with 1
    JMP RETURN

END_IF:
    MOV CX, [BP+4]
    DEC CX
    PUSH CX

    CALL FACTORIAL

    MUL WORD PTR[BP+4]

RETURN:
    POP BP
    RET 2
    
FACTORIAL ENDP

    END MAIN