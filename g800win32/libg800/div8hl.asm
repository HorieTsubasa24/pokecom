;
; 符号あり8bits除算 (H = L / H, L = L mod H)
;
; 入力
; H,L:数値
;
; 出力
; H:商
; L:余り
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