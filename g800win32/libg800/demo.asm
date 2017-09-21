100$:
	ld DE, #0
	ld A, #" "
	ld B, #24 * 6
	call 0xbfee

	ld DE, #0x0000
	ld HL, #msg1
	ld B, #4
	call #0xbff1
	ld DE, #0x0100
	ld HL, #msg2
	ld B, #6
	call #0xbff1
	ld DE, #0x0200
	ld HL, #msg3
	ld B, #6
	call #0xbff1
	call #0xbcfd

	cp #0x2c
	jr Z, demo_pset
	cp #0x2d
	jr Z, demo_line

	ret
	
; ì_Ç∆óêêî
demo_pset:
	call vclear
	ld A, R
	ld H, A
	ld A, R
	ld L, A
	call srand
	ld B, #20
loop_pset3:
	push BC
	ld B, #0
loop_pset:
	push BC
loop2_pset:
	call rand
	cp #48
	jr NC, loop2_pset
	ld D, A
	
	call rand
	cp #144
	jr NC, loop2_pset
	ld E, A

	call vaddress
	or (HL)
	ld (HL), A
	pop BC
	djnz loop_pset

	ld DE, #0x0000
	ld BC, #0x2f8f
	call vupdate
	pop BC
	djnz loop_pset3
	call #0xbcfd
	ret

; ê¸ï™
demo_line:
	call vclear
	ld B, #48
loop_line:
	push BC
	
	ld A, #143
	sub B
	sub B
	sub B
	ld D, #0
	ld E, A
	ld A, B
	add B
	add B
	ld B, #47
	ld C, A
	
	ld HL, #0x3090
	call lineclip
	jr NC, skip_line
	call line
skip_line:
	pop BC
	djnz loop_line

	ld DE, #0x0000
	ld BC, #0x2f8f
	call vupdate
	call #0xbcfd
	ret

msg1:
	.ascii /DEMO/
msg2:
	.ascii /1:PSET/
msg3:
	.ascii /2:LINE/

; eof
