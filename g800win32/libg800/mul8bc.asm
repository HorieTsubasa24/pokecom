;
; ��������8bits��Z (BC = B * C)
;
; ����
; B,C:���l
;
; �o��
; BC:��
;
mul8bc::
	push AF
	push DE
	push HL
	ld D, B
	ld A, C
	call mul8
	ld B, H
	ld C, L
	pop HL
	pop DE
	pop AF
	ret

; eof
