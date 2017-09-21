;
; •„†‚È‚µ8bitsœZ (B = C / B, C = C mod B)
;
; “ü—Í
; B,C:”’l
;
; o—Í
; B:¤
; C:—]‚è
;
divu8bc::
	push AF
	push DE
	push HL
	ld L, C
	ld D, B
	call divu8
	ld B, A
	ld C, L
	pop HL
	pop DE
	pop AF
	ret

; eof
