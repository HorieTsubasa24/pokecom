;
;  θ8bitsζZ (DE = D * E)
;
; όΝ
; D,E:l
;
; oΝ
; DE:Ο
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
