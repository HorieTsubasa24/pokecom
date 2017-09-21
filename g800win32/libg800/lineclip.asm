.include "g800.asm"

;
; �����̃N���b�s���O�������s��
;
; ����
; D:�����n�_y���W
; E:�����n�_x���W
; B:�����I�_y���W
; C:�����I�_x���W
;
; �o��
; D,E,B,C:�N���b�s���O������̍��W
; Cy:0.�����͊��S�ɉ�ʊO 1.��ʓ�
; A,HL:�j��
;
lineclip::
	ld A, D
	cp H
	jr C, skip5
	ld A, B
	cp H
	jr C, skip5
	ret
	
skip5:
	ld A, E
	cp L
	jr C, skip6
	ld A, C
	cp L
	jr C, skip6
	ret
skip6:

	; ���E�N���b�v
	push HL
	ld A, H
	ld H, L
	ld L, A
	ld A, D
	ld D, E
	ld E, A
	ld A, B
	ld B, C
	ld C, A
	call clipy
	ld A, D
	ld D, E
	ld E, A
	ld A, B
	ld B, C
	ld C, A
	pop HL
	ret NC
	
	; �㉺�N���b�v
	push HL
	call clipy
	pop HL
	ret

clipy:
	; �N���b�v����K�v�����邩?
	ld A, D
	cp H
	ld A, B
	jr C, y1_less_than_height
y1_greater_eual_height:
	cp H
	ret NC
	jr clipx
y1_less_than_height:
	cp H
	ret C

clipx:
	; dx, dy�����߂�. y1 < y2�̂Ƃ����W����������.
	push HL
	ld A, B
	sub D
	jr NC, skip1
	ld H, D
	ld D, B
	ld B, H
	ld H, E
	ld E, C
	ld C, H
	neg
skip1:
	pop HL
	
	; dx = dx/2
	push DE
	push HL
	
	ld A, C
	sub E
	srl A
	ld L, A

	ld A, C
	cp E
	jr NC, skip2
	
	ld A, E
	sub C
	srl A
	neg
	ld L, A
skip2:

	; dy = dy/2
	ld A, B
	sub D
	srl A
	ld H, A
	
	ld A, B
	cp D
	jr NC, skip4
	
	ld A, D
	sub B
	srl A
	neg
	ld H, A
skip4:
	ex DE, HL
	pop HL
	dec H

loop1:
	ld A, B
	cp H
	jr Z, last
	jr C, y_less_than_height
y_greater_than_height:
	ld A, B
	sub D
	ld B, A
	ld A, C
	sub E
	ld C, A
	jr skip3
y_less_than_height:
	ld A, B
	add D
	ld B, A
	ld A, C
	add E
	ld C, A
skip3:
	ld A, E
	sra E
	srl D
	jr NZ, loop1

last:
	pop DE
	
	ld A, C
	cp L
	jr C, skip7
	ld C, L
	dec C
skip7:
	ld B, H
	or A
	ccf
	ret

; eof
