;
; •„†‚ ‚è8bitsæZ (HL = H * L)
;
; “ü—Í
; H,L:”’l
;
; o—Í
; HL:Ï
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
