;
; �����Ȃ�8bits���Z (B = C / B, C = C mod B)
;
; ����
; B,C:���l
;
; �o��
; B:��
; C:�]��
;
divu8bc::
	push AF
	push DE
	push HL
	ld L, C
	ld D, B
	call divu8
	ld B, A
	ld C, L
	pop HL
	pop DE
	pop AF
	ret

; eof
