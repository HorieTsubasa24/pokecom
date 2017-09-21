;
; •„†‚ ‚è8bitsæZ (DE = D * E)
;
; “ü—Í
; D,E:”’l
;
; o—Í
; DE:Ï
;
mul8de::
	push AF
	push HL
	ld A, E
	call mul8
	ex DE, HL
	pop HL
	pop AF
	ret

; eof
