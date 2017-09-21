;
; •„†‚È‚µ8bitsœZ (A = L / D, L = L mod D)
;
; “ü—Í
; D, L:”’l
;
; o—Í
; A:¤
; L:—]‚è
; F,DE:”j‰ó
;
divu8::
	xor A
	ld H, A
	ld E, A
	inc A
	
loop:
	srl D
	rr E
	sbc HL, DE
	jp NC, skip
	add HL, DE
skip:
	rla
	jp NC, loop

	cpl
	ret

; eof
