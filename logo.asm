;this file to store starting image of game due to its large size


public DrawLogo

extrn Delay1s:near
.Model compact
.Stack 64
.Data

LogoWidth EQU 120
LogoHeight EQU 120

;store bin file of image
LogoFile DB 'sl.bin', 0

;handle if file is input or output(read or write)
LogoHandle DW ?
;resolution of image(number of total bytes
LogoData DB LogoWidth*LogoHeight dup(0)

.Code
DrawLogo PROC FAR
    ;got to gfx mode
    MOV AH, 0
    MOV AL, 13h
    INT 10h
	
    CALL OpenFile
    CALL ReadData
	
    LEA BX , LogoData ; BL contains index at the current drawn pixel
	
	;start at column 95, row 50
    MOV CX,95
    MOV DX,50
    MOV AH,0ch
	
; Drawing loop
drawLoop:
    MOV AL,[BX]
    INT 10h 
    INC CX
    INC BX
    CMP CX,LogoWidth+95
JNE drawLoop 
	
    MOV CX ,95
    INC DX
    CMP DX , LogoHeight+50
JNE drawLoop

;loop to make delay 5s
mov cx,5
delay5s:
call Delay1s
loop delay5s

	
    ;close file after finishing dalay time
    call CloseFile
    
ret    
DrawLogo ENDP




OpenFile PROC 

    ; Open file

    MOV AH, 3Dh
    MOV AL, 0 ; read only
    LEA DX, LogoFile
    INT 21h
    MOV [LogoHandle], AX
    RET

OpenFile ENDP

ReadData PROC

    MOV AH,3Fh
    MOV BX, [LogoHandle]
    MOV CX,LogoWidth*LogoHeight ; number of bytes to read
    LEA DX, LogoData
    INT 21h
    RET
ReadData ENDP 


CloseFile PROC
	MOV AH, 3Eh
	MOV BX, [LogoHandle]

	INT 21h
	RET
CloseFile ENDP

END 