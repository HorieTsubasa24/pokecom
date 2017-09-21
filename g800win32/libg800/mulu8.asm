;
; •„†‚È‚µ8bitsæZ (HL = D * A)
;
; “ü—Í
; A,D:”’l
;
; o—Í
; HL:Ï
; AF,DE:”j‰ó
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
