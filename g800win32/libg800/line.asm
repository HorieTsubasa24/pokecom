.include "g800.asm"

;
; 線分を描く
;
; 入力
; D:線分始点y座標
; E:線分始点x座標
; B:線分終点y座標
; C:線分終点x座標
;
; 出力
; AF,BC,DE,HL,AF':破壊
;
line::
	; dx = abs(x2 - x1)
	ld A, C
	sub E
	jr NC, skip_dx
	ld A, E
	sub C
skip_dx:
	; if dx == 0 goto vert
	jr Z, vert
	ld L, A
	; dy = abs(y2 - y1)
	ld A, B
	sub D
	jr NC, skip_dy
	ld A, D
	sub B
skip_dy:
	; if dy == 0 goto horiz
	jr Z, horiz
	ld H, A
	; if dx > dy goto gentle else goto steep
	ld A, L
	cp H
	jr C, steep
	jr gentle

; 垂直な線分を描く
vert:
	; if y1 > y2 then swap(y1,y2)
	ld A, B
	sub D
	jr NC, skip_swap_y1_y2
	ld D, B
	neg
skip_swap_y1_y2:
	ld B, A
	inc B
	call vaddress
loop_horiz:
	; pset(x,y)
	ld C, A
	or (HL)
	ld (HL), A
	ld A, C
	; y++
	rlc A
	jr NC, skip6
	ld DE, #WIDTH
	add HL, DE
skip6:
	; if y != y2 goto loop_horiz
	djnz loop_horiz
	ret

; 水平な線分を描く
horiz:
	; if x1 > x2 then swap(x1,y2)
	ld A, C
	sub E
	jr NC, skip_swap_x1_x2
	ld E, C
	neg
skip_swap_x1_x2:
	ld B, A
	inc B
	call vaddress
loop_vert:
	; pset(x,y)
	ld C, A
	or (HL)
	ld (HL), A
	ld A, C
	; x++, if x != x2 goto loop_vert
	inc HL
	djnz loop_vert
	ret

; 45度より小さい線分を描く
gentle:
	; if x0 > x1 then swap(x0,x1), swap(y0,y1)
	ld A, C
	cp E
	jr NC, skip_swap0
	push BC
	push DE
	pop BC
	pop DE
skip_swap0:
	; if y0 < y1 then Cy=0 else Cy=1
	ld A, B
	cp D
	push AF
	; x = x1, y = y1
	; (C,HL:描画位置 B:カウンタ D:dy E:dx)
	ld B, L
	push HL
	call vaddress
	pop DE
	ld C, A
	; if !Cy goto gentle_down else goto gentle_up
	pop AF
	jr NC, gentle_down
	jr gentle_up
	
; 45度より大きい線分を描く
steep:
	; if y0 > y1 then swap(x0,x1), swap(y0,y1)
	ld A, B
	cp D
	jr NC, skip_swap1
	push BC
	push DE
	pop BC
	pop DE
skip_swap1:
	; if x0 < x1 then Cy = 0 else Cy = 1
	ld A, C
	cp E
	push AF
	; x = x1, y = y1
	; (C,HL:描画位置 B:カウンタ D:dy E:dx)
	ld B, H
	push HL
	call vaddress
	pop DE
	ld C, A
	; if !Cy goto steep_right else goto steep_left
	pop AF
	jr NC, steep_right
	jr steep_left

; 45度より小さい上向きの線分を描く
gentle_up:
	; e = dx/2
	; (A:誤差)
	;ld A, E
	;srl A
	xor A
gentle_up_loop:
	; e += dy
	add D
	; if e > dx then e -= dx, y--
	cp E
	jr C, skip0
	sub E
	rrc C
	jr NC, skip0
	push DE
	ld DE, #-WIDTH
	add HL, DE
	pop DE
skip0:
	; pset(x,y)
	ex AF, AF'
	ld A, C
	or (HL)
	ld (HL), A
	ex AF, AF'
	; x++, if x != x2 goto gentle_up_loop
	inc HL
	djnz gentle_up_loop
	ex AF, AF'
	or (HL)
	ld (HL), A
	ret

; 45度より小さい下向きの線分を描く
gentle_down:
	; e = dx/2
	; (A:誤差)
	;ld A, E
	;srl A
	xor A
gentle_down_loop:
	; e += dy
	add D
	; if e > dx then e -= dx, y++
	cp E
	jr C, skip1
	sub E
	rlc C
	jr NC, skip1
	push DE
	ld DE, #WIDTH
	add HL, DE
	pop DE
skip1:
	; pset(x,y)
	ex AF, AF'
	ld A, C
	or (HL)
	ld (HL), A
	ex AF, AF'
	; x++, if x != x2 goto gentle_down_loop
	inc HL
	djnz gentle_down_loop
	ex AF, AF'
	or (HL)
	ld (HL), A
	ret

; 45度より大きい右向きの線分を描く
steep_right:
	; e = dy/2
	;ld A, D
	;srl A
	xor A
steep_right_loop:
	; e += dx
	add E
	; if e > dy then e -= dy, x++
	cp D
	jr C, skip2
	sub D
	inc HL
skip2:
	; pset(x,y)
	ex AF, AF'
	ld A, C
	or (HL)
	ld (HL), A
	ex AF, AF'
	; y++
	rlc C
	jr NC, skip3
	push DE
	ld DE, #WIDTH
	add HL, DE
	pop DE
skip3:
	; if y != y2 goto steep_right_loop
	djnz steep_right_loop
	ld A, C
	or (HL)
	ld (HL), A
	ret

; 45度より大きい左向きの線分を描く
steep_left:
	; e = dy/2
	;ld A, D
	;srl A
	xor A
steep_left_loop:
	; e += dx
	add E
	; if e > dy then e -= dy, x--
	cp D
	jr C, skip4
	sub D
	dec HL
skip4:
	; pset(x,y)
	ex AF, AF'
	ld A, C
	or (HL)
	ld (HL), A
	ex AF, AF'
	; y++
	rlc C
	jr NC, skip5
	push DE
	ld DE, #WIDTH
	add HL, DE
	pop DE
skip5:
	; if y != y2 goto steep_left_loop
	djnz steep_left_loop
	ld A, C
	or (HL)
	ld (HL), A
	ret

; eof
