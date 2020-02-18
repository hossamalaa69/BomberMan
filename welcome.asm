extrn NamePlayer2:byte
extrn lenp2:byte
extrn p1Lifes:byte
extrn p1Bombs:byte
extrn p2Lifes:byte
extrn p2Bombs:byte
extrn GameCycle:near

public WelcomeStart, USNAME,LenUSNAME,P1Name,PAGE2,ScoreEnd
public Delay1s
.Model compact
.STACK 64
.DATA

;some string for messages on screen 

mess1 db 'Welcome To The Game', '$'
mess2 db 'Please Enter Your Name:', '$'
mess3 db 'Press Enter to Continue', '$'
chmes db '*To statrt chatting press F1', '$'
plmes db '*To start a game press F2', '$'
exmes db '*To end the program press ESC', '$'
outOfChat db 'Press F3 to end chatting with ','$'

lifsc db 'Life Score:'  
lifsclen db 11 
bombsc db 'Bombs Score:' 
bombsclen db 12

winstr db 'WINS' 
winlen db 4

drwstr db 'DRAW'
drwlen db 4

;username input
USNAME  db 20
LenUSNAME db ?
P1Name db 20 dup('$')

;dimensions of game over image
GoverWidth EQU 220
GoverHeight EQU 80
;store bin file
GoverFile DB 'GameOver.bin', 0
;decide if file is read or write
GoverHandle DW ?
;resoltion of image(size of bytes)
FileData DB GoverWidth*GoverHeight dup(0)



.CODE
;as a main function for this program
WelcomeStart	PROC FAR

		CALL cleanPage
		CALL PAGE1
		CALL cleanPage          ;clearing the page
		CALL PAGE2	
		
WelcomeStart	ENDP


cleanPage	PROC 
		MOV AX, 0600H
		MOV BH, 07
		MOV CX, 0000
		MOV DX, 184FH	;cleaning the page
		INT 10H
		RET
cleanPage	ENDP

;--------------------------------------------------

printchar	proc 
		
		MOV AH, 9
		MOV BH, 0	
					;move the ascii of the character to al before calling the function
					;move the number of printing times to  cx
		mov BL, 00fh
		INT 10H
		RET
		
printchar endp

;-----------------------------------------------------
printstr	proc 
		
		MOV AH, 9
		INT 21H		;MOV DX, OFFSET MESSEGE BEFORE CALLING
		RET
		
printstr	endp 
;----------------------------------------------------

movcrsr proc 
		
		MOV AH, 2
		MOV BH, 00
		INT 10H		;MOV DX, yx BEFORE CALLING
		RET
		
movcrsr endp

;-----------------------------------------------------
;page1 which contains messages to prompt user to enter his name

PAGE1	PROC 
		
		MOV DX, 0A19H
		CALL movcrsr              ;moving cursor to the middle of the page
		
		MOV DX, OFFSET mess1
		CALL printstr            ;diplaying messege1
		
		
		MOV DX, 0B19H
		CALL movcrsr            ;moving cursor to the middle of the page
		
		MOV DX, OFFSET mess2
		CALL printstr             ;diplaying messege2
		
		
noname:	MOV DX, 0C19H
		CALL movcrsr		;moving cursor
		
		
		MOV DX, OFFSET USNAME  
		MOV AH, 0AH           ;reading username
		INT 21H   
		
		mov cl, LenUSNAME
		cmp cl, 0
		jne fi	
		jmp noname
		
fi:		MOV DX, 0D19H
		CALL movcrsr           ;movig cursor to the middle of the page
		
		MOV DX, OFFSET mess3
		CALL printstr            ;displaying messege3
		
LOP:	MOV AH, 0
		INT 16H  
		CMP AH, 1CH
		JNE LOP         ;waiting for enter
		
		
		ret
PAGE1	ENDP

;-------------------------------------
;which contains all options of game (start play,start chat,end program)
PAGE2	PROC 

          ;to clean pervious graphics mode 
          mov ah,0
		  mov al,13h
          int 10h
          ;new text mode
          mov ah,0
		  mov al,03h
          int 10h
		MOV DX, 071AH
		CALL movcrsr          ;moving cursor
		
		MOV DX, OFFSET chmes
		CALL printstr           ;Printing chat mode messege
	
		MOV DX, 091AH       ;moving cursor
		CALL movcrsr 
		
		MOV DX, OFFSET plmes
		CALL printstr          ;printing playing mode messege
		
		MOV DX, 0B1AH         ;moving cursor
		CALL movcrsr
		
		MOV DX, OFFSET exmes
		CALL printstr          ;printing exiting messege                 
		        
		
		MOV DX, 1500H         ;moving cursor
		CALL movcrsr  
	
        MOV AL, 2DH
        MOV CX, 50H  
		call printchar  ;printing dashes	

check:  mov ah, 0
		int 16h			;READING KEY PRESSED
		
		
		CMP AH, 3BH		;if F1
		JNE TXT	
		CALL ChatPage
		
						;playing code
						
						
txt:    CMP AH, 3CH		;if f2
		JNE EXIT
		call GameCycle
						;chatting code
		
EXIT:	CMP AH, 1
		JNE CHECK
						
		mov ah,4ch
		int 21h
		
PAGE2	ENDP  

;------------------------------ 
;This is chat page procedure
ChatPage proc

call cleanPage
;move curser to start of screen
mov dx,0
call movcrsr

;print player1
mov di,offset P1Name
mov ch,0
mov cl,LenUSNAME
mov ah,2
WriteN1:
mov dl,[di]
int 21h
inc di
dec cx
jnz WriteN1


;print colon
mov ah,2
mov dl,58  ;colon
int 21h


;mov curser to middle of screen
mov ah,2
mov bh,0
mov dh,12
mov dl,0
int 10h
;display dash horizontally to split page
mov ah,2
mov dl,95     ;Dash
mov cx,0
dashSplit:
int 21h
inc cx
cmp cx,80
jnz dashSplit

;player 2 name
mov dx,offset NamePlayer2
mov ah,9
int 21h
;print colon
mov ah,2
mov dl,58  ;colon
int 21h

;mov curser to nearly end of screen
mov ah,2
mov bh,0
mov dh,23
mov dl,0
int 10h
;display dash horizontally to split page
mov ah,2
mov dl,95     ;Dash
mov cx,0
dashSplit2:
int 21h
inc cx
cmp cx,80
jnz dashSplit2

mov dx,offset outOfChat
mov ah,9
int 21h
mov dx,offset NamePlayer2
mov ah,9
int 21h

;move curser to start of screen
mov ah,2
mov bh,0
mov dh,0
mov dl,LenUSNAME
add dl,2
int 10h

checkOFEnd:  
        mov ah,0
		int 16h			;READING KEY PRESSED
		CMP AH, 3DH		;if F3
		jz Endthischat
		mov ah,2
		mov dl,al
		int 21h
		jmp checkOFEnd
		
		Endthischat:
		call cleanPage
        call PAGE2
ret
ChatPage endp

;------------------------------------------
;function to write score of each player at game end and result with Game Over image
ScoreEnd proc

;new graphics page
mov ah,0
mov al,13h
int 10h

    CALL OpenFile
    CALL ReadData
	
    LEA BX , FileData ; BL contains index at the current drawn pixel
	
    MOV CX,50
    MOV DX,0
    MOV AH,0ch
	
; Drawing loop
drawLoop:
    MOV AL,[BX]
    INT 10h 
    INC CX
    INC BX
    CMP CX,GoverWidth+50
JNE drawLoop 
	
    MOV CX ,50
    INC DX
    CMP DX , GoverHeight
JNE drawLoop



MOV AX, @DATA
MOV ES, AX

;compare lifes
mov bl,p1Lifes
mov bh,p2Lifes
cmp bl,bh
ja p1win
jb p2win

;if lifes are equal, compare bombs
mov bl,p1Bombs
mov bh,p2Bombs
cmp bl,bh
ja p1win
jb p2win
;if bombs are equal too, then it's DRAW 
     MOV BP, OFFSET drwstr ; ES: BP POINTS TO THE TEXT
     MOV AH, 13H ; WRITE THE STRING
     MOV AL, 01H; ATTRIBUTE IN BL, MOVE CURSOR TO THAT POSITION
     XOR BH,BH ; VIDEO PAGE = 0
     MOV BL, 3h ;GREEN
     MOV Cl, drwlen ; LENGTH OF THE STRING
     mov ch,0
     MOV DH,12 ;ROW TO PLACE STRING
     MOV DL, 18 ; COLUMN TO PLACE STRING
     INT 10H
     jmp showsc

p1win:
     ;print player1 name then WIN message
     MOV BP, OFFSET P1Name ; ES: BP POINTS TO THE TEXT
     MOV AH, 13H ; WRITE THE STRING
     MOV AL, 01H; ATTRIBUTE IN BL, MOVE CURSOR TO THAT POSITION
     XOR BH,BH ; VIDEO PAGE = 0
     MOV BL, 09h ;GREEN
     MOV Cl, LenUSNAME ; LENGTH OF THE STRING
     mov ch,0
     MOV DH,12 ;ROW TO PLACE STRING
     MOV DL,14 ; COLUMN TO PLACE STRING
     INT 10H
     
     MOV BP, OFFSET winstr ; ES: BP POINTS TO THE TEXT
     MOV Cl, winlen ; LENGTH OF THE STRING
     add dl,LenUSNAME
     inc dl
     INT 10H
     jmp showsc 
p2win:
     ;print player2 name then WIN message
     MOV BP, OFFSET NamePlayer2 ; ES: BP POINTS TO THE TEXT
     MOV AH, 13H ; WRITE THE STRING
     MOV AL, 01H; ATTRIBUTE IN BL, MOVE CURSOR TO THAT POSITION
     XOR BH,BH ; VIDEO PAGE = 0
     MOV BL, 04h ;GREEN
     MOV Cl, lenp2 ; LENGTH OF THE STRING
     mov ch,0
     MOV DH,12 ;ROW TO PLACE STRING
     MOV DL,14 ; COLUMN TO PLACE STRING
     INT 10H
     
     MOV BP, OFFSET winstr ; ES: BP POINTS TO THE TEXT
     MOV Cl, winlen ; LENGTH OF THE STRING
     add dl,lenp2
     inc dl
     INT 10H
     jmp showsc 
         
showsc:
     ;show score whatever result is
     ;p1 life socre
     MOV BP, OFFSET lifsc ; ES: BP POINTS TO THE TEXT
     MOV AH, 13H ; WRITE THE STRING
     MOV AL, 01H; ATTRIBUTE IN BL, MOVE CURSOR TO THAT POSITION
     XOR BH,BH ; VIDEO PAGE = 0
     MOV BL, 09h ;GREEN
     MOV Cl, lifsclen ; LENGTH OF THE STRING
     mov ch,0
     MOV DH,15 ;ROW TO PLACE STRING
     MOV DL,2 ; COLUMN TO PLACE STRING
     INT 10H
     push ax
     push cx
     push dx
     mov ax,0
	 mov cl,10
     mov al,p1Lifes
     div cl	 
	 
	 mov cl,al
	 mov ch,ah
	 
     mov ah,2
     mov dl,cl
     add dl,30h
     int 21h
     
	 mov ah,2
     mov dl,ch
     add dl,30h
     int 21h
     pop dx
     pop cx
     pop ax
     
     
     ;p1 bombs score
     inc dh
     MOV BP, OFFSET bombsc ; ES: BP POINTS TO THE TEXT
     MOV Cl, bombsclen ; LENGTH OF THE STRING
     INT 10H
     push ax
     push cx
     push dx
     mov ax,0
	 mov cl,10
     mov al,p1Bombs
     div cl	 
	 
	 mov cl,al
	 mov ch,ah
	 
     mov ah,2
     mov dl,cl
     add dl,30h
     int 21h
     
	 mov ah,2
     mov dl,ch
     add dl,30h
     int 21h
     pop dx
     pop cx
     pop ax
     
     ;p2 lifes score
     mov bl,4
     mov dh,15
     mov dl,25
     MOV BP, OFFSET lifsc ; ES: BP POINTS TO THE TEXT
     MOV Cl, lifsclen ; LENGTH OF THE STRING
     INT 10H
     push ax
     push cx
     push dx
     mov ax,0
	 mov cl,10
     mov al,p2Lifes
     div cl	 
	 
	 mov cl,al
	 mov ch,ah
	 
     mov ah,2
     mov dl,cl
     add dl,30h
     int 21h
     
	 mov ah,2
     mov dl,ch
     add dl,30h
     int 21h
     pop dx
     pop cx
     pop ax
     
     ;p2 bombs score
     inc dh
     MOV BP, OFFSET bombsc ; ES: BP POINTS TO THE TEXT
     MOV Cl, bombsclen ; LENGTH OF THE STRING
     INT 10H
     push ax
     push cx
     push dx
     mov ax,0
	 mov cl,10
     mov al,p2Bombs
     div cl	 
	 
	 mov cl,al
	 mov ch,ah
	 
     mov ah,2
     mov dl,cl
     add dl,30h
     int 21h
     
	 mov ah,2
     mov dl,ch
     add dl,30h
     int 21h
     pop dx
     pop cx
     pop ax

mov cx,8
delay5s:
call Delay1s
loop delay5s

;after finishing delay, close image file then go to page2 
call CloseFile 
call PAGE2 
ret
ScoreEnd endp

Delay1s PROC ; DELAY 1 SECOND 
  ; start delay
    push cx
    mov bx,15 ;15=1M/max of dx(ffffh)
    mov cx,0
    mov AL, 0
    MOV DX,0ffffh
    MOV AH, 86H
    dodo:
    INT 15H
    dec bx
    jnz dodo
    ;delay rest of 1M/max of dx(ffffh)
    mov cx,0
    mov AL, 0
    MOV DX,19675
    MOV AH, 86H
    INT 15H
    pop cx
    RET            
Delay1s ENDP


OpenFile PROC 

    ; Open file

    MOV AH, 3Dh
    MOV AL, 0 ; read only
    LEA DX, GoverFile
    INT 21h
    MOV [GoverHandle], AX
    
    RET

OpenFile ENDP

ReadData PROC

    MOV AH,3Fh
    MOV BX, [GoverHandle]
    MOV CX,GoverWidth*GoverHeight ; number of bytes to read
    LEA DX, FileData
    INT 21h
    RET
ReadData ENDP 


CloseFile PROC
	MOV AH, 3Eh
	MOV BX, [GoverHandle]

	INT 21h
	RET
CloseFile ENDP


end