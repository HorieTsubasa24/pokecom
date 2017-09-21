;
; 符号なし8bits除算 (H = L / H, L = L mod H)
;
; 入力
; H,L:数値
;
; 出力
; H:商
; L:余り
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
