;
; �����Ȃ�8bits���Z (H = L / H, L = L mod H)
;
; ����
; H,L:���l
;
; �o��
; H:��
; L:�]��
;
divu8hl::
	push AF
	push DE
	ld D, H
	call divu8
	ld H, A
	pop DE
	pop AF
	ret

; eof
