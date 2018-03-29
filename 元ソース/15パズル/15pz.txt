 org 100h

 call 0bd0fh
l1:
 push hl	;
 ld HL,pjl1
 push HL		;
 call phlset
 push HL			;
 call RAND4
 cp 1
 jr c,pzup
 jr z,pzdw
 cp 3
 jr c,pzrg
pzlf:
 ld DE,pzdata
 or A
 sbc HL,DE
 ld A,L
 pop HL			;
 cp 3
 ret z
 cp 7
 ret z
 cp 11
 ret z
 cp 15
 ret z
 inc HL
 ld A,(HL)
 ld (HL),0
 dec HL
 ld (HL),A
 ret		;
pzup:
 ld DE,pzdata
 or A
 sbc HL,DE
 ld A,L
 pop HL			;
 cp 12
 ret nc		;
 push HL			;
 ld DE,4
 add HL,DE
 ld A,(HL)
 ld (HL),0
 pop HL			;
 ld (HL),A
 ret		;
pzdw:
 ld DE,pzdata
 or A
 sbc HL,DE
 ld A,L
 pop HL			;
 cp 4
 ret c		;
 push HL			;
 ld DE,10000h-4
 add HL,DE
 ld A,(HL)
 ld (HL),0
 pop HL			;
 ld (HL),A
 ret		;
pzrg:
 ld DE,pzdata
 or A
 sbc HL,DE
 ld A,L
 pop HL			;
 or A
 ret z		;
 cp 4
 ret z		;
 cp 8
 ret z		;
 cp 12
 ret z		;
 dec HL
 ld A,(HL)
 ld (HL),0
 inc HL
 ld (HL),A
 ret		;
pjl1:
 pop HL	;
 dec L
 jp nz,l1
 dec H
 jp nz,l1
 ld HL,0
 add HL,SP
 ld (pjl2+1),HL
mainlp:
 call pzpnt
 ld HL,pjl2
 push HL
 call phlset
 push HL			;
 call 48381
 cp 1fh
 jp z,pzdw
 cp 20h
 jp z,pzup
 cp 21h
 jp z,pzlf
 cp 22h
 jp z,pzrg
pjl2:
 ld SP,0
 cp 51h
 ret z
 ld HL,pzdata
 ld A,"0"
pzck:
 inc A
 cpi
 jr z,pzck
 ld DE,65536-(pzdata+10)
 add HL,DE
 ld A,L
 or A
 jr nz,mainlp
 ld HL,pzdata+9
 ld A,40h
pzck2:
 inc A
 cpi
 jr z,pzck2
 ld DE,65536-(pzdata+16)
 add HL,DE
 ld A,L
 or A
 jr nz,mainlp
pzcomp:
 call pzpnt
 ld HL,pzcmpm
 ld B,16
 ld DE,0206h
 call 0bff1h
 call 48381
 ret
pzcmpm:
 db "Congratulations!"
pzpnt:
 ld HL,pzdata
 ld D,01h
 ld B,4
pzpl1:
 push BC
 ld B,4
 ld E,1
 CALL 0bff1h
 pop BC
 inc HL
 inc D
 djnz pzpl1
 ret
RAND:;AÆ¶´½
 PUSH HL
 LD HL,0
 LD D,H
 LD E,L
 ADD HL,HL
 ADD HL,HL
 ADD HL,DE
 LD DE,5D47H
 ADD HL,DE
 LD (RAND+2),HL
 LD A,H
 POP HL
 RET
RAND4:
 CALL RAND
 AND 3
 RET
phlset:
 ld HL,pzdata
 xor A
 ld C,0ffh
 cpir
 dec HL
 ret
pzdata:
 db "123456789ABCDEF",0
end












 ld HL,pzdata
 ld A,"0"
 ld C,0
pzchek:
 inc A
 cpi
 jr z,pzchek
 cp 3ah
 jr z,pzche1
 jr mainlp
pzche1:
 ld a,40h
pzche2:
 inc A
 cpi
 jr z,pzche2
 cp 47h
 jr z,pzcomp
 jr mainlp
pzcomp:
 ld HL,pzcmpm
 ld B,16
 ld DE,020eh
 call 0bff1h
 ret
pzcmpm:
 db "Congratulations!"