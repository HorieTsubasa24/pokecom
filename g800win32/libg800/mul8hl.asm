;
;  θ8bitsζZ (HL = H * L)
;
; όΝ
; H,L:l
;
; oΝ
; HL:Ο
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
