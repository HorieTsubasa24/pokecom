;
; Θ΅8bitsζZ (HL = D * A)
;
; όΝ
; A,D:l
;
; oΝ
; HL:Ο
; AF,DE:jσ
;
mulu8::
	ld HL, #0
	or A
	ret Z
	ld E, L
mulu8_loop:
	srl D
	rr E
	rl A
	jp NC, mulu8_loop
	add HL, DE
	jp NZ, mulu8_loop
	ret

; eof
