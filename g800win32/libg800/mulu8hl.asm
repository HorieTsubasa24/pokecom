;
; Θ΅8bitsζZ (HL = H * L)
;
; όΝ
; H,L:l
;
; oΝ
; HL:Ο
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
