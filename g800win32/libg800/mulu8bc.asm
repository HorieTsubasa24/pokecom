;
; Θ΅8bitsζZ (BC = B * C)
;
; όΝ
; B,C:l
;
; oΝ
; BC:Ο
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
