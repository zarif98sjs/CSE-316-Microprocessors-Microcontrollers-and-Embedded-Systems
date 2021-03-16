.MODEL SMALL


.STACK 100H


.DATA 

    CR EQU 0DH
    LF EQU 0AH
    
    NEWLINE DB CR, LF , '$'  
    
    PROMPT1 DB 'First Number = ? $'  
    PROMPT2 DB 'Second Number = ? $'   
    PROMPT3 DB 'Thrid Number = ? $'
    
    OPT1 DB 'All the numbers are equal $'
    OPT2 DB 'Second Maximum Number = $'

    X DW ?
    Y DW ?
    Z DB ?
    
    MX1 DB ?
    MX2 DB ?
    

.CODE

MAIN PROC
	;DATA SEGMENT INITIALIZATION
    MOV AX, @DATA
    MOV DS, AX     
    
    ;; + - 
    ;; + +
    ;; - -
    
    ;; FFFF FFFF
    ;; 0000 0014  ; signed bit negative , so need to find 2's comp
    ;; + 1 
    ;; 0000 FFEC 
    
    ;; 24 bit 1 , 1110 1100
    ;; 
                 
    MOV X, -5000D
    ;MOV Y, 40D ;    
    ;MOV Y, 0FFD8H ;    
    MOV Y, 40D ;
    MOV AX, X
    CWD
    MOV BX, Y
    IDIV BX
    
    

    
;; 0000 0100H  ; 256      
;; 2 5 6    
    
EXIT:
    ;DOS EXIT
    MOV AH, 4CH
    INT 21H

MAIN ENDP
END MAIN
