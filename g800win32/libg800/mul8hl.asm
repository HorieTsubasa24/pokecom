;
; ��������8bits��Z (HL = H * L)
;
; ����
; H,L:���l
;
; �o��
; HL:��
;
mul8hl::
	push AF
	push DE
	ld D, H
	ld A, L
	call mul8
	pop DE
	pop AF
	ret

; eof
