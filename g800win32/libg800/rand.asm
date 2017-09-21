;
; 線形合同法による乱数生成
;
; 入力
; なし
;
; 出力
; A: 乱数
; F: 破壊
;
; 備考
; x[i] = (261 * x[i - 1] + 1) mod 65536
;      = (256 * x[i - 1] + 1 + 5 * x[i - 1]) mod 65536
;
rand::
	push DE
	push HL
	ld DE, (rand_value16)
	ld H, E
	ld L, #1
	add HL, DE
	add HL, DE
	add HL, DE
	add HL, DE
	add HL, DE
	ld A, H
	ld (rand_value16), HL
	pop HL
	pop DE
	ret

;
; 乱数シードを設定する
;
; 入力
; HL: 乱数シード
;
; 出力
; なし
;
srand::
	ld (rand_value16), HL
	ret

rand_value16:
	.db 0xff
rand_value8:
	.db 0xff

; eof
