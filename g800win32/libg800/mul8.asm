;
;  θ8bitsζZ (HL = D * A)
;
; όΝ
; A,D:l
;
; oΝ
; HL:Ο
; AF,DE:jσ
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
