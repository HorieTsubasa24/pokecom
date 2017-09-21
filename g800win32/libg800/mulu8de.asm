;
; •„†‚È‚µ8bitsæZ (DE = D * E)
;
; “ü—Í
; D,E:”’l
;
; o—Í
; DE:Ï
;
mulu8de::
	push AF
	push HL
	ld A, E
	call mulu8
	ex DE, HL
	pop HL
	pop AF
	ret

; eof
