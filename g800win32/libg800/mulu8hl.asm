;
; �����Ȃ�8bits��Z (HL = H * L)
;
; ����
; H,L:���l
;
; �o��
; HL:��
;
mulu8hl::
	push AF
	push DE
	ld D, H
	ld A, L
	call mulu8
	pop DE
	pop AF
	ret

; eof
