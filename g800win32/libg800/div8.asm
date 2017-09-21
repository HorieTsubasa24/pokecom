;
; •„†‚ ‚è8bitsœZ (A = L / D, L = L mod D)
;
; “ü—Í
; D, L:”’l
;
; o—Í
; A:¤
; L:—]‚è
; F,DE:”j‰ó
;
div8::
	ld A, D
	rla
	jp NC, skip1
	ld A, D
	neg
	ld D, A
skip1:
	rl E

	ld A, L
	rla
	jp NC, skip2
	ld A, L
	neg
	ld L, A
skip2:
	rl E

	push DE
	call divu8
	pop DE

	rr E
	jp NC, skip3
	neg
	ld D, A
	ld A, L
	neg
	ld L, A
	ld A, D
skip3:

	rr E
	jp NC, skip4
	neg
skip4:

	ret

; eof
