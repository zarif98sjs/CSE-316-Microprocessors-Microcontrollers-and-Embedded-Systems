.MODEL SMALL


.STACK 100H


.DATA
    CR EQU 0DH
    LF EQU 0AH
    
    NEWLINE DB CR, LF , '$'  
    
    PROMPT1 DB 'First Number = ? $'  
    PROMPT2 DB 'Second Number = ? $'   
    PROMPT3 DB 'Thrid Number = ? $'

    X DB ?
    Y DB ?
    Z DB ?
    
    MX1 DB ?
    MX2 DB ?
    

.CODE

MAIN PROC
	;DATA SEGMENT INITIALIZATION
    MOV AX, @DATA
    MOV DS, AX
    

    
;INPUT X 

    ;print user prompt
    LEA DX, PROMPT1
    MOV AH, 9
    INT 21H
    
    MOV AH, 1
    INT 21H
    
    ; TRANSFER input to variable
    SUB AL, 30H
    MOV X, AL ; output is stored in AX
    
    ; OUTPUT NEWLINE
    LEA DX, NEWLINE 
    MOV AH,9 
    INT 21H 
    
    
;INPUT Y 

    ;print user prompt
    LEA DX, PROMPT2
    MOV AH, 9
    INT 21H

    MOV AH, 1
    INT 21H
    
    ; TRANSFER input to variable
    SUB AL, 30H
    MOV Y, AL ; output is stored in AX
    
    ; OUTPUT NEWLINE
    LEA DX, NEWLINE 
    MOV AH,9 
    INT 21H
                 
                 
;INPUT Z

    ;print user prompt
    LEA DX, PROMPT3
    MOV AH, 9
    INT 21H
    
    MOV AH, 1
    INT 21H
    
    ; TRANSFER input to variable
    SUB AL, 30H
    MOV Z, AL ; output is stored in AX
    
    ; OUTPUT NEWLINE
    LEA DX, NEWLINE 
    MOV AH,9 
    INT 21H

                
;OPERATION 1 

IF_1:
    MOV AL,X    
    CMP AL,Y   ;
    JNG ELSE_1   ; write opposite condition here
    
    MOV AL,X     ; X > Y 
    MOV MX1,AL
    
    MOV AL,Y
    MOV MX2,AL
    JMP IF_2
     

ELSE_1:
    MOV AL,Y     ; Y >= X
    MOV MX1,AL
    
    MOV AL,X
    MOV MX2,AL
    
    
IF_2:
    MOV AL,Z
    CMP AL,MX1
    JNG IF_3
                ; Z > MX1
    MOV AL,MX1 
    MOV MX2,AL ; MX2 = MX1
    
    MOV AL,Z
    MOV MX1,AL ; MX1 = Z 
    JMP DISPLAY
    
IF_3:
    MOV AL,Z
    CMP AL,MX2
    JNG DISPLAY
    
                ; Z > MX2
    MOV AL,Z
    MOV MX2,AL
    JMP DISPLAY 
    
               
DISPLAY:
;display Z  
    MOV AH, 2  
    ADD MX1,30H
    MOV DL, MX1 
    INT 21H
                  
                  
;display Z  
    MOV AH, 2 
    ADD MX2,30H
    MOV DL, MX2
    INT 21H


;DOS EXIT
MOV AH, 4CH
INT 21H

MAIN ENDP
END MAIN
