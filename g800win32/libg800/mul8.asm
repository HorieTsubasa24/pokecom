;
; •„†‚ ‚è8bitsæZ (HL = D * A)
;
; “ü—Í
; A,D:”’l
;
; o—Í
; HL:Ï
; AF,DE:”j‰ó
;
mul8::
	ld HL, #0
	or A
	ret Z
	jp P, skip
	ld E, A
	ld A, D
	neg
	ld D, A
	ld A, E
	neg
skip:
	ld E, L
loop:
	sra D
	rr E
	rl A
	jp NC, loop
	add HL, DE
	jp NZ, loop
	ret

; eof
