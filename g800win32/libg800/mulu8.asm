;
; �����Ȃ�8bits��Z (HL = D * A)
;
; ����
; A,D:���l
;
; �o��
; HL:��
; AF,DE:�j��
;
mulu8::
	ld HL, #0
	or A
	ret Z
	ld E, L
mulu8_loop:
	srl D
	rr E
	rl A
	jp NC, mulu8_loop
	add HL, DE
	jp NZ, mulu8_loop
	ret

; eof
