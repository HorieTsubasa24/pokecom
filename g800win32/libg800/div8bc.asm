;
; 符号あり8bits除算 (B = C / B, C = C mod B)
;
; 入力
; B,C:数値
;
; 出力
; B:商
; C:余り
;
divu8bc::
	push AF
	push DE
	push HL
	ld L, C
	ld D, B
	call div8
	ld B, A
	ld C, L
	pop HL
	pop DE
	pop AF
	ret

; eof
