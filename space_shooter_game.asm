INCLUDE Irvine32.inc
.386
.Stack 1024
;Write_To_File PROTO, Score: DWORD, Play: PTR BYTE
Read_File PROTO
.data
FileHandle DWORD ?
FileName BYTE "Score1.txt", 0
Space BYTE " ", 0
Hel BYTE "Welcome to the game developed by Fiza and Kainat", 0
titl BYTE "SPACE SHOOTER", 0
op1 BYTE "1 - Begin Game", 0
op2 BYTE "2 - Help", 0
op3 BYTE "3 - View Score", 0
op4 BYTE "4 - Exit the game", 0
str1 BYTE "press uparrowkey to move up",0
str2 BYTE "press rightarrowkey to move right",0
str3 BYTE "press downarraykey to move down",0
str4 BYTE "press leftarrowkey to move left",0
str5 BYTE "Enter the Choice: ",0
nameop BYTE "Enter Name: ", 0
str6 BYTE "Name: ",0
str7 BYTE "Score: ",0
str8 BYTE "Game Over!!!!",0
str9 BYTE "SCORECARD:",0
Player BYTE 6 DUP(0), 0
speed_factor BYTE 1
Sco Dword 0
left Byte 0
up BYTE 0
down Byte 0
right Byte 0
edleften DWORD ?
edrighten DWORD ?
edupen DWORD ?
eddownen DWORD ?
playeredx DWORD ?
numberstring byte 16 DUP (0)
numberchar Dword 0
fmt byte "%d",0
buffer DWORD 5000 DUP(?),0
.code
main PROC
;mov ecx, 5
;LL:
;PUSH ECX
;mov edx, OFFSET Player
;mov ecx, 20
;Call ReadString
;call ReadDec
;mov Sco, eax
;INVOKE Write_To_File, Sco, ADDR Player
;POP ECX
;LOOP LL
;Call crlf

Start:
mov eax,5+(7*16)
call SetTextColor
mov edx, 0
Call clrscr
Call Make_Border
mov dh, 6
mov dl, 14
Call Gotoxy
Push edx
;Call Randomize
mov edx,OFFSET Hel
call WriteString
pop edx
inc dh
call Gotoxy
push edx
mov edx, OFFSET titl
Call WriteString
pop edx
inc dh
Call Gotoxy
push edx
mov edx, OFFSET op1
Call WriteString
pop edx
inc dh
Call Gotoxy
push edx
mov edx, OFFSET op2
Call WriteString
pop edx
inc dh
Call Gotoxy
push edx
mov edx, OFFSET op3
Call WriteString
pop edx
inc dh
Call Gotoxy
push edx
mov edx, OFFSET op4
Call WriteString
pop edx
inc dh
Call Gotoxy
push edx
mov edx,OFFSET str5
call WriteString
Call ReadDec
pop edx
cmp eax, 1
JE _go
cmp eax, 2
JE _help
cmp eax, 3
JE _score
cmp eax, 4
JNE Start

exit
_help:
Call clrscr
Call Make_Border
mov dh, 6
mov dl, 14
Call Gotoxy
push edx
mov edx,OFFSET str1
Call WriteString
pop edx
inc dh
call Gotoxy
push edx
mov edx,OFFSET str2
call WriteString
pop edx
inc dh
call Gotoxy
push edx
mov edx,OFFSET str3
call WriteString
pop edx
inc dh
call Gotoxy
push edx
mov edx,OFFSET str4
call WriteString
pop edx
inc dh
call Gotoxy
push edx
mov edx,OFFSET str4
Call WaitMsg
pop edx
Jmp Start
_score:
Call clrscr
;Call Make_Border
mov dh, 0
mov dl, 25
Call Gotoxy
inc dh
push edx
mov edx, OFFSET str9
call WriteString
call crlf
mov edx,OFFSET FileName
call OpenInputFile
mov FileHandle,eax
cmp eax, INVALID_HANDLE_VALUE
jne file_ok_read_file
jmp after
file_ok_read_file:
mov eax,FileHandle
mov edx,offset buffer
mov ecx,sizeof buffer
call ReadFromFile

mov edx, offset buffer
call WriteString
mov eax,FileHandle
call CloseFile
after:
pop edx
mov dh,10
mov dl,25
Call Gotoxy
Call WaitMsg

Jmp Start
_go:
mov left, 0
mov right, 0
mov up, 0
mov down, 0
mov Sco, 0
Call clrscr
Call Make_Screen
push edx
mov dh, 5
mov dl, 15
Call GotoXY
mov edx, OFFSET nameop
Call WriteString
mov edx, OFFSET Player
mov ecx, 10
Call ReadString
pop edx
Call clrscr
Call Make_Screen
Call Make_Enemies
Input:
Call Show_Score
Call ReadChar
cmp ah, 'H'
JE _CShoot
cmp ah, 'M'
JE _CShoot
cmp ah, 'P'
JE _CShoot
cmp ah, 'K'
JE _CShoot
cmp al, '.'
JE _Pause
cmp al, 48
JNE Input
Jmp _End
_CShoot:
Call Shoot
Call Move_Enemies
PUSH eax
mov eax, edleften
Cmp eax, playeredx
JE _End
mov eax, edrighten
Cmp eax, playeredx

JE _End
mov eax, edupen
Cmp eax, playeredx
JE _End
mov eax, eddownen
Cmp eax, playeredx
JE _End
POP eax
Cmp Sco, 20
JAE _3enemies
Cmp Sco, 10
JAE _2enemies
Jmp _1enemy
_2enemies:
Call Make_Enemies
Call Make_Enemies
Jmp Input
_3enemies:
Call Make_Enemies
Call Make_Enemies
Call Make_Enemies
Jmp Input
_1enemy:
Call Make_Enemies
Jmp Input
_End:
Call clrscr
Call Make_Border
mov edx, 0
mov dh, 7
mov dl, 15
Call Gotoxy
push edx
mov edx,OFFSET str8
call WriteString
pop edx
inc dh
Call Gotoxy
push edx
mov edx,OFFSET str6
call WriteString
mov edx,OFFSET Player
Call WriteString
pop edx
inc dh
Call Gotoxy
push edx
mov edx,OFFSET str7
call WriteString
mov eax, Sco
Call WriteDec
; write to file --- start
lea edx, FileName
call CreateOutputFile
mov FileHandle, eax
; convert number to string --- start
push Sco
push OFFSET fmt
push OFFSET numberstring

call wsprintf
mov numberchar,eax
add esp,(3*4)
mov eax,FileHandle
lea edx,OFFSET numberstring
mov ecx,numberchar
call WriteToFile
mov eax, FileHandle
lea edx, OFFSET Player
mov ecx, LENGTHOF Player
call WriteToFile
mov eax,FileHandle
call CloseFile
; write to file --- end
pop edx
inc dh
Call Gotoxy
Call WaitMsg
Jmp start
_Pause:
Call ReadChar
cmp al, '.'
JE Input
Jmp _Pause
main ENDP
Make_Enemies PROC
push eax
push edx
mov eax, 4
Call RandomRange
cmp eax, 0
JE _upbot
cmp eax, 1
JE _rightbot
cmp eax, 2
JE _downbot
cmp eax, 3
JE _leftbot
_upbot:
cmp up, 1
JE _downbot
mov eax, 37
mov dh, 2
mov dl, 25
Call Gotoxy
mov edupen, edx
Call WriteChar
inc up
Jmp _Cback
_downbot:
cmp down, 1
JE _rightbot
mov eax, 37
mov dh, 18
mov dl, 25
Call gotoxy
mov eddownen, edx
Call WriteChar
inc down

Jmp _Cback
_leftbot:
cmp left, 1
JE _rightbot
mov eax, 37
mov dh, 10
mov dl, 10
Call Gotoxy
mov edleften, edx
Call WriteChar
inc left
Jmp _Cback
_rightbot:
cmp right, 1
JE _Cback
mov eax, 37
mov dh, 10
mov dl, 40
Call Gotoxy
mov edrighten, edx
Call WriteChar
inc right
Jmp _Cback
_Cback:
pop edx
pop eax
ret
Make_Enemies ENDP
Move_Enemies PROC
PUSHAD
mov eax, Sco
cmp Sco, 17
JAE _unchange
cmp Sco, 15
JBE _unchange
inc speed_factor
_unchange:
cmp left, 1
JE mleft
_Restr:
cmp right, 1
JE mright
_Restu:
cmp up, 1
JE mup
_Restd:
cmp down, 1
JE mdown
Jmp _movback
mleft:
mov edx, edleften
mov eax, 32
Call GotoXY
Call WriteChar
add dl, speed_factor
mov eax, 37
Call GotoXY
Call WriteChar
mov edleften, edx

Jmp _Restr
mright:
mov edx, edrighten
mov eax, 32
Call GotoXY
Call WriteChar
sub dl, speed_factor
mov eax, 37
Call GotoXY
Call WriteChar
mov edrighten, edx
Jmp _Restu
mup:
mov edx, edupen
mov eax, 32
Call GotoXY
Call WriteChar
add dh, speed_factor
mov eax, 37
Call GotoXY
Call WriteChar
mov edupen, edx
Jmp _Restd
mdown:
mov edx, eddownen
mov eax, 32
Call GotoXY
Call WriteChar
sub dh, speed_factor
mov eax, 37
Call GotoXY
Call WriteChar
mov eddownen, edx
_movback:
POPAD
ret
Move_Enemies ENDP
Show_Score PROC
PUSHAD
mov edx, 0
mov dl, 51
mov dh, 20
Call Gotoxy
mov edx,OFFSET str7
Call WriteString
mov eax, Sco
Call WriteDec
POPAD
ret
Show_Score ENDP
Shoot PROC
push edx
cmp ah, 'H'
JE _up
cmp ah, 'K'
JE _left
cmp ah, 'M'
JE _right
cmp ah, 'P'

JE _down
_bck:
pop edx
Call Gotoxy
ret
_down:
mov eax, 179
mov ecx, 8
Ldown:
inc dh
Call Gotoxy
Call WriteChar
push eax
mov eax, 300
Call Delay
Call Gotoxy
mov eax, 32
Call WriteChar
pop eax
LOOP Ldown
cmp down, 1
JE incdown
Jmp _bck
_up:
mov eax, 179
mov ecx, 8
Lup:
dec dh
Call Gotoxy
Call WriteChar
push eax
mov eax, 300
Call Delay
Call Gotoxy
mov eax, 32
Call WriteChar
pop eax
LOOP Lup
cmp up, 1
JE incup
Jmp _bck
_left:
mov eax, 60
mov ecx, 15
Lleft:
dec dl
Call Gotoxy
Call WriteChar
push eax
mov eax, 200
Call Delay
Call Gotoxy
mov eax, 32
Call WriteChar
pop eax
LOOP Lleft
cmp left, 1
JE incleft
Jmp _bck

_right:
mov eax, 62
mov ecx, 15
Lright:
inc dl
Call Gotoxy
Call WriteChar
push eax
mov eax, 200
Call Delay
Call Gotoxy
mov eax, 32
Call WriteChar
pop eax
LOOP Lright
cmp right, 1
JE incright
Jmp _bck
incup:
inc Sco
dec up
Jmp _bck
incdown:
inc Sco
dec down
Jmp _bck
incleft:
inc Sco
dec left
Jmp _bck
incright:
inc Sco
dec right
Jmp _bck

Shoot ENDP
Make_Screen PROC
Call Make_Border
mov dl, 25
mov dh, 10
Call GotoXY
mov eax, 219
mov playeredx, edx
Call WriteChar
Call crlf
Call crlf
Call crlf
ret
Make_Screen ENDP
Make_Border PROC
mov ecx, 25
mov dh, 0
mov dl, 0
mov al, '*'
_UBorder:
Call WriteChar
add dl,2
Call Gotoxy
LOOP _UBorder
mov ecx, 23

mov dh, 20
mov dl, 0
Call Gotoxy
_DBorder:
Call WriteChar
add dl,2
Call Gotoxy
LOOP _DBorder
mov ecx, 20
mov dh, 0
mov dl, 49
_RBorder:
Call WriteChar
inc dh
Call Gotoxy
LOOP _RBorder
mov ecx, 20
mov dh, 0
mov dl, 0
_LBorder:
Call WriteChar
inc dh
Call Gotoxy
LOOP _LBorder
ret
Make_Border ENDP
END main