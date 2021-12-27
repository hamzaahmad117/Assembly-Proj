Include irvine32.inc
Include macros.inc

.data
answer_max_length = 80
answer byte answer_max_length dup(?)
answerlength byte ?
score byte 0

.code

scoreSave PROC
BUFFER_SIZE = 501
.data
;buffer BYTE BUFFER_SIZE DUP(0)
;buffer byte 'HighScore: ',?,0

buffer byte 50 dup(0)

filename     BYTE 50 dup(?)
fileHandle   HANDLE ?
stringLength DWORD ?
bytesWritten DWORD ?
str1 BYTE "Cannot create file",0dh,0ah,0
str2 BYTE "Bytes written to file [output.txt]: ",0
str3 BYTE "Enter up to 500 characters and press "
     BYTE "[Enter]: ",0dh,0ah,0

.code
mWrite<"Enter name: ">
mov edx, offset filename
mov ecx, 50
call readstring

mov filename[eax], '.'
mov filename[eax+1], 't'
mov filename[eax+2], 'x'
mov filename[eax+3], 't'
mov filename[eax+4], 0


; Create a new text file.
	mov	edx,OFFSET filename
	call	CreateOutputFile
	mov	fileHandle,eax

; Check for errors.
	cmp	eax, INVALID_HANDLE_VALUE	; error found?
	jne	file_ok					; no: skip
	mov	edx,OFFSET str1			; display error
	call	WriteString
	jmp	quit
file_ok:

Comment !
; Ask the user to input a string.
	mov	edx,OFFSET str3		; "Enter up to ...."
	call	WriteString
	mov	ecx,BUFFER_SIZE		; Input a string
	mov	edx,OFFSET buffer

	call	ReadString
	mov	stringLength,eax		; counts chars entered

	!

	mov buffer[0], bl
; Write the buffer to the output file.
	mov	eax,fileHandle
	mov	edx,OFFSET buffer
	mov	ecx, buffer_SIze
	call	WriteToFile
	mov	bytesWritten,eax		; save return value
	call	CloseFile
	
	
; Display the return value.
	mWrite<"Bytes written to file ">
	mov edx, offset filename
	mWrite<": ">
	call	WriteString
	mov	eax,bytesWritten
	call	WriteDec
	call	Crlf

	
	
quit:
ret
scoreSave ENDP

main PROC



start:
call clear_screen
mov score,0
mov ecx, 10
mov ebx, 0
mov eax, 0

questioning:
inc ebx
push ebx
mWrite<"Q. ">
mov eax, ebx
call FIB

push ecx
mov edx, offset answer
mov ecx, answer_max_length
mWrite<"Your Answer: ",0>
call readstring


mov answerlength, al
add answerlength, 1



mov esi, offset answer
movzx eax, answerlength


call stringcmp

cmp eax, 1
jne wrong

inc score
mWrite<"Correct!",0dh,0ah>
call readchar
jmp next


wrong:
mwrite<"Wrong!", 0dh, 0ah>
call readchar

next:
pop ecx
call clear_screen


; loop
pop ebx
dec ecx
cmp ecx, 0
jne questioning


quit:
mWrite<"Your Score: ">
movzx eax, score
call writeint

mWrite<0dh,0ah,"Play Again? (Y/N): ">
call readchar

.if al == 'y' || al == 'Y'
jmp start

.endif

;movzx ebx, score
;call scoreSave

exit
main ENDP


; returns the answer of the blank in the variable whose offset was stored in edx
; question no. to be moved in eax

FIB PROC
.data
;answers
A1 byte 'punjab',0
A2 byte 'fleet',0
A3 byte  'while',0
A4 byte 'rice',0
A5 byte 'ship',0
A6 byte 'some',0
A7 byte 'foolish',0
A8 byte 'few',0
A9 byte 'such',0
A10 byte 'own',0

.code
cmp eax, 1
je q1
cmp eax, 2
je q2
cmp eax, 3
je q3
cmp eax, 4
je q4
cmp eax, 5
je q5
cmp eax, 6
je q6
cmp eax, 7
je q7
cmp eax, 8
je q8
cmp eax, 9
je q9
cmp eax, 10
je q10


q1:
	mWrite<"Lahore is capital of ...", 0dh, 0ah>
	mov edi, offset a1
	mov ebx, lengthof a1
	jmp fibEnd
q2:
	mWrite<"A collection of ships is called ...", 0dh, 0ah>
	mov edi, offset a2
	mov ebx, lengthof a2
	jmp fibEnd
q3:
	mWrite<"Sit down and rest a ...", 0dh, 0ah>
	mov edi, offset a3
	mov ebx, lengthof a3
	jmp fibEnd
q4:
	mWrite<"Pulao is made of ...", 0dh, 0ah>
	mov edi, offset a4
	mov ebx, lengthof a4
	jmp fibEnd
q5:
	mWrite<"The ... sank in the ocean.", 0dh, 0ah>
	mov edi, offset a5
	mov ebx, lengthof a5
	jmp fibEnd
q6:
	mWrite<"I ate ... rice", 0dh, 0ah>
	mov edi, offset a6
	mov ebx, lengthof a6
	jmp fibEnd
q7:
	mWrite<"The ... old crow tried to sing.", 0dh, 0ah>
	mov edi, offset a7
	mov ebx, lengthof a7
	jmp fibEnd
q8:
	mWrite<"... cats like cold water.", 0dh, 0ah>
	mov edi, offset a8
	mov ebx, lengthof a8
	jmp fibEnd
q9:
	mWrite<"Don't be in ... a haste.", 0dh, 0ah>
	mov edi, offset a9
	mov ebx, lengthof a9
	jmp fibEnd
q10:
	mWrite<"Mind your ... business.", 0dh, 0ah>
	mov edi, offset a10
	mov ebx, lengthof a10
	jmp fibEnd

fibEND:
ret
FIB ENDP


MCQs PROC
cmp eax, 1
je q1
cmp eax, 2
je q2
cmp eax, 3
je q3
cmp eax, 4
je q4
cmp eax, 5
je q5
cmp eax, 6
je q6
cmp eax, 7
je q7
cmp eax, 8
je q8
cmp eax, 9
je q9
cmp eax, 10
je q10

q1:

q2:

q3:

q4:

q5:

q6:

q7:

q8:

q9:

q10:





ret
MCQs ENDp



stringcmp PROC uses ecx
cmp eax,ebx
jne notsame
mov ecx, eax

check:
	mov al, [esi]
	mov bl, [edi]
	cmp al, bl
	jne notsame
	inc esi
	inc edi
loop check
mov eax, 1
jmp same


notsame:
mov eax, 0

same:
ret
stringcmp ENDP


clear_screen PROC uses ecx
.data
blanks byte 1000 dup(" ")

.code
mov dh,0
mov dl,0
call gotoxy
mov ecx, 40

clearinglines:
mov edx, offset blanks
call writestring
call crlf
loop clearinglines

mov dl,0
mov dh, 0
call gotoxy

ret 
clear_screen ENDP

END main