;
; Θ΅8bitsZ (A = L / D, L = L mod D)
;
; όΝ
; D, L:l
;
; oΝ
; A:€
; L:]θ
; F,DE:jσ
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
