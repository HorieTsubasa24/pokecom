;
; ��������8bits��Z (DE = D * E)
;
; ����
; D,E:���l
;
; �o��
; DE:��
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
