;
; ��������8bits���Z (H = L / H, L = L mod H)
;
; ����
; H,L:���l
;
; �o��
; H:��
; L:�]��
;
div8hl::
	push AF
	push DE
	ld D, H
	call div8
	ld H, A
	pop DE
	pop AF
	ret

; eof