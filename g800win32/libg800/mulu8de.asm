;
; �����Ȃ�8bits��Z (DE = D * E)
;
; ����
; D,E:���l
;
; �o��
; DE:��
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
