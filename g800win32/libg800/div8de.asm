;
; ��������8bits���Z (D = E / D, E = E mod D)
;
; ����
; D,E:���l
;
; �o��
; D:��
; E:�]��
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