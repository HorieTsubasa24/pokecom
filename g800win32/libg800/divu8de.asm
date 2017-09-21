;
; 符号なし8bits除算 (D = E / D, E = E mod D)
;
; 入力
; D,E:数値
;
; 出力
; D:商
; E:余り
;
divu8de::
	push AF
	push HL
	ld L, E
	call divu8
	ld D, A
	ld E, L
	pop HL
	pop AF
	ret

; eof