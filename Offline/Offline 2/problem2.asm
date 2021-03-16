.MODEL SMALL


.STACK 100H


.DATA
    CR EQU 0DH
    LF EQU 0AH
    
    NEWLINE DB CR, LF , '$'  
    
    PROMPT1 DB 'Enter Your Password : $' 
    
    OPT1 DB 'Valid password $'
    OPT2 DB 'Invalid password $' 


    X DB ?
    
    HI DB 0H 
    LO DB 0H
    DG DB 0H
    

.CODE

MAIN PROC
	;DATA SEGMENT INITIALIZATION
    MOV AX, @DATA
    MOV DS, AX
    

    ;print user prompt
    LEA DX, PROMPT1
    MOV AH, 9
    INT 21H  
    
INPUT_LOOP:
    MOV AH, 1
    INT 21H
    
    CMP AL,21H
    JL IF_1 ; <21H
    
    CMP AL,7EH
    JG IF_1 ; >7EH 
    
LO_1:    
    CMP AL,61H
    JGE  LO_2
    JMP HI_1
    
LO_2:   
    CMP AL,7AH 
    JNLE HI_1
    MOV LO,1H
    JMP INPUT_LOOP 
        
HI_1:    
    CMP AL,41H
    JGE  HI_2
    JMP DG_1
    
HI_2:
    CMP AL,5AH
    JNLE DG_1
    MOV HI,1H
    JMP INPUT_LOOP
    
DG_1:    
    CMP AL,30H
    JGE DG_2
    JMP INPUT_LOOP
    
DG_2:
    CMP AL, 39H 
    JNLE INPUT_LOOP
    MOV DG,1H
    JMP INPUT_LOOP
    
IF_1:  
    
    ; OUTPUT NEWLINE
    LEA DX, NEWLINE 
    MOV AH,9 
    INT 21H

    ;display LO  
    ;MOV AH, 2 
    ;MOV DL, LO
    ;ADD DL,30H
    ;INT 21H
    
    ;display HI  
    ;MOV AH, 2 
    ;MOV DL, HI
    ;ADD DL,30H
    ;INT 21H
    
    ;display DG  
    ;MOV AH, 2 
    ;MOV DL, DG
    ;ADD DL,30H
    ;INT 21H
    
    MOV AL,LO
    CMP AL,1H
    JNE INVALID
    
    MOV AL,HI
    CMP AL,1H
    JNE INVALID
    
    MOV AL,DG
    CMP AL,1H
    JNE INVALID
    
      
VALID: 

    ; OUTPUT NEWLINE
    LEA DX, NEWLINE 
    MOV AH,9 
    INT 21H 

    ;print string
    LEA DX, OPT1
    MOV AH, 9
    INT 21H
    
    JMP EXIT

INVALID: 

    ; OUTPUT NEWLINE
    LEA DX, NEWLINE 
    MOV AH,9 
    INT 21H 

    ;print string
    LEA DX, OPT2
    MOV AH, 9
    INT 21H
    
    JMP EXIT
       

EXIT:
    ;DOS EXIT
    MOV AH, 4CH
    INT 21H

MAIN ENDP
END MAIN
