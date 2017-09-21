;
; •„†‚È‚µ8bitsæZ (BC = B * C)
;
; “ü—Í
; B,C:”’l
;
; o—Í
; BC:Ï
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
