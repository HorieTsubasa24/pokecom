;
; �����Ȃ�8bits���Z (A = L / D, L = L mod D)
;
; ����
; D, L:���l
;
; �o��
; A:��
; L:�]��
; F,DE:�j��
;
divu8::
	xor A
	ld H, A
	ld E, A
	inc A
	
loop:
	srl D
	rr E
	sbc HL, DE
	jp NC, skip
	add HL, DE
skip:
	rla
	jp NC, loop

	cpl
	ret

; eof
