;
; Θ΅8bitsζZ (DE = D * E)
;
; όΝ
; D,E:l
;
; oΝ
; DE:Ο
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
