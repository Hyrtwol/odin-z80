	.ORG 	0000h
;

	LD	A,12	   	; cls ASCII code
	OUT	(1),a 		; Output to serial port
;
	LD	HL,line1	; Address of line in HL
	CALL	printline	; Print hello world
;
; Print an ASCII Table with 96 Characters
;
	LD	B,96		; 96 characters
	LD 	A,32		; Start at space = 32 in ASCII code
loop2:
	OUT	(1),A		; Output to serial port
	ADD 	A,1		; Next ASCII Character
	CP 	B		; Check for end loop
	JR 	NZ,loop2	; Keep looping until b == 0
;
	HALT			; Stop the program
;
; ---------------------------------
; Routine to print out a line in (hl)
; --------------------------------
printline:
	LD	A,(HL)	   	; Get char to print
	CP	'$'	   	; Check '$' terminator
	JP	Z,printend    	; if equal jmp to end
;
	OUT	(1),A		; Output char to terminal
	INC	HL 	   	; Next char
	JP	printline	; Loop
printend:
	RET

;-------------------
; Data
; ------------------

; 13 is newline character we mark en of line
; with $ character

line1:	.DB	"Hello World",13, 10, 13, 10,'$'

	.END
