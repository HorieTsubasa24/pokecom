;
; �����Ȃ�8bits��Z (BC = B * C)
;
; ����
; B,C:���l
;
; �o��
; BC:��
;
mulu8bc::
	push AF
	push DE
	push HL
	ld D, B
	ld A, C
	call mulu8
	ld B, H
	ld C, L
	pop HL
	pop DE
	pop AF
	ret

; eof
