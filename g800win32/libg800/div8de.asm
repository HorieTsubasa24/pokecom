;
; •„†‚ ‚è8bitsœZ (D = E / D, E = E mod D)
;
; “ü—Í
; D,E:”’l
;
; o—Í
; D:¤
; E:—]‚è
;
div8de::
	push AF
	push HL
	ld L, E
	call div8
	ld D, A
	ld E, L
	pop HL
	pop AF
	ret

; eof