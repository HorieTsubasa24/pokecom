;
; ���`�����@�ɂ�闐������
;
; ����
; �Ȃ�
;
; �o��
; A: ����
; F: �j��
;
; ���l
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
; �����V�[�h��ݒ肷��
;
; ����
; HL: �����V�[�h
;
; �o��
; �Ȃ�
;
srand::
	ld (rand_value16), HL
	ret

rand_value16:
	.db 0xff
rand_value8:
	.db 0xff

; eof
