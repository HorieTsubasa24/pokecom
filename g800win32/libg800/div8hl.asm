;
; •„†‚ ‚è8bitsœZ (H = L / H, L = L mod H)
;
; “ü—Í
; H,L:”’l
;
; o—Í
; H:¤
; L:—]‚è
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