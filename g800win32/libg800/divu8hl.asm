;
; •„†‚È‚µ8bitsœZ (H = L / H, L = L mod H)
;
; “ü—Í
; H,L:”’l
;
; o—Í
; H:¤
; L:—]‚è
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
