Include irvine32.inc
Include macros.inc

.data
answer_max_length = 80
answer byte answer_max_length dup(?)
answerlength byte ?
score byte 0
randomArray byte 15 dup(0)

.code

randomArrayGenerator PROC

.data
count byte 0

.code
push ecx
push eax
push ebx
push esi

mov ecx, 15
mov ebx, 0
mov eax, 0
mov esi, edx

l1:
	inc ebx
	push ecx
	push edx
	
	do:
		mov count, 0
		mov eax, 30
		call Randomize
		call RandomRange
		add eax, 1
		mov ecx, ebx
		mov edx, esi
		l2:
		cmp al, [edx]
		jne finish
		add count, 1
		

		
		finish:
		inc edx
		loop l2
		
	cmp count, 0
	jne do
	
	pop edx
	mov [edx],al
	pop ecx
	inc edx
loop l1

pop esi
pop ebx
pop eax
pop ecx
ret
randomArrayGenerator ENDP

saveScore PROC
.data
buffer BYTE 'Score: ',0,0,0dh,0ah
bufSize DWORD ($-buffer)
errMsg BYTE "Cannot open file",0dh,0ah,0
filename     BYTE 50 dup (?)
fileHandle   HANDLE ?			; handle to output file
bytesWritten DWORD ?    			; number of bytes written

.code
mWrite <0dh,0ah,'-->> Please enter your name: '>
mov edx, offset filename
mov ecx, 50 ; maximum str length
call readstring

mov filename[eax], '.'
mov filename[eax + 1], 't'
mov filename[eax + 2], 'x'
mov filename[eax + 3], 't'
mov filename[eax + 4], 0


cmp ebx, 10
je append10
add bl, 48
mov buffer[8], bl
jmp appendnum


append10:
mov buffer[8], 49
mov buffer[9], 48




appendnum:
	INVOKE CreateFile,
	  ADDR filename, GENERIC_WRITE, DO_NOT_SHARE, NULL,
	  OPEN_ALWAYS, FILE_ATTRIBUTE_NORMAL, 0

	mov fileHandle,eax			; save file handle
	.IF eax == INVALID_HANDLE_VALUE
	  mov  edx,OFFSET errMsg		; Display error message
	  call WriteString
	  jmp  QuitNow
	.ENDIF

	; Move the file pointer to the end of the file
	INVOKE SetFilePointer,
	  fileHandle,0,0,FILE_END

	; Append text to the file
	INVOKE WriteFile,
	    fileHandle, ADDR buffer, bufSize,
	    ADDR bytesWritten, 0

	INVOKE CloseHandle, fileHandle

QuitNow:

ret
saveScore ENDP

main PROC



start:
call clear_screen
mWrite<'-->> Which questions do you want to practice?',0dh,0ah>
mWrite<'1. Fill in the blanks.',0dh,0ah>
mWrite<'2. Multiple Choice Questions.',0dh,0ah>

call readint

.if al == 1
call FIBTEST
.else
call MCQTEST
.endif





quit:
mWrite<"Your Score: ">
movzx eax, score
call writeint

mov ebx, 0
mov bl, score
call saveScore

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
A11 byte 'I',0
A12 byte 'it',0
A13 byte 'he',0
A14 byte 'nobody',0
A15 byte 'who',0
A16 byte 'burns',0
A17 byte 'cold',0
A18 byte 'guilty',0
A19 byte 'opens',0
A20 byte 'see',0
A21 byte 'now',0
A22 byte 'once',0
A23 byte 'away',0
A24 byte 'hard',0
A25 byte 'better',0
A26 byte 'in',0
A27 byte 'of',0
A28 byte 'off',0
A29 byte 'for',0
A30 byte 'along',0
A31 byte 'and',0
A32 byte 'but',0
A33 byte 'or',0
A34 byte 'and',0
A35 byte 'only',0
A36 byte 'alas',0
A37 byte 'of',0
A38 byte 'hush',0
A39 byte 'hurrah',0
A40 byte 'bravo',0

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
cmp eax, 11
je q11
cmp eax, 12
je q12
cmp eax, 13
je q13
cmp eax, 14
je q14
cmp eax, 15
je q15
cmp eax, 16
je q16
cmp eax, 17
je q17
cmp eax, 18
je q18
cmp eax, 19
je q19
cmp eax, 20
je q20
cmp eax, 21
je q21
cmp eax, 22
je q22
cmp eax, 23
je q23
cmp eax, 24
je q24
cmp eax, 25
je q25
cmp eax, 26
je q26
cmp eax, 27
je q27
cmp eax, 28
je q28
cmp eax, 29
je q29
cmp eax, 30
je q30
cmp eax, 31
je q31
cmp eax, 32
je q32
cmp eax, 33
je q33
cmp eax, 34
je q34
cmp eax, 35
je q35
cmp eax, 36
je q36
cmp eax, 37
je q37
cmp eax, 38
je q38
cmp eax, 39
je q39
cmp eax, 40
je q40



q1:
	mWrite<"Lahore is capital of ...">
	mov edi, offset a1
	mov ebx, lengthof a1
	jmp fibEnd
q2:
	mWrite<"A collection of ships is called ...">
	mov edi, offset a2
	mov ebx, lengthof a2
	jmp fibEnd
q3:
	mWrite<"Sit down and rest a ...">
	mov edi, offset a3
	mov ebx, lengthof a3
	jmp fibEnd
q4:
	mWrite<"Pulao is made of ...">
	mov edi, offset a4
	mov ebx, lengthof a4
	jmp fibEnd
q5:
	mWrite<"The ... sank in the ocean.">
	mov edi, offset a5
	mov ebx, lengthof a5
	jmp fibEnd
q6:
	mWrite<"I ate ... rice">
	mov edi, offset a6
	mov ebx, lengthof a6
	jmp fibEnd
q7:
	mWrite<"The ... old crow tried to sing.">
	mov edi, offset a7
	mov ebx, lengthof a7
	jmp fibEnd
q8:
	mWrite<"... cats like cold water.">
	mov edi, offset a8
	mov ebx, lengthof a8
	jmp fibEnd
q9:
	mWrite<"Don't be in ... a haste.">
	mov edi, offset a9
	mov ebx, lengthof a9
	jmp fibEnd
q10:
	mWrite<"Mind your ... business.">
	mov edi, offset a10
	mov ebx, lengthof a10
	jmp fibEnd

q11:
mWrite< "... am young">
mov edi,offset a11
mov ebx,lengthof a11
jmp fibEnd



q12:
mWrite< "... is ten o'clock">
mov edi,offset a12
mov ebx,lengthof a12
jmp fibEnd



q13:
mWrite< "... hurt himself">
mov edi,offset a13
mov ebx,lengthof a13
jmp fibEnd



q14:
mWrite<"... was there to rescue the child">
mov edi,offset a14
mov ebx,lengthof a14
jmp fibEnd


q15:
mWrite<"I met Ali,... was in our class last year">
mov edi,offset a15
mov ebx,lengthof a15
jmp fibEnd

;VERB

q16:
mWrite<"The fire ... dimly">
mov edi,offset a16
mov ebx,lengthof a16
jmp fibEnd

q17:
mWrite<"The wind is ... as temperature is low">
mov edi,offset a17
mov ebx,lengthof a17
jmp fibEnd

q18:
mWrite<"The jury found him ...">
mov edi,offset a18
mov ebx,lengthof a18
jmp fibEnd

q19:
mWrite<"The show ... at six o'clock">
mov edi,offset a19
mov ebx,lengthof a19
jmp fibEnd

q20:
mWrite<"We ... with our eyes">
mov edi,offset a20
mov ebx,lengthof a20
jmp fibEnd

;ADVERB

q21:
mWrite<"We shall ... begin to work">
mov edi,offset a21
mov ebx,lengthof a21
jmp fibEnd

q22:
mWrite<"I have not seen him ...">
mov edi,offset a22
mov ebx,lengthof a22
jmp fibEnd

q23:
mWrite<" The horse galloped ...">
mov edi,offset a23
mov ebx,lengthof a23
jmp fibEnd

q24:
mWrite<"The boy works ...">
mov edi,offset a24
mov ebx,lengthof a24
jmp fibEnd

q25:
mWrite<"He is feeling ... now">
mov edi,offset a25
mov ebx,lengthof a25
jmp fibEnd

q26:
mWrite< "There is a cow ... the field">
mov edi,offset a26
mov ebx,lengthof a26
jmp fibEnd

q27:
 mWrite<"He is fond ... tea">
mov edi,offset a27
mov ebx,lengthof a27
jmp fibEnd

q28:
mWrite<"The cat jumped ... the chair">
mov edi,offset a28
mov ebx,lengthof a28
jmp fibEnd

q29:
mWrite<"What are you looking ...">
mov edi,offset a29
mov ebx,lengthof a29
jmp fibEnd

q30:
mWrite<"Why dont you go ... your brother">
mov edi,offset a30
mov ebx,lengthof a30
jmp fibEnd

;CONJUNCTIONS 

q31:
mWrite<"God made the country ... manmade the town">
mov edi,offset a31
mov ebx,lengthof a31
jmp fibEnd

q32:
mWrite<"Our hoard is little ... our hearts are great">
mov edi,offset a32
mov ebx,lengthof a32
jmp fibEnd

q33:
mWrite<"She must weep,... she will die">
mov edi,offset a33
mov ebx,lengthof a33
jmp fibEnd

q34:
mWrite<"Two ... two make four">
mov edi,offset a34
mov ebx,lengthof a34
jmp fibEnd

q35:
mWrite<"I would come; ... that i am engaged">
mov edi,offset a35
mov ebx,lengthof a35
jmp fibEnd

q36:

mWrite<"...! he is dead">
mov edi,offset a36
mov ebx,lengthof a36
jmp fibEnd


q37:
mWrite<"...! I got such a fright">
mov edi,offset a37
mov ebx,lengthof a37
jmp fibEnd


q38:
mWrite<"...! dont make a noise">
mov edi,offset a38
mov ebx,lengthof a38
jmp fibEnd

q39:
mWrite<"...! we have won the match">
mov edi,offset a39
mov ebx,lengthof a39
jmp fibEnd


q40:
mWrite<"...!you performed great">
mov edi,offset a40
mov ebx,lengthof a40
jmp fibEnd

fibEND:
mWrite<0dh, 0ah>
ret
FIB ENDP


FIBTEST PROC
call clear_screen
mov edx, offset randomArray
call randomArrayGenerator




mov score,0
mov ecx, 10
mov ebx, 0
mov eax, 0

mov esi, offset randomArray
questioning:
push esi
push ebx
mWrite<"Q. ">
mov al, [esi]
movzx eax, al
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
pop esi

inc esi
dec ecx
cmp ecx, 0
jne questioning

ret
FIBTEST ENDP



MCQTEST PROC
.data

;answer byte ?
.code




mWrite<'Choose an appropriate word from the options to suitably fill the blank in the sentence below so that the sentence makes sense, both grammatically and contextually.',0dh,0ah>
mov eax, 1
call MCQs
mov ebx, eax

call readchar


;and al, 11011111b
cmp al, bl
jne wrong
mWrite<'Correct!',0dh, 0ah>
jmp next

wrong:
mWrite<'Wrong!',0dh, 0ah>


next:
ret 
MCQTEST ENDP


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
cmp eax, 11
je q11
cmp eax, 12
je q12
cmp eax, 13
je q13
cmp eax, 14
je q14
cmp eax, 15
je q15
cmp eax, 16
je q16
cmp eax, 17
je q17
cmp eax, 18
je q18
cmp eax, 19
je q19
cmp eax, 20
je q20
cmp eax, 21
je q21
cmp eax, 22
je q22
cmp eax, 23
je q23
cmp eax, 24
je q24


q1:
; printing the question

mWrite<'Our country is spiritual country, theirs . . . . . . religious.', 0dh, 0ah>
mWrite<'A. is', 0dh, 0ah>
mWrite<'B. are', 0dh, 0ah>
mWrite<'C. also',0dh, 0ah>
mWrite<'D. have',0dh,0ah>


; mov the answer option in eax
mov eax, 'A'

jmp MCQEND

q2:
mWrite<'... he does is up to him', 0dh, 0ah>
mWrite<'A. how', 0dh, 0ah>
mWrite<'B. why', 0dh, 0ah>
mWrite<'C. what',0dh, 0ah>
mWrite<'D. which',0dh,0ah>
mov eax, 'C'
jmp MCQEND

q3:
mWrite<'The news ... the general has been captured is true', 0dh, 0ah>
mWrite<'A. that ', 0dh, 0ah>
mWrite<'B. how ', 0dh, 0ah>
mWrite<'C. what ',0dh, 0ah>
mWrite<'D. which ',0dh,0ah>
mov eax, 'A'
jmp MCQEND

q4:
mWrite<'Could you talk ...', 0dh, 0ah>
mWrite<'A. quitelier ', 0dh, 0ah>
mWrite<'B. more quietly', 0dh, 0ah>
mWrite<'C. quitely',0dh, 0ah>
mWrite<'D. none',0dh,0ah>
mov eax, 'C'
jmp MCQEND
q5:
mWrite<'Can you drive any ...', 0dh, 0ah>
mWrite<'A. fast ', 0dh, 0ah>
mWrite<'B. fastest ', 0dh, 0ah>
mWrite<'C. faster ',0dh, 0ah>
mWrite<'D. none ',0dh,0ah>
mov eax, 'C'
jmp MCQEND
q6:
mWrite<'Your accent is the ... in class', 0dh, 0ah>
mWrite<'A. worst ', 0dh, 0ah>
mWrite<'B. worse ', 0dh, 0ah>
mWrite<'C. worster',0dh, 0ah>
mWrite<'D. worsetest',0dh,0ah>
mov eax, 'A'
jmp MCQEND
q7:
mWrite<'Find out from ... when she will be back', 0dh, 0ah>
mWrite<'A. her', 0dh, 0ah>
mWrite<'B. she', 0dh, 0ah>
mWrite<'C. hers',0dh, 0ah>
mWrite<'D. herself',0dh,0ah>
mov eax, 'A'
jmp MCQEND
q8:
mWrite<'If you can not find your book, you can borrow...', 0dh, 0ah>
mWrite<'A. mine ', 0dh, 0ah>
mWrite<'B. me ', 0dh, 0ah>
mWrite<'C. myself ',0dh, 0ah>
mWrite<'D. my ',0dh,0ah>
mov eax, 'A'
jmp MCQEND
q9:
mWrite<'The little boy tied his shoelaces...', 0dh, 0ah>
mWrite<'A. himself', 0dh, 0ah>
mWrite<'B. him ', 0dh, 0ah>
mWrite<'C. his',0dh, 0ah>
mWrite<'D. he',0dh,0ah>
mov eax, 'A'
jmp MCQEND
q10:
mWrite<' Could you turn ... the TV? The soap opera is about to start.', 0dh, 0ah>
mWrite<'A. on', 0dh, 0ah>
mWrite<'B. off', 0dh, 0ah>
mWrite<'C. out',0dh, 0ah>
mWrite<'D. back',0dh,0ah>
mov eax, 'A'
jmp MCQEND


q11:
mWrite<'There was nothing good on TV so I turned it ... and went to bed.', 0dh, 0ah>
mWrite<'A. in ', 0dh, 0ah>
mWrite<'B. up ', 0dh, 0ah>
mWrite<'C. off ',0dh, 0ah>
mWrite<'D. down ',0dh,0ah>
mov eax, 'C'
jmp MCQEND




q12:
mWrite<' I´ve been looking ... my car keys for half an hour. Have you seen them anywhere?', 0dh, 0ah>
mWrite<'A. at ', 0dh, 0ah>
mWrite<'B. up', 0dh, 0ah>
mWrite<'C. for ',0dh, 0ah>
mWrite<'D. after ',0dh,0ah>
mov eax, 'C'
jmp MCQEND




q13:
mWrite<'What is the adverb in the sentence? Peter neatly wrote a shopping list.', 0dh, 0ah>
mWrite<'A. neatly', 0dh, 0ah>
mWrite<'B. wrote ', 0dh, 0ah>
mWrite<'C. shopping',0dh, 0ah>
mWrite<'D. list ',0dh,0ah>
mov eax, 'A'
jmp MCQEND



q14:
mWrite<'What is the adverb in the sentence? The students nervously did their test.', 0dh, 0ah>
mWrite<'A. students', 0dh, 0ah>
mWrite<'B. nervously ', 0dh, 0ah>
mWrite<'C. their ',0dh, 0ah>
mWrite<'D. test ',0dh,0ah>
mov eax, 'B'
jmp MCQEND




q15:
mWrite<'Which adverb best completes the sentence? She ... put the baby on the bed.', 0dh, 0ah>
mWrite<'A. quick ', 0dh, 0ah>
mWrite<'B. happyful ', 0dh, 0ah>
mWrite<'C. carefully ',0dh, 0ah>
mWrite<'D. did ',0dh,0ah>
mov eax, 'C'
jmp MCQEND



q16:
mWrite<'The local team scored three goals ... the first half of the match.', 0dh, 0ah>
mWrite<'A. at ', 0dh, 0ah>
mWrite<'B. for', 0dh, 0ah>
mWrite<'C. in ',0dh, 0ah>
mWrite<'D. on ',0dh,0ah>
mov eax, 'C'
jmp MCQEND



q17:
mWrite<'The island is so small that there are only five houses ... it.', 0dh, 0ah>
mWrite<'A. on ', 0dh, 0ah>
mWrite<'B. in ', 0dh, 0ah>
mWrite<'C. over ',0dh, 0ah>
mWrite<'D. out ',0dh,0ah>
mov eax, 'A'
jmp MCQEND




q18:
mWrite<'Many species of insects were wiped ... when the jungle was cleared', 0dh, 0ah>
mWrite<'A. of', 0dh, 0ah>
mWrite<'B. away ', 0dh, 0ah>
mWrite<'C. off ',0dh, 0ah>
mWrite<'D. out ',0dh,0ah>
mov eax, 'D'
jmp MCQEND


q19:
mWrite<'..., you have get a chance, you might as well make full use of it.', 0dh, 0ah>
mWrite<'A. As soon as', 0dh, 0ah>
mWrite<'B. Now that ', 0dh, 0ah>
mWrite<'C. Although ',0dh, 0ah>
mWrite<'D. After ',0dh,0ah>
mov eax, 'A'
jmp MCQEND




q20:
mWrite<'She has not spoken to us ... we had the argument.', 0dh, 0ah>
mWrite<'A. since ', 0dh, 0ah>
mWrite<'B. while ', 0dh, 0ah>
mWrite<'C. so ',0dh, 0ah>
mWrite<'D. as ',0dh,0ah>
mov eax, 'A'
jmp MCQEND



q21:
mWrite<'... you refuse to pay the ransom, the kidnappers might hurt the child', 0dh, 0ah>
mWrite<'A. Or ', 0dh, 0ah>
mWrite<'B. If ', 0dh, 0ah>
mWrite<'C. Lest',0dh, 0ah>
mWrite<'D. Unless',0dh,0ah>
mov eax, 'B'
jmp MCQEND


q22:
mWrite<"...!Now don't show me your face again.", 0dh, 0ah>
mWrite<'A. Hark ', 0dh, 0ah>
mWrite<'B. Sorry ', 0dh, 0ah>
mWrite<'C. Listen',0dh, 0ah>
mWrite<'D. Out ',0dh,0ah>
mov eax, 'D'
jmp MCQEND



q23:
mWrite<'...!my lord, I feel honoured to welcome you to my humble abode.', 0dh, 0ah>
mWrite<'A. Hey', 0dh, 0ah>
mWrite<'B. Hail', 0dh, 0ah>
mWrite<'C. Ahoy',0dh, 0ah>
mWrite<'D. Adieu',0dh,0ah>
mov eax, 'B'
jmp MCQEND




q24:
mWrite<'...!Let me see if I can get something to pull it out.', 0dh, 0ah>
mWrite<'A. Ha', 0dh, 0ah>
mWrite<'B. O', 0dh, 0ah>
mWrite<'C. Hey',0dh, 0ah>
mWrite<'D. Hold on',0dh,0ah>
mov eax, 'D'
jmp MCQEND



MCQEND:

ret
MCQs ENDp



stringcmp PROC uses ecx
cmp eax,ebx
jne notsame
mov ecx, eax

check:
	mov al, [esi]
	and al, 11011111b
	mov bl, [edi]
	and bl, 11011111b
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
