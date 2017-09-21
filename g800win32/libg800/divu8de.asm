;
; •„†‚È‚µ8bitsœZ (D = E / D, E = E mod D)
;
; “ü—Í
; D,E:”’l
;
; o—Í
; D:¤
; E:—]‚è
;
divu8de::
	push AF
	push HL
	ld L, E
	call divu8
	ld D, A
	ld E, L
	pop HL
	pop AF
	ret

; eof