.include "g800.asm"

	.area _CODE
;
; ���zVRAM�̓��e��\������
;
; ����
; C:�X�V�̈�x���W
; B:�X�V�̈�y���W
; E:�X�V�̈�x���W
; D:�X�V�̈�y���W
;
; �o��
; BC,DE,HL:�j��
;
vupdate::
	ld A, #0x40
	out (#0x40), A

	; �J�n�E�I��ROW�����߂�
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

	; �J�nx���W�ƒ��������߂�
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

	; �J�n���zVRAM�����߂�
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
	; �`��ROW��ݒ肷��
	push BC
	ld C, #0x40
	ld A, D
	or #0xb0
loop2:
	in B, (C)
	rlc B
	jr C, loop2
	out (C), A

	; �`��COL(L)��ݒ肷��
	ld A, E
	and #0x0f
loop3:
	in B, (C)
	rlc B
	jr C, loop3
	out (C), A

	; �`��COL(H)��ݒ肷��
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

	; 1�s�`�悷��
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

	; ����ROW�Ɉڂ�
	inc D
	ld A, C
	sub D
	jr NC, loop1

	ret

;
; ���zVRAM����������
;
; ���͂Ȃ�
;
; �o��
; BC,DE,HL:�j��
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
; ���zVRAM��̃A�h���X�𓾂�
;
; ����
; D:y���W
; E:x���W
;
; �o��
; A:�}�X�N HL:�A�h���X
; F,DE:�j��
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
; ���zVRAM
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
