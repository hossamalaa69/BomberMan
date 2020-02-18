
PUBLIC drawBonus1, drawBonus2,drawBonus3, DrawPlayer1, DrawPlayer2, DrawWalls, drawBomb1, drawBomb2,lenp2
PUBLIC keyPressed, ClearBlock,InGameChat,drawp2sc,drawp2sc2,drawp1sc2,drawp1sc,NamePlayer2, CheckBonus, StartTime 
PUBLIC p1Lifes,p1Bombs,p2Lifes,p2Bombs, CheckBombs, player1x, player1y, player2x, player2y, arrbonus3, arrbonus2, arrbonus1, numbonus
 
extrn P1Name:Byte
extrn LenUSNAME:Byte
extrn PAGE2:near
extrn ScoreEnd:near


.model compact
.stack 64
.data
canMove db 1 
checkDir db ? ; 0 check up , 1 check down , 2 check left ,3 check right 
SIXTY     db   60
WINDOWWIDTH    EQU       320
WINDOWHEIGHT   EQU       140
;coordinates of bonus and bombs

;bomb of the first player
Bomb1Drawn          db             0     ;a boolean variable to check if the bomb is drawn or not
Bomb1X              dw             100
Bomb1Y              dw             0
bomb1ExplosionTime  db             ?

;bomb of the second player
Bomb2Drawn          db             0
Bomb2X              dw             200
Bomb2Y              dw             0
bomb2ExplosionTime  db             ?

EXPLOSIONTIME       EQU            2

explosionX          dw             ?
explosionY          dw             ?

;to clear the explosion places
explodedUp          db             ?    ;boolean 0:no, 1:yes
explodedDown        db             ?
explodedRight       db             ?
explodedLeft        db             ?

xBonus dw ?
yBonus dw ?
index dw 6
curbonus dw ?
numbonus  dw 0
arrbonus1 dw 0, -1, -1
arrbonus2 dw 0, -1, -1
arrbonus3 dw 0, -1, -1

;movement helpers
NoWAll db 1
NoMan  db 1
xMovingMan dw ?
yMovingMan dw ?
xStandMan dw ?
yStandMan dw ?
KeyScancode db ?
keyAscii   db ?
playerMoved db ?
gotBonus db ?    
tokenBonusType dw ?
playerGotBonus db ?

isBomb       db ?


;colors
RED                 EQU         04h
WHITE               EQU         0Fh
BLACK               EQU         00h
BROWN               EQU         06h
BGC                 EQU         BLACK
BLUE                EQU         01h
OBJECT_SIZE         EQU         20

ObjectSize          db          20    ;size of any object
;player1 coordinates (variables)
Player1X            dw          0
Player1Y            dw          0
ClearX              dw          0
ClearY              dw          0
;player2 coordinates (variables)
Player2X            dw          300
Player2Y            dw          120

;array of coordinates for walls(const)
WallsX              dw          80, 200, 40, 0, 240
                    dw          20, 60, 100, 140,180,220, 260, 280
                    dw          20, 60, 100, 140,180,220, 260
                    dw          160
                    dw          20, 60, 100, 140,180,220, 260, 280

WallsY              dw          0, 120, 80, 120, 0
                    dw          20, 20, 20, 20, 20, 20, 20, 40
                    dw          60, 60, 60, 60, 60, 60, 60
                    dw          80
                    dw          100, 100, 100, 100, 100, 100, 100, 80

WallsNo             EQU         29   ;number of walls in game
;--------------------------------------------------------------------

LASTBONUS db ?
NEXTBONUS db ?

BONUSX	  dW 0, 0, 0, 0, 0, 0
		  dw 20, 20, 20, 20
		  dw 40, 40, 40, 40, 40, 40
		  dW 60, 60, 60, 60
		  dW 80, 80, 80, 80, 80, 80
		  dW 100, 100, 100, 100
		  dw 120, 120, 120, 120, 120, 120, 120
		  dW 140, 140, 140, 140
		  dw 160, 160, 160, 160, 160, 160
		  dW 180, 180, 180, 180
		  dw 200, 200, 200, 200, 200, 200
		  dW 220, 220, 220, 220
		  dw 240, 240, 240, 240, 240, 240
		  dW 260, 260, 260, 260
		  dw 280, 280, 280, 280, 280
		  dW 300, 300, 300, 300, 300, 300, 300
		  
BONUSY	  dW 0, 20, 40, 60, 80, 100
		  dW 0, 40, 80, 120
		  dW 0, 20, 40, 60, 100, 120
		  dW 0, 40, 80, 120
		  dW  20, 40, 60, 80, 100, 120
		  dW 0, 40, 80, 120
		  dW 0, 20, 40, 60, 80, 100, 120
		  dW 0, 40, 80, 120
		  dW 0, 20, 40, 60, 100, 120
		  dW 0, 40, 80, 120
		  dW 0, 20, 40, 60, 80, 100
		  dW 0, 40, 80, 120
		  dW 20, 40, 60, 80, 100, 120
		  dW 0, 40, 80, 120
		  dW 0, 20, 60, 100, 120
		  dW 0, 20, 40, 60, 80, 100, 120
		  ;88 location (0,87)
		  
;--------------------------------------------------------------------

;colors of 20*20 bomb
bombColors          db 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h
                    db 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h
                    db 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h
                    db 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h
                    db 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h
                    db 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 95h, 4eh, 00h, 4eh, 00h, 00h, 00h, 00h, 00h, 00h
                    db 00h, 00h, 00h, 00h, 00h, 00h, 0dfh, 0dfh, 0dfh, 00h, 1eh, 00h, 4eh, 00h, 00h, 00h, 00h, 00h, 00h, 00h
                    db 00h, 00h, 00h, 00h, 00h, 00h, 95h, 95h, 95h, 00h, 1eh, 00h, 00h, 95h, 00h, 00h, 00h, 00h, 00h, 00h
                    db 00h, 00h, 00h, 00h, 00h, 7ch, 4eh, 4eh, 7ch, 00h, 4eh, 4eh, 95h, 95h, 00h, 00h, 00h, 00h, 00h, 00h
                    db 00h, 00h, 00h, 00h, 00h, 7ch, 4eh, 4eh, 7ch, 95h, 00h, 95h, 95h, 00h, 00h, 00h, 00h, 00h, 00h, 00h
                    db 00h, 00h, 00h, 00h, 00h, 7ch, 7ch, 7ch, 7ch, 95h, 95h, 00h, 00h, 00h, 0dfh, 00h, 00h, 00h, 00h, 00h
                    db 00h, 00h, 00h, 00h, 00h, 95h, 95h, 95h, 95h, 95h, 95h, 0dfh, 0dfh, 0dfh, 0dfh, 00h, 00h, 00h, 00h, 00h
                    db 00h, 00h, 00h, 00h, 00h, 00h, 95h, 95h, 95h, 95h, 0dfh, 0dfh, 0dfh, 0dfh, 00h, 00h, 00h, 00h, 00h, 00h
                    db 00h, 00h, 00h, 00h, 00h, 00h, 0dfh, 0dfh, 0dfh, 0dfh, 0dfh, 0dfh, 0dfh, 0dfh, 00h, 00h, 00h, 00h, 00h, 00h
                    db 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 0dfh, 0dfh, 0dfh, 0dfh, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h
                    db 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h
                    db 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h
                    db 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h
                    db 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h
                    db 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h

bonus1Colors		db 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h
			db 00h, 29h, 29h, 29h, 29h, 29h, 29h, 29h, 29h, 29h, 29h, 29h, 29h, 29h, 29h, 29h, 29h, 29h, 29h, 00h
			db 00h, 29h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 29h, 00h
			db 00h, 29h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 29h, 00h
			db 00h, 29h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 29h, 00h
			db 00h, 29h, 02h, 02h, 02h, 28h, 28h, 28h, 02h, 02h, 02h, 02h, 28h, 28h, 28h, 02h, 02h, 02h, 29h, 00h
			db 00h, 29h, 02h, 02h, 28h, 0fh, 0fh, 28h, 28h, 02h, 02h, 28h, 28h, 28h, 28h, 28h, 02h, 02h, 29h, 00h
			db 00h, 29h, 02h, 02h, 28h, 0fh, 28h, 28h, 28h, 28h, 28h, 28h, 28h, 28h, 28h, 28h, 02h, 02h, 29h, 00h
			db 00h, 29h, 02h, 02h, 28h, 28h, 28h, 28h, 28h, 28h, 28h, 28h, 28h, 28h, 28h, 28h, 02h, 02h, 29h, 00h
			db 00h, 29h, 02h, 02h, 28h, 28h, 28h, 28h, 28h, 28h, 28h, 28h, 28h, 28h, 28h, 28h, 02h, 02h, 29h, 00h
			db 00h, 29h, 02h, 02h, 02h, 28h, 28h, 28h, 28h, 28h, 28h, 28h, 28h, 28h, 28h, 02h, 02h, 02h, 29h, 00h
			db 00h, 29h, 02h, 02h, 02h, 02h, 28h, 28h, 28h, 28h, 28h, 28h, 28h, 28h, 02h, 02h, 02h, 02h, 29h, 00h
			db 00h, 29h, 02h, 02h, 02h, 02h, 02h, 28h, 28h, 28h, 28h, 28h, 28h, 02h, 02h, 02h, 02h, 02h, 29h, 00h
			db 00h, 29h, 02h, 02h, 02h, 02h, 02h, 02h, 28h, 28h, 28h, 28h, 02h, 02h, 02h, 02h, 02h, 02h, 29h, 00h
			db 00h, 29h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 28h, 28h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 29h, 00h
			db 00h, 29h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 29h, 00h
			db 00h, 29h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 29h, 00h
			db 00h, 29h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 29h, 00h
			db 00h, 29h, 29h, 29h, 29h, 29h, 29h, 29h, 29h, 29h, 29h, 29h, 29h, 29h, 29h, 29h, 29h, 29h, 29h, 00h
			db 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h

bonus2Colors		db 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h 
			db 00h, 29h, 29h, 29h, 29h, 29h, 29h, 29h, 29h, 29h, 29h, 29h, 29h, 29h, 29h, 29h, 29h, 29h, 29h, 00h
			db 00h, 29h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 29h, 00h 
			db 00h, 29h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 29h, 00h 
			db 00h, 29h, 02h, 02h, 02h, 02h, 02h, 02h, 00h, 00h, 00h, 00h, 02h, 00h, 00h, 02h, 02h, 02h, 29h, 00h 
			db 00h, 29h, 02h, 02h, 02h, 02h, 00h, 00h, 00h, 00h, 95h, 4eh, 00h, 4eh, 00h, 02h, 02h, 02h, 29h, 00h 
			db 00h, 29h, 02h, 02h, 02h, 00h, 0dfh, 0dfh, 0dfh, 00h, 1eh, 00h, 4eh, 00h, 00h, 02h, 02h, 02h,29h,00h 
			db 00h, 29h, 02h, 02h, 02h, 00h, 95h, 95h, 95h, 00h, 1eh, 00h, 00h, 95h, 00h, 02h, 02h, 02h, 29h, 00h 
			db 00h, 29h, 02h, 02h, 00h, 7ch, 4eh, 4eh, 7ch, 00h, 4eh, 4eh, 95h, 95h, 00h, 00h, 02h, 02h, 29h, 00h 
			db 00h, 29h, 02h, 02h, 00h, 7ch, 4eh, 4eh, 7ch, 95h, 00h, 95h, 95h, 00h, 00h, 00h, 02h, 02h, 29h, 00h 
			db 00h, 29h, 02h, 02h, 00h, 7ch, 7ch, 7ch, 7ch, 95h, 95h, 00h, 00h, 00h, 0dfh, 00h, 02h, 02h, 29h, 00h
			db 00h, 29h, 02h, 02h, 00h, 95h, 95h, 95h, 95h, 95h, 95h, 0dfh, 0dfh, 0dfh, 0dfh, 00h, 02h, 02h, 29h, 00h 
			db 00h, 29h, 02h, 02h, 02h, 00h, 95h, 95h, 95h, 95h, 0dfh, 0dfh, 0dfh, 0dfh, 00h, 02h, 02h, 02h, 29h, 00h 
			db 00h, 29h, 02h, 02h, 02h, 00h, 0dfh, 0dfh, 0dfh, 0dfh, 0dfh, 0dfh, 0dfh, 0dfh, 00h, 02h, 02h, 02h, 29h, 00h
			db 00h, 29h, 02h, 02h, 02h, 02h, 00h, 00h, 0dfh, 0dfh, 0dfh, 0dfh, 00h, 00h, 02h, 02h,02h,02h,29h,00h
			db 00h, 29h, 02h, 02h, 02h, 02h, 02h, 02h, 00h, 00h, 00h, 00h, 02h, 02h, 02h, 02h, 02h, 02h, 29h, 00h
			db 00h, 29h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 29h, 00h
			db 00h, 29h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 29h, 00h
			db 00h, 29h, 29h, 29h, 29h, 29h, 29h, 29h, 29h, 29h, 29h, 29h, 29h, 29h, 29h, 29h, 29h, 29h, 29h, 00h
			db 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h 

bonus3		db 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h
			db 00h, 29h, 29h, 29h, 29h, 29h, 29h, 29h, 29h, 29h, 29h, 29h, 29h, 29h, 29h, 29h, 29h, 29h, 29h, 00h
			db 00h, 29h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 29h, 00h
			db 00h, 29h, 02h, 02h, 02h, 02h, 02h, 02h, 00h, 00h, 00h, 00h, 02h, 02h, 02h, 02h, 02h, 02h, 29h, 00h
			db 00h, 29h, 02h, 02h, 02h, 02h, 00h, 00h, 0fh, 0fh, 0fh, 0fh, 00h, 00h, 02h, 02h, 02h, 02h, 29h, 00h
			db 00h, 29h, 02h, 02h, 02h, 00h, 4eh, 0fh, 0fh, 0fh, 0fh, 0fh, 0fh, 4eh, 00h, 02h, 02h, 02h, 29h, 00h
			db 00h, 29h, 02h, 02h, 00h, 4eh, 0fh, 0fh, 0fh, 0fh, 0fh, 0fh, 0fh, 0fh, 4eh, 00h, 02h, 02h, 29h, 00h
			db 00h, 29h, 02h, 02h, 00h, 4eh, 00h, 00h, 0fh, 0fh, 0fh, 0fh, 00h, 00h, 4eh, 00h, 02h, 02h, 29h, 00h
			db 00h, 29h, 02h, 00h, 4eh, 00h, 28h, 00h, 00h, 0fh, 0fh, 00h, 28h, 00h, 00h, 4eh, 00h, 02h, 29h, 00h
			db 00h, 29h, 02h, 00h, 4eh, 00h, 11h, 00h, 00h, 0fh, 0fh, 00h, 00h, 00h, 00h, 4eh, 00h, 02h, 29h, 00h
			db 00h, 29h, 02h, 00h, 4eh, 00h, 00h, 00h, 19h, 4eh, 4eh, 07h, 00h, 00h, 00h, 4eh, 00h, 02h, 29h, 00h
			db 00h, 29h, 02h, 00h, 4eh, 0fh, 0fh, 0fh, 0fh, 00h, 00h, 0fh, 0fh, 0fh, 0fh, 4eh, 00h, 02h, 29h, 00h
			db 00h, 29h, 02h, 02h, 00h, 00h, 0fh, 0fh, 4eh, 00h, 00h, 4eh, 0fh, 0fh, 00h, 00h, 02h, 02h, 29h, 00h
			db 00h, 29h, 02h, 02h, 02h, 00h, 0fh, 0fh, 0fh, 0fh, 0fh, 0fh, 0fh, 0fh, 00h, 02h, 02h, 02h, 29h, 00h
			db 00h, 29h, 02h, 02h, 02h, 00h, 0fh, 00h, 0fh, 00h, 00h, 0fh, 00h, 0fh, 00h, 02h, 02h, 02h, 29h, 00h
			db 00h, 29h, 02h, 02h, 02h, 00h, 4eh, 00h, 4eh, 00h, 00h, 4eh, 00h, 4eh, 00h, 02h, 02h, 02h, 29h, 00h
			db 00h, 29h, 02h, 02h, 02h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 02h, 02h, 02h, 29h, 00h
			db 00h, 29h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 02h, 29h, 00h
			db 00h, 29h, 29h, 29h, 29h, 29h, 29h, 29h, 29h, 29h, 29h, 29h, 29h, 29h, 29h, 29h, 29h, 29h, 29h, 00h
			db 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h   

explosion           db  2ah, 2ah, 2bh, 2bh, 2bh, 2bh, 2bh, 43h, 43h, 2bh, 2bh, 2bh, 2bh, 2bh, 2bh, 2bh, 2bh, 2bh, 2ah, 2ah
                    db  2ah, 2bh, 2bh, 2bh, 2bh, 2bh, 2bh, 2bh, 43h, 43h, 43h, 43h, 43h, 2bh, 2bh, 2ah, 2ah, 2bh, 43h, 2ah
                    db  2bh, 2bh, 2bh, 2bh, 2bh, 2bh, 2bh, 2bh, 43h, 43h, 43h, 43h, 43h, 2bh, 2bh, 2bh, 2bh, 2bh, 43h, 2bh
                    db  2bh, 43h, 42h, 43h, 43h, 43h, 43h, 43h, 43h, 43h, 43h, 43h, 2bh, 2bh, 43h, 43h, 43h, 43h, 5bh, 2bh
                    db  2bh, 42h, 43h, 43h, 43h, 43h, 43h, 5bh, 5bh, 5bh, 5bh, 2bh, 43h, 43h, 43h, 5bh, 0fh, 0fh, 5bh, 43h
                    db  2bh, 43h, 43h, 5bh, 5bh, 5bh, 0fh, 0fh, 43h, 5bh, 43h, 43h, 43h, 5bh, 5bh, 5bh, 0fh, 5bh, 5bh, 43h
                    db  2bh, 2bh, 2bh, 43h, 43h, 5bh, 0fh, 5bh, 0fh, 0fh, 5bh, 5bh, 43h, 0fh, 0fh, 43h, 43h, 43h, 43h, 2bh
                    db  43h, 5bh, 2bh, 2bh, 43h, 43h, 43h, 5bh, 0fh, 0fh, 0fh, 43h, 5bh, 5bh, 5bh, 43h, 43h, 2bh, 2bh, 43h
                    db  43h, 5bh, 43h, 2bh, 2bh, 43h, 43h, 5bh, 5bh, 5bh, 0fh, 5bh, 43h, 43h, 5bh, 43h, 2bh, 2bh, 2bh, 43h
                    db  43h, 5bh, 2bh, 2bh, 43h, 43h, 5bh, 0fh, 0fh, 0fh, 5bh, 43h, 0fh, 0fh, 43h, 43h, 43h, 2bh, 2bh, 43h
                    db  2bh, 2bh, 2bh, 2bh, 43h, 5bh, 0fh, 0fh, 5bh, 0fh, 0fh, 0fh, 0fh, 0fh, 43h, 43h, 43h, 2bh, 2bh, 2bh
                    db  2bh, 2bh, 2bh, 2bh, 43h, 5bh, 0fh, 0fh, 5bh, 5bh, 0fh, 0fh, 5bh, 0fh, 43h, 43h, 2bh, 2bh, 43h, 2bh
                    db  43h, 5bh, 2bh, 2bh, 43h, 5bh, 0fh, 0fh, 0fh, 5bh, 5bh, 5bh, 5bh, 5bh, 5bh, 43h, 2bh, 43h, 5bh, 43h
                    db  2bh, 2bh, 2bh, 2bh, 43h, 0fh, 0fh, 0fh, 0fh, 0fh, 5bh, 43h, 43h, 43h, 43h, 5bh, 5bh, 43h, 43h, 2bh
                    db  2bh, 2bh, 43h, 5bh, 43h, 5bh, 0fh, 0fh, 5bh, 0fh, 5bh, 43h, 2bh, 2bh, 43h, 5bh, 43h, 43h, 2bh, 2bh
                    db  2bh, 43h, 43h, 5bh, 5bh, 43h, 5bh, 0fh, 43h, 43h, 5bh, 5bh, 43h, 43h, 5bh, 5bh, 43h, 2bh, 2bh, 2bh
                    db  2bh, 43h, 2bh, 43h, 5bh, 43h, 43h, 43h, 43h, 43h, 43h, 43h, 43h, 5bh, 0fh, 0fh, 43h, 43h, 2bh, 2bh
                    db  2bh, 2bh, 2bh, 2bh, 2bh, 2bh, 2bh, 43h, 5bh, 43h, 43h, 2bh, 43h, 5bh, 5bh, 43h, 43h, 2bh, 2bh, 2bh
                    db  2ah, 2bh, 2bh, 2bh, 2bh, 2bh, 2bh, 43h, 43h, 43h, 2bh, 2bh, 2bh, 43h, 43h, 2bh, 2bh, 2bh, 2bh, 2ah
                    db  2ah, 2ah, 2bh, 2bh, 2bh, 2bh, 2bh, 43h, 43h, 2bh, 2bh, 2bh, 2bh, 2bh, 2bh, 2bh, 2bh, 2bh, 2ah, 2ah


;player1 colors
Player1             db       BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC
                    db       BGC, BGC, BGC, BLACK, BLACK, BLACK, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC
                    db       BGC, BGC, BLACK, RED, RED, RED, BLACK, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC
                    db       BGC, BLACK, RED, RED, RED, RED, RED, BLACK, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC
                    db       BGC, BLACK, RED, RED, BLACK, BLACK, RED, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BGC, BGC, BGC, BGC, BGC
                    db       BGC, BLACK, RED, RED, BLACK, WHITE, BLACK, WHITE, WHITE, WHITE, WHITE, WHITE, WHITE, WHITE, WHITE, BLACK, BGC, BGC, BGC, BGC
                    db       BGC, BGC, BLACK, RED, RED, BLACK, WHITE, WHITE, WHITE, WHITE, WHITE, WHITE, WHITE, WHITE, WHITE, WHITE, BLACK, BGC, BGC, BGC
                    db       BGC, BGC, BGC, BLACK, BLACK, WHITE, WHITE, WHITE, WHITE, WHITE, WHITE, WHITE, WHITE, WHITE, WHITE, WHITE, WHITE, BLACK, BGC, BGC
                    db       BGC, BGC, BGC, BGC, BLACK, WHITE, WHITE, WHITE, BLACK, BLACK, BLACK, WHITE, WHITE, WHITE, BLACK, BLACK, BLACK, WHITE, BLACK, BGC
                    db       BGC, BGC, BGC, BLACK, WHITE, WHITE, WHITE, BLACK, BROWN, BROWN, BROWN, BLACK, BLACK, BLACK, BROWN, BROWN, BROWN, WHITE, BLACK, BGC
                    db       BGC, BGC, BGC, BLACK, WHITE, WHITE, BLACK, BROWN, BROWN, BLACK, BROWN, BROWN, BROWN, BROWN, BROWN, BLACK, BROWN, WHITE, BLACK, BGC
                    db       BGC, BGC, BGC, BLACK, WHITE, WHITE, BLACK, BROWN, BROWN, BLACK, BROWN, BROWN, BROWN, BROWN, BROWN, BLACK, BROWN, WHITE, BLACK, BGC
                    db       BGC, BGC, BGC, BLACK, WHITE, WHITE, BLACK, BROWN, BROWN, BLACK, BROWN, BROWN, BROWN, BROWN, BROWN, BLACK, BROWN, WHITE, BLACK, BGC
                    db       BGC, BGC, BGC, BLACK, WHITE, WHITE, BLACK, BROWN, BROWN, BLACK, BROWN, BROWN, BROWN, BROWN, BROWN, BLACK, BROWN, WHITE, BLACK, BGC
                    db       BGC, BGC, BGC, BGC, BLACK, WHITE, BLACK, BROWN, BROWN, BLACK, BROWN, BROWN, BROWN, BROWN, BROWN, BLACK, BROWN, WHITE, BLACK,BGC
                    db       BGC, BGC, BGC, BGC, BLACK, WHITE, WHITE, BLACK, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, WHITE, BLACK, BGC, BGC
                    db       BGC, BGC, BGC, BGC, BGC, BLACK, WHITE, WHITE, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, WHITE, WHITE, BLACK, BGC, BGC, BGC
                    db       BGC, BGC, BGC, BGC, BGC, BGC, BLACK, BLACK, WHITE, WHITE, WHITE, WHITE, WHITE, WHITE, BLACK, BLACK, BGC, BGC, BGC, BGC
                    db       BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BGC, BGC, BGC, BGC, BGC, BGC
                    db       BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC

;player2 colors
Player2             db      BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC
                    db      BGC, BGC, BGC, BLACK, BLACK, BLACK, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC
                    db      BGC, BGC, BLACK, RED, RED, RED, BLACK, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC
                    db      BGC, BLACK, RED, RED, RED, RED, RED, BLACK, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC
                    db      BGC, BLACK, RED, RED, BLACK, BLACK, RED, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BGC, BGC, BGC, BGC, BGC
                    db      BGC, BLACK, RED, RED, BLACK, BLUE, BLACK, BLUE, BLUE, BLUE, BLUE, BLUE, BLUE, BLUE, BLUE, BLACK, BGC, BGC, BGC, BGC
                    db      BGC, BGC, BLACK, RED, RED, BLACK, BLUE, BLUE, BLUE, BLUE, BLUE, BLUE, BLUE, BLUE, BLUE, BLUE, BLACK, BGC, BGC, BGC
                    db      BGC, BGC, BGC, BLACK, BLACK, BLUE, BLUE, BLUE, BLUE, BLUE, BLUE, BLUE, BLUE, BLUE, BLUE, BLUE, BLUE, BLACK, BGC, BGC
                    db      BGC, BGC, BGC, BGC, BLACK, BLUE, BLUE, BLUE, BLACK, BLACK, BLACK, BLUE, BLUE, BLUE, BLACK, BLACK, BLACK, BLUE, BLACK, BGC
                    db      BGC, BGC, BGC, BLACK, BLUE, BLUE, BLUE, BLACK, BROWN, BROWN, BROWN, BLACK, BLACK, BLACK, BROWN, BROWN, BROWN, BLUE, BLACK, BGC
                    db      BGC, BGC, BGC, BLACK, BLUE, BLUE, BLACK, BROWN, BROWN, BLACK, BROWN, BROWN, BROWN, BROWN, BROWN, BLACK, BROWN, BLUE, BLACK, BGC
                    db      BGC, BGC, BGC, BLACK, BLUE, BLUE, BLACK, BROWN, BROWN, BLACK, BROWN, BROWN, BROWN, BROWN, BROWN, BLACK, BROWN, BLUE, BLACK, BGC
                    db      BGC, BGC, BGC, BLACK, BLUE, BLUE, BLACK, BROWN, BROWN, BLACK, BROWN, BROWN, BROWN, BROWN, BROWN, BLACK, BROWN, BLUE, BLACK, BGC
                    db      BGC, BGC, BGC, BLACK, BLUE, BLUE, BLACK, BROWN, BROWN, BLACK, BROWN, BROWN, BROWN, BROWN, BROWN, BLACK, BROWN, BLUE, BLACK, BGC
                    db      BGC, BGC, BGC, BGC, BLACK, BLUE, BLACK, BROWN, BROWN, BLACK, BROWN, BROWN, BROWN, BROWN, BROWN, BLACK, BROWN, BLUE, BLACK, BGC
                    db      BGC, BGC, BGC, BGC, BLACK, BLUE, BLUE, BLACK, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BLUE, BLACK, BGC, BGC
                    db      BGC, BGC, BGC, BGC, BGC, BLACK, BLUE, BLUE, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BLUE, BLUE, BLACK, BGC, BGC, BGC
                    db      BGC, BGC, BGC, BGC, BGC, BGC, BLACK, BLACK, BLUE, BLUE, BLUE, BLUE, BLUE, BLUE, BLACK, BLACK, BGC, BGC, BGC, BGC
                    db      BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BGC, BGC, BGC, BGC, BGC, BGC
                    db      BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC, BGC

;colors of wall
WALL                db      BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN
                    db      BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN
                    db      BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN
                    db      BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN
                    db      BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN
                    db      BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK
                    db      BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK
                    db      BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BLACK, BLACK, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN
                    db      BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BLACK, BLACK, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN
                    db      BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BLACK, BLACK, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN
                    db      BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BLACK, BLACK, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN
                    db      BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BLACK, BLACK, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN
                    db      BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BLACK, BLACK, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN
                    db      BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK
                    db      BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK, BLACK
                    db      BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BLACK, BLACK, BROWN, BROWN, BROWN, BROWN, BROWN
                    db      BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BLACK, BLACK, BROWN, BROWN, BROWN, BROWN, BROWN
                    db      BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BLACK, BLACK, BROWN, BROWN, BROWN, BROWN, BROWN
                    db      BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BLACK, BLACK, BROWN, BROWN, BROWN, BROWN, BROWN
                    db      BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BROWN, BLACK, BLACK, BROWN, BROWN, BROWN, BROWN, BROWN


;----------------------------------
;2 lines Y-position of score bar(const)
line1score dw 141
line2score dw 155

;player 2 name 
Nameplayer2 db 'Youssef','$'
lenp2 db 7


colonletter db ':'     

;end of game page message
messageEnd1 db 'to end game with'
lenEnd1 equ 16
messageEnd2 db ', Press F4'
lenEnd2 equ 10


;in score bar with small size (const)

heartSmall             db 00h, 00h, 00h, 00h, 00h, 00h, 00h,00h
                       db 00h, 28h, 28h, 00h, 00h, 28h, 28h, 00h
                       db 28h, 0fh, 28h, 28h, 28h, 28h, 28h, 28h
                       db 28h, 28h, 28h, 28h, 28h, 28h, 28h, 28h
                       db 28h, 28h, 28h, 28h, 28h, 28h, 28h, 28h
                       db 00h, 28h, 28h, 28h, 28h, 28h, 28h, 00h
                       db 00h, 00h, 28h, 28h, 28h, 28h, 00h, 00h
                       db 00h, 00h, 00h, 28h, 28h, 00h, 00h, 00h

;in score bar with small size (const)
bombSmall           db 00h, 00h, 00h, 0eh, 2ah, 0eh, 00h, 00h
                    db 00h, 00h, 00h, 00h, 07h, 00h, 00h, 00h
                    db 00h, 00h, 00h, 28h, 28h, 28h, 00h, 00h
                    db 00h, 00h, 28h, 0fh, 28h, 28h, 28h, 00h
                    db 00h, 28h, 28h, 28h, 28h, 28h, 28h, 28h
                    db 00h, 28h, 28h, 28h, 28h, 28h, 28h, 28h
                    db 00h, 00h, 28h, 28h, 28h, 28h, 28h, 00h
                    db 00h, 00h, 00h, 28h, 28h, 28h, 00h, 00h


;coordinates of drawing small life bonus in score bar (const)
lifesX dw ?
lifesY dw 143
                                                             
;coordinates of drawing small bomb in score bar (const)
bombsX dw ?
bombsY dw 143

;store player1 score(variables)
p1Lifes db 4
p1Bombs db 8 

;store player2 score(variables)
p2Lifes db 4
p2Bombs db 8 


.code

; check if the bomb can be drawn or not and draw it

drawBomb1 proc near
               
               ; check if he has bombs or not
               CMP p1Bombs, 0
               JZ tempReturn

               ; if there is a drawn bomb return
               CMP Bomb1Drawn, 1
               JZ tempReturn

               ; check if the place is not in the screen
               CMP Bomb1X, 0
               JL tempReturn
               CMP Bomb1X, 300
               JG tempReturn
               CMP Bomb1Y, 0
               JL tempReturn
               CMP Bomb1Y, 120
               JG tempReturn
               
               mov ax, Bomb1X
               mov cx, Bomb1Y
            ;check if there is bonus   
               mov bx,0
            checkB:
               cmp ax,arrBonus1[bx+2]
               ;check if x is not same check the other
               JNE checkNextBonus
               cmp cx,arrBonus1[bx+4]
               ;check if y is equal and x then return 
               JE  tempReturn               
              checkNextBonus:
               add bx,6
               cmp bx,18
               JNE checkB               
            ; check for any wall
               mov si, -2
               mov ax, Bomb1X
               mov bx, Bomb1Y
          LoopWalls:
               add si, 2
               CMP si, WallsNo*2
               JZ nextCheck
               CMP ax, WallsX[si]
               JNZ LoopWalls
               CMP bx, WallsY[si]
               JZ tempReturn
               JMP LoopWalls
               
               ; check for players
          nextCheck:
               CMP ax, player1x
               JNZ Check3
               CMP bx, player1y
               JZ tempReturn

                    
          Check3:
               CMP ax, player2x
               JNZ Draw5
               CMP bx, Player2Y
               JZ tempReturn
               JMP Draw5

          tempReturn:
               JMP toReturn3

               ; draw the bomb     
          Draw5:
               sub p1Bombs, 1
               CALL drawp1sc2 
               MOV AH, 2CH
		     INT 21H			;CH = HOUR (0, 23)
						;CL = MIN  (0, 59)
						;DH = SEC  (0, 59)	 
						;DL = HUNDREDTH OF SEC (0, 99) 
               mov ah,0
               mov al, dh
               add ax, EXPLOSIONTIME      ;bomb explodes after EXPLOSIONTIME seconds
               DIV SIXTY
               MOV bomb1ExplosionTime, ah  ;take the remainder to handle the case of passing 60   
               mov Bomb1Drawn, 1
               mov di,offset bombColors    
               mov cx, Bomb1X
               mov dx, Bomb1Y
               mov bx, OBJECT_SIZE
               nxtline2:
               line2:
               mov al, [di]
               inc di
               mov ah,0ch
               int 10h
               inc cx
               push bx
               mov bx, Bomb1X
               add bx,OBJECT_SIZE
               cmp cx,bx
               pop bx
               jnz line2
               inc dx
               mov cx,Bomb1X
               dec bx
               and bx,bx
               jnz nxtline2
	       ret
          toReturn3:
	   mov dl, 07h
           mov ah, 2
           int 21h    
               ret
drawBomb1 endp

; similar to the above one but for the second player bomb
drawBomb2 proc near

               ; check if he has bombs or not
               CMP p2Bombs, 0
               JZ tempReturn2
               ; if there is a drawn bomb return
               CMP Bomb2Drawn, 1
               JZ tempReturn2
               
                ; check if the place is not in the screen
               CMP Bomb2X, 0
               JL tempReturn2
               CMP Bomb2X, 300
               JG tempReturn2
               CMP Bomb2Y, 0
               JL tempReturn2
               CMP Bomb2Y, 120
               JG tempReturn2
               
               mov ax, Bomb2X
               mov cx, Bomb2Y
            ;check if there is bonus   
               mov bx,0
            checkB2:
               cmp ax,arrBonus1[bx+2]
               ;check if x is not same check the other
               JNE checkNextBonus2
               cmp cx,arrBonus1[bx+4]
               ;check if y is equal and x then return 
               JE  tempReturn2               
              checkNextBonus2:
               add bx,6
               cmp bx,18
               JNE checkB2
           ; check for any wall
               mov si, -2
               mov ax, Bomb2X
               mov bx, Bomb2Y             
          LoopWalls2:
               add si, 2
               CMP si, WallsNo*2
               JZ nextCheck2
               CMP ax, WallsX[si]
               JNZ LoopWalls2
               CMP bx, WallsY[si]
               JZ tempReturn2
               
               JMP LoopWalls2
          
               ; check for players
          nextCheck2:
               CMP ax, player1x
               JNZ Check2
               CMP bx, player1y
               JZ toReturn4
          Check2:
               CMP ax, player2x
               JNZ Draw6
               CMP bx, Player2Y
               JZ tempReturn2
               JMP Draw6

          tempReturn2:
               JMP toReturn4

               ; draw the bomb     
          Draw6:
               sub p2Bombs, 1
               CALL drawp2sc2
               MOV AH, 2CH
		     INT 21H			;CH = HOUR (0, 23)
						;CL = MIN  (0, 59)
						;DH = SEC  (0, 59)	 
						;DL = HUNDREDTH OF SEC (0, 99) 
               mov ah,0
               mov al, dh
               add ax, EXPLOSIONTIME      ;bomb explodes after EXPLOSIONTIME seconds
               DIV SIXTY
               MOV bomb2ExplosionTime, ah  ;take the remainder to handle the case of passing 60      
               mov Bomb2Drawn, 1
               mov di,offset bombColors    
               mov cx, Bomb2X
               mov dx, Bomb2Y
               mov bx, OBJECT_SIZE
               nxtline100:
               line100:
               mov al, [di]
               inc di
               mov ah,0ch
               int 10h
               inc cx
               push bx
               mov bx, Bomb2X
               add bx,OBJECT_SIZE
               cmp cx,bx
               pop bx
               jnz line100
               inc dx
               mov cx,Bomb2X
               dec bx
               and bx,bx
               jnz nxtline100
		ret
          toReturn4:
	       mov dl, 07h
               mov ah, 2
               int 21h  
               ret
drawBomb2 endp


;check if any bomb will explode 
CheckBombs     PROC
               MOV AH, 2CH
		     INT 21H			;CH = HOUR (0, 23)
						;CL = MIN  (0, 59)
						;DH = SEC  (0, 59)	 
						;DL = HUNDREDTH OF SEC (0, 99)
               
               CMP Bomb1Drawn, 0
               JZ CheckBomb2

               CMP DH, bomb1ExplosionTime
               JNZ CheckBomb2
               
               CALL ExplodeBomb1

          CheckBomb2:
               CMP Bomb2Drawn, 0
               JZ EndCheck
               CMP DH, bomb2ExplosionTime
               JNZ EndCheck
               CALL ExplodeBomb2

          EndCheck:
               ret
CheckBombs     ENDP

;--------------------------------------------------
; print a block of explosion at explosionX & explosionY
DrawExplosion       PROC FAR
                    MOV SI, 0

                    mov cx,explosionX ;x
                    mov dx,explosionY ;y
               Draw7:               
                    CMP SI, 0
                    JZ No5
                    MOV AX, SI
                    DIV ObjectSize
                    CMP AH, 0
                    JNZ No5
                    MOV CX, explosionX
                    INC dx
               No5:  
                    mov al,explosion[SI] ;Pixel color
                    mov ah,0ch ;Draw Pixel Command
                    int 10h
                    INC CX
                    INC SI
                    MOV AL, ObjectSize
                    MUL ObjectSize
                    CMP SI, AX
                    JNZ Draw7
                    ret
DrawExplosion       ENDP

;--------------------------------------------------
;Explodes the bomb of the player1 
ExplodeBomb1             PROC
                                       
                         MOV Bomb1Drawn, 0
                         MOV ax, Bomb1X
                         MOV bx, Bomb1Y

                         ;draw explosion in the bomb place
                         MOV explosionX, ax
                         MOV explosionY, bx
                         CALL DrawExplosion

                         
                         
                         ;the explosion in up direction
                         
                         ;check if we can draw up
                         mov si, -2
                         CMP Bomb1Y, 0
                         JZ Checkdown
                         
                         ;get explosion coordinate 
                         mov ax, Bomb1X
                         mov bx, Bomb1Y
                         sub bx, 20
                         ;just to save it
                         MOV explosionX, ax
                         MOV explosionY, bx
                         ;check if there is a player in that place
                         ;if there is a player kill him
                         CMP ax, player1x
                         JNZ CheckPlayer2
                         CMP bx, player1y
                         JNZ CheckPlayer2
                         CALL Player1Killed
                         JMP Empty

                    CheckPlayer2:
                         CMP ax, player2x
                         JNZ UpWalls
                         CMP bx, player2y
                         JNZ UpWalls

                         CALL Player2Killed
                         JMP Empty
                         
                    ;check if there is a wall in that place 
                    ;if there is a wall don't draw the explosion
                    UpWalls:
                         add si, 2
                         CMP si, WallsNo*2
                         JZ Empty
                         CMP ax, WallsX[si]
                         JNZ UpWalls
                         CMP bx, WallsY[si]
                         JZ Checkdown
                         JMP UpWalls
                    
                    Empty:
                         MOV explodedUp, 1
                         CALL DrawExplosion


                    ;Same process for the other directions
                    Checkdown:
                         
                         mov si, -2
                         CMP Bomb1Y, 120
                         JZ CheckRight
                         
                         mov ax, Bomb1X
                         mov bx, Bomb1Y
                         add bx, 20

                         MOV explosionX, ax
                         MOV explosionY, bx

                         CMP ax, player1x
                         JNZ CheckPlayer22
                         CMP bx, player1y
                         JNZ CheckPlayer22

                         CALL Player1Killed
                         JMP Empty2

                    CheckPlayer22:
                         CMP ax, player2x
                         JNZ DownWalls
                         CMP bx, player2y
                         JNZ DownWalls

                         CALL Player2Killed
                         JMP Empty2
                         
                    DownWalls:
                         add si, 2
                         CMP si, WallsNo*2
                         JZ Empty2
                         CMP ax, WallsX[si]
                         JNZ DownWalls
                         CMP bx, WallsY[si]
                         JZ CheckRight
                         JMP DownWalls
                    
                    Empty2:
                         MOV explodedDown, 1
                         CALL DrawExplosion

                    CheckRight:
                         
                         mov si, -2
                         CMP Bomb1X, 300
                         JZ CheckLeft
                         
                         mov ax, Bomb1X
                         add ax, 20
                         mov bx, Bomb1Y

                         MOV explosionX, ax
                         MOV explosionY, bx

                         CMP ax, player1x
                         JNZ CheckPlayer23
                         CMP bx, player1y
                         JNZ CheckPlayer23

                         CALL Player1Killed
                         JMP Empty3

                    CheckPlayer23:
                         CMP ax, player2x
                         JNZ RightWalls
                         CMP bx, player2y
                         JNZ RightWalls

                         CALL Player2Killed
                         JMP Empty3
                         
                    RightWalls:
                         add si, 2
                         CMP si, WallsNo*2
                         JZ Empty3
                         CMP ax, WallsX[si]
                         JNZ RightWalls
                         CMP bx, WallsY[si]
                         JZ CheckLeft
                         JMP RightWalls
                    
                    Empty3:
                         MOV explodedRight, 1
                         CALL DrawExplosion

                    CheckLeft:
                         mov si, -2
                         CMP Bomb1X, 0
                         JZ Finish
                         
                         mov ax, Bomb1X
                         sub ax, 20
                         mov bx, Bomb1Y

                         MOV explosionX, ax
                         MOV explosionY, bx

                         CMP ax, player1x
                         JNZ CheckPlayer24
                         CMP bx, player1y
                         JNZ CheckPlayer24

                         CALL Player1Killed
                         JMP Empty4

                    CheckPlayer24:
                         CMP ax, player2x
                         JNZ LeftWalls
                         CMP bx, player2y
                         JNZ LeftWalls

                         CALL Player2Killed
                         JMP Empty4
                         
                    LeftWalls:
                         add si, 2
                         CMP si, WallsNo*2
                         JZ Empty4
                         CMP ax, WallsX[si]
                         JNZ LeftWalls
                         CMP bx, WallsY[si]
                         JZ Finish
                         JMP LeftWalls
                    
                    Empty4:
                         MOV explodedLeft, 1
                         CALL DrawExplosion


                    Finish:
                         
                         ;return explosion to the old values
                         mov ax, Bomb1X
                         mov explosionX, ax
                         mov ax, Bomb1Y
                         mov explosionY, ax

                         ; 0.25 second delay
                         MOV     CX, 0
                         MOV SI, 0
                         MOV     DX, 0FFFFh
                         MOV     AH, 86H
               LOOPDELAY:
                         INT     15H
                         INC SI
                         CMP SI, 3
                         JNZ LOOPDELAY

                         MOV     DX, 53395
                         INT     15H

                         
                         CALL ClearExplosion
                         CALL DrawPlayer1
                         CALL DrawPlayer2
                         CALL drawallB
                         CALL checkGameOver
                         ret
ExplodeBomb1             ENDP
;--------------------------------------------------
;Explodes the bomb of the player1 
ExplodeBomb2             PROC
                   
                         MOV Bomb2Drawn, 0
                         MOV ax, Bomb2X
                         MOV bx, Bomb2Y

                         ;draw explosion in the bomb place
                         MOV explosionX, ax
                         MOV explosionY, bx
                         CALL DrawExplosion

                         
                         
                         ;the explosion in up direction
                         
                         ;check if we can draw up
                         mov si, -2
                         CMP Bomb2Y, 0
                         JZ Checkdown2
                         
                         ;get explosion coordinate 
                         mov ax, Bomb2X
                         mov bx, Bomb2Y
                         sub bx, 20
                         ;just to save it
                         MOV explosionX, ax
                         MOV explosionY, bx
                         ;check if there is a player in that place
                         ;if there is a player kill him
                         CMP ax, player1x
                         JNZ Check2Player2
                         CMP bx, player1y
                         JNZ Check2Player2
                         CALL Player1Killed
                         JMP Empty22

                    Check2Player2:
                         CMP ax, player2x
                         JNZ UpWalls2
                         CMP bx, player2y
                         JNZ UpWalls2

                         CALL Player2Killed
                         JMP Empty22
                         
                    ;check if there is a wall in that place 
                    ;if there is a wall don't draw the explosion
                    UpWalls2:
                         add si, 2
                         CMP si, WallsNo*2
                         JZ Empty22
                         CMP ax, WallsX[si]
                         JNZ UpWalls2
                         CMP bx, WallsY[si]
                         JZ Checkdown2
                         JMP UpWalls2
                    
                    Empty22:
                         MOV explodedUp, 1
                         CALL DrawExplosion

                    ;Same process for the other directions
                    Checkdown2:
                         
                         mov si, -2
                         CMP Bomb2Y, 120
                         JZ CheckRight2
                         
                         mov ax, Bomb2X
                         mov bx, Bomb2Y
                         add bx, 20

                         MOV explosionX, ax
                         MOV explosionY, bx

                         CMP ax, player1x
                         JNZ Check2Player22
                         CMP bx, player1y
                         JNZ Check2Player22

                         CALL Player1Killed
                         JMP Empty23

                    Check2Player22:
                         CMP ax, player2x
                         JNZ DownWalls2
                         CMP bx, player2y
                         JNZ DownWalls2

                         CALL Player2Killed
                         JMP Empty23
                         
                    DownWalls2:
                         add si, 2
                         CMP si, WallsNo*2
                         JZ Empty23
                         CMP ax, WallsX[si]
                         JNZ DownWalls2
                         CMP bx, WallsY[si]
                         JZ CheckRight2
                         JMP DownWalls2
                    
                    Empty23:
                         MOV explodedDown, 1
                         CALL DrawExplosion



                    CheckRight2:
                         
                         mov si, -2
                         CMP Bomb2X, 300
                         JZ CheckLeft2
                         
                         mov ax, Bomb2X
                         add ax, 20
                         mov bx, Bomb2Y

                         MOV explosionX, ax
                         MOV explosionY, bx

                         CMP ax, player1x
                         JNZ Check2Player23
                         CMP bx, player1y
                         JNZ Check2Player23

                         CALL Player1Killed
                         JMP Empty33

                    Check2Player23:
                         CMP ax, player2x
                         JNZ RightWalls2
                         CMP bx, player2y
                         JNZ RightWalls2

                         CALL Player2Killed
                         JMP Empty33
                         
                    RightWalls2:
                         add si, 2
                         CMP si, WallsNo*2
                         JZ Empty33
                         CMP ax, WallsX[si]
                         JNZ RightWalls2
                         CMP bx, WallsY[si]
                         JZ CheckLeft2
                         JMP RightWalls2
                    
                    Empty33:
                         MOV explodedRight, 1
                         CALL DrawExplosion

                    CheckLeft2:
                         mov si, -2
                         CMP Bomb2X, 0
                         JZ Finish2
                         
                         mov ax, Bomb2X
                         sub ax, 20
                         mov bx, Bomb2Y

                         MOV explosionX, ax
                         MOV explosionY, bx

                         CMP ax, player1x
                         JNZ Check2Player24
                         CMP bx, player1y
                         JNZ Check2Player24

                         CALL Player1Killed
                         JMP Empty44

                    Check2Player24:
                         CMP ax, player2x
                         JNZ LeftWalls2
                         CMP bx, player2y
                         JNZ LeftWalls2

                         CALL Player2Killed
                         JMP Empty44
                         
                    LeftWalls2:
                         add si, 2
                         CMP si, WallsNo*2
                         JZ Empty44
                         CMP ax, WallsX[si]
                         JNZ LeftWalls2
                         CMP bx, WallsY[si]
                         JZ Finish2
                         JMP LeftWalls2
                    
                    Empty44:
                         MOV explodedLeft, 1
                         CALL DrawExplosion


                    Finish2:
                         
                         ;return explosion to the old values
                         mov ax, Bomb2X
                         mov explosionX, ax
                         mov ax, Bomb2Y
                         mov explosionY, ax

                         ; 0.25 second delay
                         MOV     CX, 0
                         MOV SI, 0
                         MOV     DX, 0FFFFh
                         MOV     AH, 86H
               LOOPDELAY2:
                         INT     15H
                         INC SI
                         CMP SI, 3
                         JNZ LOOPDELAY2

                         MOV     DX, 53395
                         INT     15H

                         CALL ClearExplosion
                         CALL DrawPlayer1
                         CALL DrawPlayer2
                         CALL drawallB
                         CALL checkGameOver
                         ret
ExplodeBomb2             ENDP
;--------------------------------------------------
;Clear the place of explosion in all directions
ClearExplosion      PROC
                    
                    mov ax, explosionX
                    mov bx, explosionY
                    ;clear the center
                    mov ClearX, ax
                    mov ClearY, bx
                    CALL ClearBlock

                    CMP explodedUp, 1
                    JNZ NoUp
                    
                    mov ax, explosionX
                    mov bx, explosionY
                    mov ClearX, ax
                    mov ClearY, bx
                    SUB ClearY, 20
                    CALL ClearBlock
               NoUp:     
                    CMP explodedDown, 1
                    JNZ NoDown
                    mov ax, explosionX
                    mov bx, explosionY
                    mov ClearX, ax
                    mov ClearY, bx
                    ADD ClearY, 20
                    CALL ClearBlock
               NoDown:     
                    CMP explodedRight, 1
                    JNZ  NoRight
                    mov ax, explosionX
                    mov bx, explosionY
                    mov ClearX, ax
                    mov ClearY, bx
                    ADD ClearX, 20
                    CALL ClearBlock
               NoRight:     
                    CMP explodedLeft, 1
                    JNZ  NoLeft
                    mov ax, explosionX
                    mov bx, explosionY
                    mov ClearX, ax
                    mov ClearY, bx
                    SUB ClearX, 20
                    CALL ClearBlock
               NoLeft:
                    MOV explodedUp, 0
                    MOV explodedDown, 0
                    MOV explodedRight, 0
                    MOV explodedLeft, 0
                    ret
ClearExplosion      ENDP

;--------------------------------------------------
;updates the game when player1 is killed
Player1Killed       PROC
                    ;should first check if the lives are zero
                    ;will be updated

                    SUB p1Lifes, 1
                    CALL drawp1sc

                    ret
Player1Killed       ENDP
;--------------------------------------------------
;updates the game when player2 is killed
Player2Killed       PROC
                    
                    ;should first check if the lives are zero
                    ;will be updated

                    SUB p2Lifes, 1
                    CALL drawp2sc


                    ret
Player2Killed       ENDP
;--------------------------------------------------

drawBonus1          proc FAR
               mov di,offset bonus1Colors    
               mov cx,xBonus
               mov dx,yBonus
               mov bx,OBJECT_SIZE
               nxtline3:
               line3:
               mov al,[di]
               inc di
               mov ah,0ch
               int 10h
               inc cx
               push bx
               mov bx,xBonus
               add bx,OBJECT_SIZE
               cmp cx,bx
               pop bx
               jnz line3
               inc dx
               mov cx,xBonus
               dec bx
               and bx,bx
               jnz nxtline3

               ret
drawBonus1 endp    


;--------------------------------------------------

;this function to draw bonus2; Bombs
drawBonus2          proc FAR
                    mov di,offset bonus2Colors    
                    mov cx,xBonus
                    mov dx,yBonus
                    mov bx,OBJECT_SIZE
                    nxtline4:
                    line4:
                    mov al,[di]
                    inc di
                    mov ah,0ch
                    int 10h
                    inc cx
                    push bx
                    mov bx,xBonus
                    add bx,OBJECT_SIZE
                    cmp cx,bx
                    pop bx
                    jnz line4
                    inc dx
                    mov cx,xBonus
                    dec bx
                    and bx,bx
                    jnz nxtline4
                    ret
drawBonus2 endp    

;this funcion to draw bonus3; skull
drawBonus3          proc FAR
                    mov di,offset bonus3    
                    mov cx,xBonus
                    mov dx,yBonus
                    mov bx,OBJECT_SIZE
                    nxtlinea:
                    linea:
                    mov al,[di]
                    inc di
                    mov ah,0ch
                    int 10h
                    inc cx
                    push bx
                    mov bx,xBonus
                    add bx,OBJECT_SIZE
                    cmp cx,bx
                    pop bx
                    jnz linea
                    inc dx
                    mov cx,xBonus
                    dec bx
                    and bx,bx
                    jnz nxtlinea
                    ret
drawBonus3 endp    


;--------------------------------------------------
DrawPlayer1         PROC 
                    MOV SI, 0

                    mov cx,Player1X ;x
                    mov dx,Player1Y ;y
               Draw:               
                    CMP SI, 0
                    JZ No
                    MOV AX, SI
                    DIV ObjectSize
                    CMP AH, 0
                    JNZ No
                    MOV CX, Player1X
                    INC dx
               No:  
                    mov al,Player1[SI] ;Pixel color
                    mov ah,0ch ;Draw Pixel Command
                    int 10h
                    INC CX
                    INC SI
                    MOV AL, ObjectSize
                    MUL ObjectSize
                    CMP SI, AX
                    JNZ Draw
                    ret
DrawPlayer1         ENDP
;-----------------------

DrawPlayer2         PROC 
                    MOV SI, 0


                    mov cx,Player2X ;x
                    mov dx,Player2Y ;y
               Draw2:              
                    CMP SI, 0
                    JZ No2
                    MOV AX, SI
                    DIV ObjectSize
                    CMP AH, 0
                    JNZ No2
                    MOV CX, Player2X
                    INC dx
               No2:                
                    mov al,Player2[SI] ;Pixel color
                    mov ah,0ch ;Draw Pixel Command
                    int 10h
                    INC CX
                    INC SI
                    MOV AL, ObjectSize
                    MUL ObjectSize
                    CMP SI, AX
                    JNZ Draw2
                    ret
DrawPlayer2         ENDP

;draw all blocks(walls) in game
DrawWalls           PROC FAR
                   
                    MOV DI, 0
               ALL:
                    MOV SI, 0
                    mov cx,WallsX[DI] ;x
                    mov dx,WallsY[DI] ;y
               Draw3:              
                    CMP SI, 0
                    JZ No3
                    MOV AX, SI
                    DIV ObjectSize
                    CMP AH, 0
                    JNZ No3
                    MOV CX, WallsX[DI]
                    INC dx
               No3: 
                    mov al,WALL[SI] ;Pixel color
                    mov ah,0ch ;Draw Pixel Command
                    int 10h
                    INC CX
                    INC SI
                    MOV AL, ObjectSize
                    MUL ObjectSize
                    CMP SI, AX
                    JNZ Draw3
                    ADD DI,2
                    CMP DI, WallsNo*2
                    JNZ ALL
                    ret
DrawWalls           ENDP

;to delete any block after it's obtained or exploded
ClearBlock          PROC 
                    MOV SI, 0


                    mov cx,ClearX ;x
                    mov dx,ClearY ;y
               Clear:
                    CMP SI, 0
                    JZ No4
                    MOV AX, SI
                    DIV ObjectSize
                    CMP AH, 0
                    JNZ No4
                    MOV CX, ClearX
                    INC dx
               No4:  
                    mov al,BGC ;Pixel color
                    mov ah,0ch ;Draw Pixel Command
                    int 10h
                    INC CX
                    INC SI
                    MOV AL, ObjectSize
                    MUL ObjectSize
                    CMP SI, AX
                    JNZ Clear
                    ret
ClearBlock          ENDP

;validate the no players crashes each other
checkNoMan proc far
      mov dx,xStandMan
      mov cx,yStandMan
      ;check direction of movement 
      cmp checkDir,0
        JE isManUp
      cmp checkDir,1
        JE isManDown
      cmp checkDir,2
        JE isManLeft
      cmp checkDir,3
        JE isManRight   
    isManUp:
      ;check if both at same column 
      cmp xMovingMan,dx
          ;if not, no player above 
          JNE endNoMan
      ;else check if when it moves up it will be over another player 
      mov bx,yMovingMan
      sub bx,OBJECT_SIZE
      cmp bx,yStandMan 
          ;if yes then there is a player above him, return 
          JE endYesMan    
      jmp endNoMan 
    isManDown:
      ;check if both at same column
      cmp xMovingMan,dx
          JNE endNoMan 
          ;else check if when it moves down it will be over another player
      mov bx,yMovingMan
      add bx,OBJECT_SIZE
      cmp bx,yStandMan 
           ;if yes then there is a player below him, return
          JE endYesMan
      jmp endNoMan 
    ;same concept for moving left and right 
    isManRight:
      cmp yMovingMan,cx
          JNE endNoMan
      mov bx,xMovingMan
      add bx,OBJECT_SIZE
      cmp bx,xStandMan
          JE endYesMan
      jmp endNoMan        
    isManLeft:
      cmp yMovingMan,cx
          JNE endNoMan
      mov bx,xMovingMan
      sub bx,OBJECT_SIZE
      cmp bx,xStandMan
          JE endYesMan
      jmp endNoMan         
  endNoMan:
      ;noMan=1 means there is no man so i can move
      mov NoMan,1
      ret
  endYesMan:
      ;noMan=0 means there is a man so i can't move 
      mov NoMan,0         
      ret
checkNoMan endp 

; check if their is a bomb 
checkNoBomb proc far
      mov dx,xMovingMan
      mov cx,yMovingMan
      ;check direction of movement 
      cmp checkDir,0
        JE isBombUp
      cmp checkDir,1
        JE isBombDown
      cmp checkDir,2
        JE isBombLeft
      cmp checkDir,3
        JE isBombRight   
    isBombUp:
      cmp dx,Bomb1x
      JNE noBomb
      mov bx,cx
      sub bx,OBJECT_SIZE
      cmp bx,Bomb1y      
      JNE  noBomb
      cmp bomb1Drawn,1
      JE  toYesBomb
      jmp noBomb
     isBombDown:
      cmp dx,Bomb1x
      JNE noBomb
      mov bx,cx
      add bx,OBJECT_SIZE
      cmp bx,Bomb1y      
      JNE  noBomb
      cmp bomb1Drawn,1
       JE toYesBomb
      jmp noBomb      
     isBombLeft:
      cmp cx,Bomb1y
      JNE noBomb
      mov bx,dx
      sub bx,OBJECT_SIZE
      cmp bx,Bomb1x
      JNE  noBomb
      cmp bomb1Drawn,1
       JE toYesBomb
      jmp noBomb
     isBombRight:  
      cmp cx,Bomb1y
      JNE noBomb
      mov bx,dx
      add bx,OBJECT_SIZE
      cmp bx,Bomb1x      
      JNE  noBomb
      cmp bomb1Drawn,1
       JE toYesBomb
      jmp noBomb
    toYesBomb:
      jmp yesBomb
    noBomb:     
       cmp checkDir,0
        JE isBombUp2
      cmp checkDir,1
        JE isBombDown2
      cmp checkDir,2
        JE isBombLeft2
      cmp checkDir,3
        JE isBombRight2
    isBombUp2:
      cmp dx,Bomb2x
      JNE noBomb2
      mov bx,cx
      sub bx,OBJECT_SIZE
      cmp bx,Bomb2y  
      JNE  noBomb2
      cmp bomb2Drawn,1
      JE  yesBomb
      jmp noBomb2
     isBombDown2:
      cmp dx,Bomb2x
      JNE noBomb2
      mov bx,cx
      add bx,OBJECT_SIZE
      cmp bx,Bomb2y      
      JNE  noBomb2
      cmp bomb2Drawn,1
       JE yesBomb
      jmp noBomb2      
     isBombLeft2:
      cmp cx,Bomb2y
      JNE noBomb2
      mov bx,dx
      sub bx,OBJECT_SIZE
      cmp bx,Bomb2x
      JNE  noBomb2
      cmp bomb2Drawn,1
       JE yesBomb
      jmp noBomb2
     isBombRight2:  
      cmp cx,Bomb2y
      JNE noBomb2
      mov bx,dx
      add bx,OBJECT_SIZE
      cmp bx,Bomb2x      
      JNE  noBomb2
      cmp bomb2Drawn,1
       JE yesBomb
      jmp noBomb2  
      
    YesBomb:
      mov isBomb,1
      ret  
    noBomb2:     
      mov isBomb,0         
      ret  
checkNoBomb endp 

;check if player can move whether from walls or screen boundraies
seeCanMove1 proc far
        ;check the direction of movment and act proparly
        mov bx,0         
        cmp checkDir,0
        JE checkwallU
        cmp checkDir,1
        JE checkwallD
        cmp checkDir,2
        JE checkWallL
        cmp checkDir,3
        JE checkWallR
        ret
    ; check can move up 
    checkwallU:
         ;same concep as checking for a man but loops on walls position instead
         mov dx,xMovingMan
         cmp dx,wallsx[bx]
         JNE getNextU
         mov dx,yMovingMan
         sub dx,OBJECT_SIZE
         cmp dx,wallsy[bx]
         JE  returnCanTMove
        getnextU: 
         add bx,2
         cmp bx, WallsNo*2                        
         JB checkwallU
    ;check cam move down
    checkwallD:
         mov dx,xMovingMan
         cmp dx,wallsx[bx]
         JNE getNextD
         mov dx,yMovingMan
         add dx,OBJECT_SIZE
         cmp dx,wallsy[bx]
         JE returnCanTMove
        getnextD: 
         add bx,2
         cmp bx,WallsNo*2                        
         JB checkwallD
       jmp returnCanMove
    ;check can move left
    checkwallL:
         mov dx,xMovingMan
         sub dx,OBJECT_SIZE
         cmp dx,wallsx[bx]
         JNE getNextL
         mov dx,yMovingMan  
         cmp dx,wallsy[bx]
         JE returnCanTMove
        getnextL: 
         add bx,2
         cmp bx,WallsNo*2                        
         JB checkwallL
       jmp returnCanMove
    ;check can move Right
       checkwallR:
         mov dx,xMovingMan
         add dx,OBJECT_SIZE
         cmp dx,wallsx[bx]
         JNE getNextR
         mov dx,yMovingMan  
         cmp dx,wallsy[bx]
         JE returnCanTMove
        getnextR: 
         add bx,2
         cmp bx,WallsNo*2                        
         JB checkwallR  
       jmp returnCanMove
      ;set NoWall to 0 means there is a wall you can't move               
      returnCanTMove:
        Mov NoWall,0
        jmp goToEnd
      ;set NoWall to 1 means there is Not a wall, you can move   
      returnCanMove:   
        MOV NoWall,1
      goToEnd:
        call checkNoMan
        call checkNoBomb
        ret
seeCanMove1 endp

;for moving player2 position and validate the new position
movePlayer2 proc far 
        push bx
        ;claim moving is player 2 
        Mov bx,player2x
        Mov xMovingMan,bx
        Mov bx,player2y
        Mov yMovingMan,bx 
        ;claim standing is player 1 
        Mov bx,player1x
        Mov xStandMan,bx
        Mov bx,player1y
        Mov yStandMan,bx
        pop bx
        ;check direction of movement 
        CMP keyAscii,77h
        JE  moveUp2
        CMP keyAscii,73h
        JE  moveDown2 
        CMP keyAscii,64h
        JE  moveRight2
        CMP keyAscii,61h
        JE  toMoveLeft2  
        ;then one doesn't move prepare two to be cleared 
        JMP toReturn2
   moveUp2:
        ;check if top edge
        CMP  Player2Y,0
        JZ   toReturn2 
        ;check if new position is inside a wall 
        mov  checkdir,0
        call seeCanMove1  ;check if there is a wall or a man
        cmp  NoWall,0
        JE   toReturn2
        cmp  NoMan,0
        JE   toReturn2        
        cmp  isBomb,0
        JNE toReturn2        
        ;else move
        SUB Player2Y, OBJECT_SIZE
        JMP endPlayer2Moved
   moveDown2:
        ;check if down edge 
        CMP Player2Y, 120
        JZ  toReturn2
        ;check if new position is inside a wall  or a man
        mov checkdir,1
        call seeCanMove1
        cmp NoWall,0
        JE endPlayer2Proc
        cmp NoMan,0
        JE  toReturn2    
        
        cmp  isBomb,0
        JNE toReturn2
        
        ;else move
        ADD Player2Y,OBJECT_SIZE 
        JMP endPlayer2Moved
   toMoveLeft2:
         jmp moveLeft2     
   toReturn2:
        jmp endPlayer2Proc
   moveRight2:
        ;check if right edge  
        CMP Player2X, 300
        JZ endPlayer2Proc
        ;check if new position is inside a wall or a man
        mov checkdir,3
        call seeCanMove1
        cmp NoWall,0
        JE endPlayer2Proc
        cmp NoMan,0
        JE  endPlayer2Proc
        
        cmp  isBomb,0
        JNE endPlayer2Proc
        ;else move
        ADD Player2X, OBJECT_SIZE      
        JMP endPlayer2Moved
   moveLeft2:
        ;check if left edge
        CMP Player2X, 0
        JZ endPlayer2Proc
        ;check if new position is inside a wall   or a man
        mov checkdir,2
        call seeCanMove1
        cmp NoWall,0
        JE endPlayer2Proc
        cmp NoMan,0
        JE  endPlayer2Proc
                
        cmp  isBomb,0
        JNE endPlayer2Proc
        
        sub Player2X, OBJECT_SIZE      
        JMP endPlayer2Moved
        ;else move
  endPlayer2Proc:
    mov playerMoved,0      
    ret
  endPlayer2Moved:
    Mov playerMoved,1  
     ret       
movePlayer2 endp 

;for moving player2 position and validate the new position
movePlayer1 proc far
        push bx
        ;claim moving is player 1 
        Mov bx,player1x
        Mov xMovingMan,bx
        Mov bx,player1y
        Mov yMovingMan,bx 
        ;claim standing is player 2 
        Mov bx,player2x
        Mov xStandMan,bx
        Mov bx,player2y
        Mov yStandMan,bx
        pop bx
        ;check direction of movement 
        CMP KeyScancode,48h
        JE  moveUp
        CMP KeyScancode,50h
        JE  moveDown 
        CMP KeyScancode,4dh
        JE  moveRight
        CMP KeyScancode,4bh
        JE  toMoveLeft  
        ;then one doesn't move prepare two to be cleared 
        JMP endPlayer1Proc
   moveUp:
        ;check if top edge
        CMP  Player1Y, 0
        JZ   toReturn 
        ;check if new position is inside a wall 
        mov  checkdir,0
        call seeCanMove1  ;check if there is a wall or a man
        cmp  NoWall,0
        JE   toReturn
        cmp  NoMan,0
        JE   toReturn
        cmp  isBomb,0
        JNE toReturn
        ;else move
        SUB Player1Y, OBJECT_SIZE
        JMP endPlayerOneMoved
   moveDown:
        ;check if down edge 
        CMP Player1Y, 120
        JZ  toReturn
        ;check if new position is inside a wall  or a man
        mov checkdir,1
        call seeCanMove1
        cmp NoWall,0
        JE  toReturn
        cmp NoMan,0
        JE  toReturn         
        cmp  isBomb,0
        JNE toReturn   
        ;else move
        ADD Player1Y, OBJECT_SIZE 
        JMP endPlayerOneMoved
     toReturn:
    jmp endPlayer1Proc 
   toMoveLeft:
       jmp moveLeft   
   moveRight:
        ;check if right edge  
        CMP Player1X, 300
        JZ endPlayer1Proc
        ;check if new position is inside a wall or a man
        mov checkdir,3
        call seeCanMove1
        cmp NoWall,0
        JE endPlayer1Proc
        cmp NoMan,0
        JE  endPlayer1Proc        
        cmp  isBomb,0
        JNE endPlayer1Proc
        ;else move
        ADD Player1X, OBJECT_SIZE      
        JMP endPlayerOneMoved 
  
   moveLeft:
        ;check if left edge
        CMP Player1X, 0
        JZ endPlayer1Proc
        ;check if new position is inside a wall   or a man
        mov checkdir,2
        call seeCanMove1
        cmp NoWall,0
        JE endPlayer1Proc
        cmp NoMan,0
        JE  endPlayer1Proc
                
        cmp  isBomb,0
        JNE endPlayer1Proc
        
        sub Player1X, OBJECT_SIZE      
        JMP endPlayerOneMoved
        ;else move
  endPlayer1Proc:
    mov playerMoved,0      
    ret
  endPlayerOneMoved:
    Mov playerMoved,1
    ret  
movePlayer1 endp   




; check if got bonus 
isGotBonus proc
    ;get location of just moved player
    cmp playerGotBonus,1
    jNE doFor2
    mov ax,player1x
    mov bx,player1y
    jmp do    
    doFor2: 
    mov ax,player2x
    mov bx,player2y
    ;if same x and y as Bonus location set gotBonus to 1 else 0 ;arrbonus1 dw 0, -1, -1
    ;check got bonus 1
 do:                                                             ;arrbonus2 dw 0, -1, -1                                                            ;arrbonus3
    cmp ax,arrBonus1[2];check x
    JNE didntGetBonus1
    cmp bx,arrBonus1[4];check y
    JE  didGetBonus1
    ;check if got bonus 2      
    didntGetBonus1:
    cmp ax,arrBonus2[2];check x
    JNE didntGetBonus2
    cmp bx,arrBonus2[4];check y
    JE  didGetBonus2
    ;check if got bonus 3      
    didntGetBonus2:
    cmp ax,arrBonus3[2];check x
    JNE NoBonus
    cmp bx,arrBonus3[4];check y
    JE  didGetBonus3
    
    jmp NoBonus
         
  didGetBonus1:
    mov ax,arrBonus1
    mov tokenBonusType,ax
    mov gotBonus,1
    mov arrBonus1[2],-1 ;impossible value till it is redrawed
    mov arrBonus1[4],-1 ;impossible value till it is redrawed
    mov arrBonus1,0 
    sub numbonus,1	
    ret
  didGetBonus2:
    mov ax,arrBonus2
    mov tokenBonusType,ax
    mov gotBonus,1
    mov arrBonus2[2],-1 ;impossible value till it is redrawed
    mov arrBonus2[4],-1 ;impossible value till it is redrawed
    mov arrBonus2,0    
    sub numbonus,1
	ret
  didGetBonus3:
    mov ax,arrBonus3
    mov tokenBonusType,ax
    mov gotBonus,1
    mov arrBonus3[2],-1 ;impossible value till it is redrawed
    mov arrBonus3[4],-1 ;impossible value till it is redrawed
    mov arrBonus3,0    
    sub numbonus,1
	ret   
  NoBonus:
    mov gotBonus,0
    ret  
isGotBonus endp 

;update scores of each player for any type of 3 bonus  
handleBonus proc
   ; for player one
    cmp playerGotBonus,1
    JNE checkplayer2GotBonus
    ;check type
    cmp tokenBonusType,1
    JNE checkType2
    ; update lives +
    add p1Lifes,1
    call drawP1sc
    ret
    checkType2:
    cmp tokenBonusType,2
    JNE checkType3
    ; update bombs +
    add  p1Bombs,1
    call drawP1sc2
    ret
    checkType3:
    ; update lives -
    cmp tokenBonusType,3
    JNE endHandleBonus
    sub  p1Lifes,1
    call drawP1sc
    ret
   ; for player 2
 checkplayer2GotBonus:
    cmp tokenBonusType,1
    JNE checkType2_2
    ; update lives +
    add  p2Lifes,1
    call drawP2sc
    ret
    checkType2_2:
    cmp tokenBonusType,2
    JNE checkType3_2
    ; update bombs +
    add  p2Bombs,1
    call drawP2sc2
    ret
    checkType3_2:
    ; update lives -
    cmp tokenBonusType,3
    JNE endHandleBonus
    sub  p2Lifes,1 
    call drawP2sc
endHandleBonus:
     ret
handleBonus endp
;move any coordintaes to the new 
moveMan             PROC FAR 
        ;see if move player one 
        push bx
        MOV  bX, Player1X
        MOV  ClearX, bX
        MOV  bX, Player1Y
        MOV  ClearY, bX
        pop bx
        call movePlayer1
        cmp playerMoved,1
        JNE callPlayer2ToMove   ; player can't move check the other one      
        ;if moved checkifgot bonus
        mov  playerGotBonus,1
        call isGotBonus
        cmp  gotBonus,1
        JNE  draw4   
        call handleBonus           
        jmp draw4
        ;see if move player one
   callPlayer2ToMove:
        push bx
        MOV  bX, Player2X
        MOV  ClearX, bX
        MOV  bX, Player2Y
        MOV  ClearY, bX
        pop bx
        call movePlayer2 
        cmp playerMoved,1
        JNE endMoveMan      ; player can't move too
        ;if moved checkifgot bonus
        mov  playerGotBonus,2
        call isGotBonus
        cmp  gotBonus,1
        JNE  draw4_2
        call handleBonus           
        jmp draw4_2               
   draw4:
        CALL ClearBlock
        CALL DrawPlayer1
        call checkGameOver
        ret
   draw4_2:
        CALL ClearBlock
        CALL DrawPlayer2
        call checkGameOver             
   endMoveMan:
        ret    
moveMan ENDP  

;checks for all valid keys can be pressed in game
keyPressed proc far    
          mov ah,0
          int 16h
          mov KeyScancode,ah
          mov keyAscii,al
          CMP keyAscii, 54        ;if the key is 6
          JNZ next
               CMP Bomb1Drawn, 1
               JZ tempendProc   
               mov cx, Player1X
               mov dx, Player1Y
               add cx, 20
               MOV Bomb1X, cx
               MOV Bomb1Y, dx
               CALL drawBomb1
               JMP tempendProc
          next:
          CMP keyAscii, 56        ;if the key is 8
          JNZ next2
               CMP Bomb1Drawn, 1
               JZ tempendProc
               mov cx, Player1X
               mov dx, Player1Y
               sub dx, 20
               MOV Bomb1X, cx
               MOV Bomb1Y, dx
               CALL drawBomb1
               JMP tempendProc

          tempendProc:
               JMP tempendProc2

          next2:
          CMP keyAscii, 52        ;if the key is 4
          JNZ next3
               CMP Bomb1Drawn, 1
               JZ tempendProc2
               mov cx, Player1X
               mov dx, Player1Y
               sub cx, 20
               MOV Bomb1X, cx
               MOV Bomb1Y, dx
               CALL drawBomb1
               JMP tempendProc2
          next3:
          CMP keyAscii, 50        ;if the key is 2
          JNZ next4
               CMP Bomb1Drawn, 1
               JZ tempendProc2
               mov cx, Player1X
               mov dx, Player1Y
               add dx, 20
               MOV Bomb1X, cx
               MOV Bomb1Y, dx
               CALL drawBomb1
               JMP tempendProc2
          
          tempendProc2:
               JMP tempendProc3


          next4:
          CMP keyAscii, 104        ;if the key is h
          JNZ next5
               CMP Bomb2Drawn, 1
               JZ tempendProc3
               mov cx, Player2X
               mov dx, Player2Y
               add cx, 20
               MOV Bomb2X, cx
               MOV Bomb2Y, dx
               CALL drawBomb2
               JMP tempendProc3
          next5:
          CMP keyAscii, 116       ;if the key is t
          JNZ next6
               CMP Bomb2Drawn, 1
               JZ tempendProc3
               mov cx, Player2X
               mov dx, Player2Y
               sub dx, 20
               MOV Bomb2X, cx
               MOV Bomb2Y, dx
               CALL drawBomb2
               JMP tempendProc3

          tempendProc3:
               JMP endProc

          next6:
          CMP keyAscii, 102       ;if the key is f
          JNZ next7
               CMP Bomb2Drawn, 1
               JZ endProc
               mov cx, Player2X
               mov dx, Player2Y
               sub cx, 20
               MOV Bomb2X, cx
               MOV Bomb2Y, dx
               CALL drawBomb2
               JMP endProc
          next7:
          CMP keyAscii, 103       ;if the key is g
          JNZ next8
               CMP Bomb2Drawn, 1
               JZ endProc
               mov cx, Player2X
               mov dx, Player2Y
               add dx, 20
               MOV Bomb2X, cx
               MOV Bomb2Y, dx
               CALL drawBomb2
               JMP endProc
          next8:
          CMP KeyScancode, 62        ;if the key is F4
          JNZ next9
          call ScoreEnd 
          next9:
          call moveMan          
     endProc:
          ret      
keyPressed endp

;--------------------------------------------------------------------------
;this function to draw score bar,chat box

InGameChat proc far
     call scorelines
     call p1info
     call drawlifes
     call drawp1sc
     call drawsbombs
     call drawp1sc2
     call p2info
     call drawlifes2  
     call drawp2sc
     call drawsbombs
     call drawp2sc2
     call chatbox
     call PageEnd
     ret
InGameChat endp

;draws 2 lines of score bar
scorelines proc 
     mov cx,0
     mov dx,line1score
     mov al,9
     mov ah,0ch
     line1loop: 
     mov dx,line1score
     int 10h    
     mov dx,line2score
     int 10h    
     inc cx
     cmp cx,320
     jnz line1loop

     ;vertical line to seperate 2 players scores
     mov cx,160        ;mid of screen
     mov dx,line1score      ;from line1
     mov al,9
     mov ah,0ch
     loopvert:
     int 10h    
     inc dx
     cmp dx,line2score      ;untill line2
     jnz loopvert
     
     ret    
scorelines endp    


;write player1 Name
p1info proc
     MOV AX, @DATA
     MOV ES, AX
     MOV BP, OFFSET P1Name ; ES: BP POINTS TO THE TEXT
     MOV AH, 13H ; WRITE THE STRING
     MOV AL, 01H; ATTRIBUTE IN BL, MOVE CURSOR TO THAT POSITION
     XOR BH,BH ; VIDEO PAGE = 0
     MOV BL, 0Fh ;GREEN
     MOV Cl, LenUSNAME ; LENGTH OF THE STRING
     mov ch,0
     MOV DH,18 ;ROW TO PLACE STRING
     MOV DL, 0 ; COLUMN TO PLACE STRING
     INT 10H

     ret    
p1info endp    


;draw small heart for player1
drawlifes proc
               mov di,offset heartSmall    
               
               ;to calculate lifeX=8*NameDim + 8(for space)=9*NameDim
               mov ah,0
               mov al,LenUSNAME
               mov cl,9
               mul cl
               
               mov lifesx,ax ;set life position
               
               
               mov cx,lifesX
               mov dx,lifesY
               mov bx,8
               nxtline6:
               line6:
               mov al,[di]
               inc di
               mov ah,0ch
               int 10h
               inc cx
               push bx
               mov bx,lifesX
               add bx,8
               cmp cx,bx
               pop bx
               jnz line6
               inc dx
               mov cx,lifesX
               dec bx
               and bx,bx
               jnz nxtline6


     ret 
drawlifes endp    

;write conlon then lifes score , NOTE:Call this funcion ''only'' after taking life bonus for player1  
;Don't render any other function, i seperated them for this purpose(reduce flickering)
drawp1sc proc
     MOV BP, OFFSET colonletter ; ES: BP POINTS TO THE TEXT
     MOV AH, 13H ; WRITE THE STRING
     MOV AL, 01H; ATTRIBUTE IN BL, MOVE CURSOR TO THAT POSITION
     XOR BH,BH ; VIDEO PAGE = 0
     MOV BL, 0Fh ;white
     MOV CX,1 ; LENGTH OF THE STRING
     MOV DH,18 ;ROW TO PLACE STRING
     mov dl,LenUSNAME
     add dl,2  ; COLUMN TO PLACE STRING 
     INT 10H

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

     
	 
     ret
drawp1sc endp    


;draw bombs for player1&player2
drawsbombs proc
               mov di,offset bombSmall    
               
               ;to calculate bombX=lifeX+8(DimHeart)+8(space)+8(colon)+8(scoreLifes)+2*8(space) = lifeX+40
               mov ax,lifesX
               add ax,40
               mov bombsX,ax ;set bomb position
               
               mov cx,bombsX
               mov dx,bombsY
               mov bx,8
               nxtline7:
               line7:
               mov al,[di]
               inc di
               mov ah,0ch
               int 10h
               inc cx
               push bx
               mov bx,bombsX
               add bx,8
               cmp cx,bx
               pop bx
               jnz line7
               inc dx
               mov cx,bombsX
               dec bx
               and bx,bx
               jnz nxtline7

     ret
drawsbombs endp    

checkGameOver proc
   cmp p1Lifes,0
   JE  endGame
   cmp p2Lifes,0
   JE endGame
   ret
   endGame:
     call ScoreEnd
     ret
checkGameOver endp
;Draw score of bombs for player1, NOTE:Call this function ''ONLY'' after taking bomb bonus for player
;Don't render any other function, i seperated them for this purpose(reduce flickering)
drawp1sc2 proc
     MOV BP, OFFSET colonletter ; ES: BP POINTS TO THE TEXT
     MOV AH, 13H ; WRITE THE STRING
     MOV AL, 01H; ATTRIBUTE IN BL, MOVE CURSOR TO THAT POSITION
     XOR BH,BH ; VIDEO PAGE = 0
     MOV BL, 0Fh ;White
     MOV CX,1 ; LENGTH OF THE STRING
     MOV DH,18 ;ROW TO PLACE STRING

     mov dl,LenUSNAME
     add dl,7  ; COLUMN TO PLACE STRING 
     INT 10H

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

     ret
drawp1sc2 endp    



;----------------------------------------------------------------------------------
;Player2 functions


;write player2 name
p2info proc
     MOV AX, @DATA
     MOV ES, AX
     MOV BP, OFFSET Nameplayer2 ; ES: BP POINTS TO THE TEXT
     MOV AH, 13H ; WRITE THE STRING
     MOV AL, 01H; ATTRIBUTE IN BL, MOVE CURSOR TO THAT POSITION
     XOR BH,BH ; VIDEO PAGE = 0
     MOV BL, 0Fh ;white
     MOV cl, lenp2 ; LENGTH OF THE STRING
     mov ch,0
	 MOV DH,18 ;ROW TO PLACE STRING
     MOV DL,21 ; COLUMN TO PLACE STRING
     INT 10H
     ret    
p2info endp    

;draw small heart after name
drawlifes2 proc
               mov di,offset heartSmall    
               
               ;to calculate lifeX=8*NameDim +160(half screec)+ 8(for space)=8*NameDim+168
               mov ah,0
               mov al,lenp2
               mov cl,10
               mul cl
               
               add ax,160
               mov lifesx,ax ;set life position
               
               mov cx,lifesX
               mov dx,lifesY
               mov bx,8
               nxtline8:
               line8:
               mov al,[di]
               inc di
               mov ah,0ch
               int 10h
               inc cx
               push bx
               mov bx,lifesX
               add bx,8
               cmp cx,bx
               pop bx
               jnz line8
               inc dx
               mov cx,lifesX
               dec bx
               and bx,bx
               jnz nxtline8

     ret 
drawlifes2 endp    
                                                                                       
                                                                                       
;write conlon then lifes score , NOTE:Call this funcion ''ONLY'' after taking life bonus for player2  
;Don't render any other functions, i seperated them for this purpose(reduce flickering)
drawp2sc proc
     MOV BP, OFFSET colonletter ; ES: BP POINTS TO THE TEXT
     MOV AH, 13H ; WRITE THE STRING
     MOV AL, 01H; ATTRIBUTE IN BL, MOVE CURSOR TO THAT POSITION
     XOR BH,BH ; VIDEO PAGE = 0
     MOV BL, 0Fh ;WHITE
     MOV CX,1 ; LENGTH OF THE STRING
     MOV DH,18 ;ROW TO PLACE STRING
     mov dl,lenp2
     add dl,23  ; 20(half of screen+1(heart)+1(space) 
     INT 10H

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
     
     ret
drawp2sc endp    


;write conlon then lifes score , NOTE:Call this funcion ''ONLY'' after taking life bonus for player2  
;Don't render any other functions, i seperated them for this purpose(reduce flickering)
drawp2sc2 proc
     MOV BP, OFFSET colonletter ; ES: BP POINTS TO THE TEXT
     MOV AH, 13H ; WRITE THE STRING
     MOV AL, 01H; ATTRIBUTE IN BL, MOVE CURSOR TO THAT POSITION
     XOR BH,BH ; VIDEO PAGE = 0
     MOV BL, 0Fh ;White
     MOV CX,1 ; LENGTH OF THE STRING
     MOV DH,18 ;ROW TO PLACE STRING
     mov dl,lenp2
     add dl,28  ; COLUMN TO PLACE STRING 
     INT 10H

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

     
     ret
drawp2sc2 endp    
 

;------------------------------------------------------
;chatBox part 
chatbox proc
     ;scroll ccreen for chat box
     MOV AH, 06h ; Scroll up function
     XOR AL, AL ; Clear entire screen
     mov Ch, 20 ; Upper left corner CH=row, CL=column
     mov cl,0   
     MOV DX, 184FH ; lower right corner DH=row, DL=column
     MOV BH, 0 ; color
     INT 10H
     ;write player name
     MOV BP, OFFSET P1Name ; ES: BP POINTS TO THE TEXT
     MOV AH, 13H ; WRITE THE STRING
     MOV AL, 01H; ATTRIBUTE IN BL, MOVE CURSOR TO THAT POSITION
     XOR BH,BH ; VIDEO PAGE = 0
     MOV BL, 09h ;Light blue
     MOV Cl, LenUSNAME ; LENGTH OF THE STRING
     mov ch,0
     MOV DH,20 ;ROW TO PLACE STRING
     MOV DL, 0 ; COLUMN TO PLACE STRING
     INT 10H
     ;write colon
     mov ah,2
     mov dl,58 ;58 is ascii code of( : )
     int 21h

     ret
chatbox endp     

;function to write end of page note
PageEnd proc
     mov cx,0
     mov dx,190 ;last 10 pexils in screen (last row of letters)
     mov al,9
     mov ah,0ch
     endpageloop: 
     int 10h    
     inc cx
     cmp cx,320
     jnz endpageloop

     ;end message divided into 3 parts

     ;first part
     MOV BP, OFFSET messageEnd1 ; ES: BP POINTS TO THE TEXT
     MOV AH, 13H ; WRITE THE STRING
     MOV AL, 01H; ATTRIBUTE IN BL, MOVE CURSOR TO THAT POSITION
     XOR BH,BH ; VIDEO PAGE = 0
     MOV BL, 09h ;blue
     MOV Cl, lenEnd1 ; LENGTH OF THE STRING
     mov ch,0
     MOV DH,24 ;ROW TO PLACE STRING
     MOV DL, 0 ; COLUMN TO PLACE STRING
     INT 10H

     ;second part
     MOV BP, OFFSET NamePlayer2 ; ES: BP POINTS TO THE TEXT
     MOV cl, lenp2 ; LENGTH OF THE STRING
     mov ch,0
	 MOV DH,24 ;ROW TO PLACE STRING
     MOV DL,lenEnd1 ; start after part2 string length 
     add dl,1       ;for space
     INT 10H

     ;third part
     MOV BP, OFFSET messageEnd2 ; ES: BP POINTS TO THE TEXT
     MOV CX, lenEnd2 ; LENGTH OF THE STRING
     MOV DH,24 ;ROW TO PLACE STRING
     MOV DL,lenEnd1 ; start after part1 string length 
     add dl,lenp2       ;after part2
     add dl,1           ;space
     INT 10H

     ret
PageEnd endp
;----------------------------------------------------------------------------------------
GetTime  proc near
		
		MOV AH, 2CH
		INT 21H			;CH = HOUR (0, 23)
						;CL = MIN  (0, 59)
						;DH = SEC  (0, 59)	 
						;DL = HUNDREDTH OF SEC (0, 99)
		ret
GetTime  endp
;--------------------------------------------------------------

StartTime	PROC near
			
		;CALL GETTIME
		MOV AH, 2CH
		INT 21H
		MOV LASTBONUS, DH
		ret	
StartTime	ENDP
;--------------------------------------------------------------

UpdateTime	proc near
		
		
		;CALL GETTIME
		MOV AH, 2CH
		INT 21H
		MOV NEXTBONUS, DH
		ret
UpdateTime	endp
;--------------------------------------------------------------

CheckBonus	proc far
		mov ax, @data
        mov ds, ax
		
	
		
		CALL UpdateTime
		MOV AL, LASTBONUS
		MOV AH, NEXTBONUS
		CMP AH, AL
		JL  LESS
CMPR: 	SUB AH, AL
		CMP AH, 10
		JL NOpe
		MOV AL, NEXTBONUS
		MOV LASTBONUS, AL
		jmp cmpnumbo
		LESS:	ADD AH, 60
		JMP CMPR
		
cmpnumbo:	mov bx, numbonus
		cmp bx, 3
		jae NOpe
		mov bx, numbonus
		inc bx
		mov numbonus, bx
		
		CALL ChooseBonus
		jmp NOpe

NOpe:     ret
CheckBonus	endp


;-----------------------------------------------------------------

RandomLocation	proc 
		
		
lop:		
		mov ax, index
		add ax, 80
		cmp ax, 164
		jle tmm
		sub ax, 164
tmm:	mov index, ax		
		MOV AH, 0
		
		MOV DI, offset BONUSX
		add di, ax
		MOV BX, [DI]
		MOV xBonus, BX
		MOV DI, offset BONUSY
		add di, ax
		MOV BX, [DI]
		MOV yBonus, BX
		
		cmp bx, Bomb1y  ;making sure that the bomb not draw on any bomb 
		jne cmpbmb
		mov bx, xBonus
		cmp bx, Bomb1X
		je lop
		
cmpbmb:	cmp bx, Bomb2X
		jne cmppl 
		mov bx, yBonus
		cmp bx, Bomb2Y
		je lop
		
cmppl:	MOV BX, yBonus    ;making sure that the bomb not draw on any player
		cmp bx, Player1Y
		jne cmp2
		mov bx, xBonus
		cmp bx, Player1X
		je lop
		
cmp2:	cmp bx, Player2X
		jne en
		mov bx, yBonus
		cmp bx, Player2Y
		je lop
en:		ret
RandomLocation	endp

;-----------------------------------------------------------------

ChooseBonus	proc NEAR
		CALL RandomLocation
		MOV AH, 2CH
		INT 21H
		MOV Al, dh
		mov ah, 0
		mov dh, 3
		DIV DH
		CMP AH, 0
		JNE B2
		MOV BX, 1
		MOV CurBonus, BX
		CALL drawBonus1
		JMP ENding
		
B2:		CMP AH, 1
		JNE B3
		MOV BX, 2
		MOV CurBonus, BX
		CALL drawBonus2
		JMP ENding
		
B3:		CALL drawBonus3
		MOV BX, 3
		MOV CurBonus, BX
		
ENding:	call setBonus	
		RET
ChooseBonus endp

bonusindex	proc
		mov ax, arrbonus1[0]
		cmp ax, 0
		jne nx1
		mov ax, 1
		jmp foo
nx1:	mov ax, arrbonus2[0]
		cmp ax, 0
		jne nx2
		mov ax, 2
		jmp foo
nx2:	mov ax, arrbonus3[0]
		cmp ax, 0
		jne foo
		mov ax, 3
foo:	ret
bonusindex	endP

;--------------------------------------------------------

setBonus	proc
		call bonusindex
		cmp ax, 1
		jne set2
		mov bx, xBonus
		mov arrbonus1[2], bx
		mov bx, yBonus
		mov arrbonus1[4], bx
		mov bx, curbonus
		mov arrbonus1[0], bx
		jmp fine
		
set2:	cmp ax, 2
		jne set3
		mov bx, xBonus
		mov arrbonus2[2], bx
		mov bx, yBonus
		mov arrbonus2[4], bx
		mov bx, curbonus
		mov arrbonus2[0], bx
		jmp fine

set3:	cmp ax, 3
		jne fine
		mov bx, xBonus
		mov arrbonus3[2], bx
		mov bx, yBonus
		mov arrbonus3[4], bx
		mov bx, curbonus
		mov arrbonus3[0], bx

fine:	
ret
setBonus endp

;-----------------------------------------
drawallB  proc
     
          CMP arrBonus1[0], 0
          JZ cr2
          mov ax, arrBonus1[2]
          mov bx, arrBonus1[4]
          mov xBonus, ax
          mov yBonus, bx      ;setting array 1

          cmp arrBonus1[0], 1
          jne call21          ;jmp to the required label
          CALL drawBonus1

call21:   cmp arrBonus1[0], 2
          jne call31
          CALL drawBonus2

call31:   cmp arrBonus1[0], 3
          jne cr2
          CALL drawBonus3

cr2:      CMP arrBonus2[0], 0
          jz cr3
          mov ax, arrBonus2[2] 
          mov bx, arrBonus2[4]
          mov xBonus, ax      ;;setting array 1
          mov yBonus, bx
          cmp arrBonus2[0], 1
          jne call22          ;jmp to the required label
          CALL drawBonus1

call22:   cmp arrBonus2[0], 2
          jne call32
          CALL drawBonus2

call32:    cmp arrBonus2[0], 3
          jne cr3
          CALL drawBonus3
cr3:      
          CMP arrBonus3[0], 0
          jz Cr4
          mov ax, arrBonus3[2]
          mov bx, arrBonus3[4]
          mov xBonus, ax
          mov yBonus, bx      ;setting array 1
          
          cmp arrBonus3[0], 1
          jne call23          ;calling the required function
          CALL drawBonus1

call23:   cmp arrBonus3[0], 2
          jne call33
          CALL drawBonus2

call33:    cmp arrBonus3[0], 3
          jne cr4
          CALL drawBonus3
cr4:     ret
drawallB  endp
END
