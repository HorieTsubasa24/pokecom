;
; ��������8bits���Z (A = L / D, L = L mod D)
;
; ����
; D, L:���l
;
; �o��
; A:��
; L:�]��
; F,DE:�j��
;
div8::
	ld A, D
	rla
	jp NC, skip1
	ld A, D
	neg
	ld D, A
skip1:
	rl E

	ld A, L
	rla
	jp NC, skip2
	ld A, L
	neg
	ld L, A
skip2:
	rl E

	push DE
	call divu8
	pop DE

	rr E
	jp NC, skip3
	neg
	ld D, A
	ld A, L
	neg
	ld L, A
	ld A, D
skip3:

	rr E
	jp NC, skip4
	neg
skip4:

	ret

; eof
