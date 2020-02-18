        public GameCycle
        EXTRN drawBonus1:FAR
        EXTRN drawBonus2:FAR
		EXTRN drawBonus3:FAR
        EXTRN DrawPlayer1:near
        EXTRN DrawPlayer2:near
        EXTRN DrawWalls:FAR
        EXTRN keyPressed:FAR
        EXTRN WelcomeStart:FAR
        EXTRN CheckBonus:FAR
		EXTRN StartTime:FAR
		EXTRN InGameChat:FAR
        EXTRN CheckBombs:near
		
		EXTRN p1bombs:BYTE
        EXTRN p1lifes:BYTE
        EXTRN p2lifes:BYTE
        EXTRN p2bombs:BYTE

        EXTRN arrbonus3:WORD
        EXTRN arrbonus2:WORD
        EXTRN arrbonus1:WORD
        EXTRN numbonus:WORD
		EXTRN player1X:WORD
		EXTRN player1y:WORD
		EXTRN player2x:WORD
		EXTRN player2y:WORD
        extrn DrawLogo:far
		
                   .MODEL compact                  
;------------------------------------------------------
                    .STACK         
;------------------------------------------------------                    
                    .DATA
;--------------------------------------------------------
                    .CODE                                                 
MAIN                PROC FAR
                    MOV AX,@DATA
                    MOV DS,AX
                    
					call WelcomeStart
                    call GameCycle

MAIN                ENDP

;this function contains all game cycle and operations with logics
GameCycle proc

                    call DrawLogo  ;first call draw logo function
					call initProg  ;then initialize the screen and scores of each player and positions
					;draw all objects in game
					CALL DrawWalls
                    CALL DrawPlayer1
                    CALL DrawPlayer2 
					;timer for bonus generation time
					CALL StartTime
					;draw chat box in game
                    CALL InGameChat
                
				;all following checks are about any taken action in game
				check:
					CALL CheckBonus
                    CALL CheckBombs
                    mov ah,1
                    int 16h
                    jZ check
                    CALL keyPressed
                    JMP check


ret
GameCycle endp

;initialize game with new clear screen and scores of each player and positions
initProg proc
                    ;scroll last text mode page
                    mov ax,0600h
                    mov bh,07h
                    mov cx,0
                    mov dx,184FH
                    int 10h
                    ;new graphics mode 
                    mov ah,0
                    mov al,13h
                    int 10h
                    ;initializing all scores
                    mov p1lifes,4
                    mov p2lifes,4
                    mov p1bombs,8
                    mov p2bombs,8
                    ;positions of players in game starting
                    mov player1X, 0
                    mov player1Y, 0
                    mov player2X, 300
                    mov player2Y, 120
                    
					;initializing bonus array with default values to start generation from scratch
                    mov arrbonus3[0], 0
                    mov arrbonus3[2],-1
                    mov arrbonus3[4],-1

                    mov arrbonus2[0], 0
                    mov arrbonus2[2],-1
                    mov arrbonus2[4],-1

                    mov arrbonus1[0], 0
                    mov arrbonus1[2],-1
                    mov arrbonus1[4],-1
                    ;counter of bonus appeared
                    mov numbonus, 0


ret
initProg endp

                    END MAIN