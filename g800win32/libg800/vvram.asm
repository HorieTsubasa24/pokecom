.include "g800.asm"

	.area _CODE
;
; 仮想VRAMの内容を表示する
;
; 入力
; C:更新領域x座標
; B:更新領域y座標
; E:更新領域x座標
; D:更新領域y座標
;
; 出力
; BC,DE,HL:破壊
;
vupdate::
	ld A, #0x40
	out (#0x40), A

	; 開始・終了ROWを求める
	srl B
	srl B
	srl B
	srl D
	srl D
	srl D
	ld A, B
	sub D
	jr NC, skip1
	ld D, B
	neg
skip1:
	add D
	ld L, A

	; 開始x座標と長さを求める
	ld A, C
	sub E
	ld B, A
	ld A, C
	cp E
	jr NC, skip2
	ld A, E
	sub C
	ld B, A
	ld E, C
skip2:
	inc B
	ld C, L

	; 開始仮想VRAMを求める
	push BC
	ld B, #0
	ld C, E
	ld HL, #vram
	add HL, BC
	ld C, #WIDTH
	ld A, D
	or A
loop6:
	jr Z, skip3
	add HL, BC
	dec A
	jr loop6
skip3:
	pop BC

loop1:
	; 描画ROWを設定する
	push BC
	ld C, #0x40
	ld A, D
	or #0xb0
loop2:
	in B, (C)
	rlc B
	jr C, loop2
	out (C), A

	; 描画COL(L)を設定する
	ld A, E
	and #0x0f
loop3:
	in B, (C)
	rlc B
	jr C, loop3
	out (C), A

	; 描画COL(H)を設定する
	ld A, E
	rra
	rra
	rra
	rra
	and #0x0f
	or #0x10
loop4:
	in B, (C)
	jr C, loop4
	out (C), A
	pop BC

	; 1行描画する
	push BC
	push HL
loop5:
	ld A, (HL)
	inc HL
	out (#0x41), A
	djnz loop5
	pop HL
	ld BC, #WIDTH
	add HL, BC
	pop BC

	; 次のROWに移る
	inc D
	ld A, C
	sub D
	jr NC, loop1

	ret

;
; 仮想VRAMを消去する
;
; 入力なし
;
; 出力
; BC,DE,HL:破壊
;
vclear::
	ld DE, #vram
	ld BC, #WIDTH
	ld HL, #blank
	ldir
	ld BC, #WIDTH
	ld HL, #vram
	ldir
	ld BC, #WIDTH * 2
	ld HL, #vram
	ldir
	ld BC, #WIDTH * 2
	ld HL, #vram
	ldir
	ret
blank:
	.db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	.db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	.db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	.db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	.db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	.db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	.db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	.db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	.db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	.db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	.db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	.db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	.db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	.db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	.db 0, 0, 0, 0

;
; 仮想VRAM上のアドレスを得る
;
; 入力
; D:y座標
; E:x座標
;
; 出力
; A:マスク HL:アドレス
; F,DE:破壊
;
vaddress::
	push BC

	ld A, D
	and #0x07
	ld B, #0
	ld C, A
	ld HL, #vmask_table
	add HL, BC
	ld A, (HL)
vaddress0::
	ld HL, #vram
	ld BC, #WIDTH
	srl D
	srl D
	srl D
	jr Z, vaddress_skip1
	add HL, BC
	dec D
	jr Z, vaddress_skip1
	add HL, BC
	dec D
	jr Z, vaddress_skip1
	add HL, BC
	dec D
	jr Z, vaddress_skip1
	add HL, BC
	dec D
	jr Z, vaddress_skip1
	add HL, BC
	dec D
	jr Z, vaddress_skip1
	add HL, BC
	dec D
	jr Z, vaddress_skip1
	rst #0x30
vaddress_skip1:
	add HL, DE

	pop BC
	ret
vmask_table:
	.db 0x01, 0x02, 0x04, 0x08, 0x10, 0x20, 0x40, 0x80

	.area _DATA
;
; 仮想VRAM
;
vram::
vram0::
	.ds 144
vram1::
	.ds 144
vram2::
	.ds 144
vram3::
	.ds 144
vram4::
	.ds 144
vram5::
	.ds 144

; eof
