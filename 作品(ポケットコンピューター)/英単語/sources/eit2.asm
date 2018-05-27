grp	equ	0bfd0h	;ｸﾞﾗﾌｨｯｸ
msp	equ	0bff1h	;ﾒｯｾｰｼﾞ
khit	equ	9d9h	;ｳｪｲﾄ入力	0bcfdh
khit2	equ	0be53h	;ﾉﾝｳｪｲﾄ入力
chrput	equ	0be62h	;ｷｬﾗｸﾀ配置
cursL	equ	0f0h	;curs x
cursH	equ	0f1h	;curs y
cursE	equ	0f2h	;curs最下点 5
cursD	equ	0f3h	;curs最上点 0
freeM	equ	0f4h


 org 100h


 ld HL,0
 add HL,SP
 ld (SPpoint+1),HL
 call gre
 ld B,4
 ld D,0
 ld HL,titleg
l1:
 push BC
 ld E,4
 ld B,96
 call grp
 call timA
 inc HL
 inc D
 pop BC
 djnz l1
l2:
 ld DE,0405h
 ld HL,titlem
 ld B,14
 call msp
 call timr120
 cp 1eh
 jr z,main
 ld DE,0405h
 ld B,14
 inc HL
 call msp
 call timr120
 cp 1eh
 jr z,main
 jr l2
main:
 call gre
 ld DE,0003h
 ld B,11
 ld HL,manum
 call msp
 ld HL,manum2
 call mspmn
mncurs:
 ld HL,0205h
 ld (cursE),HL
 ld HL,0203h
 ld (cursL),HL
 ex DE,HL
 ld A,">"
 call chrput
mncurslp:
 call timr120
 call c,cursor
 cp 28h
 jr z,modesel
 call bookpr
 jr mncurslp
modesel:
 ld A,(cursH)
 cp 3
 jp c,anaume
 jp z,kakikomu
 cp 5
 jp c,kesu
 ret z
anaume:
 call datack
 call gre
 ld HL,anaumem
 ld DE,0
 ld B,24
 call msp
 call oneninec
 ld (anaN),A
 add A,30h
 ld DE,0101h
 call chrput
 ld HL,anaumem+24
 ld DE,0200h
 ld B,24
 call msp
 call oneninec
 push AF
 add A,30h
 ld DE,0301h
 call chrput
 pop AF
 sla A
 sla A
 sla A
 ld (gameN),A

 ld HL,a1
 call anakaisu
 xor A
 ld (a2),A

 call timB
anagamelp:
 call gre
 ld HL,anam
 ld DE,0002h
 ld B,22
 call msp
 call datastr
 ld A,(anaN)
 ld B,A
anaumelp1:
 ld A,(anadataM)
 ld (anarand+6),A
 push BC
anarand:
 call rand
 and 00001111b
 cp 0
 jr nc,anarand
 ld L,A
 ld H,0
 ex DE,HL	;DE=0~22
 ld HL,free-24
 add HL,DE	;穴の位置
 pop BC
 ld A,(HL)
 cp 20H
 jr z,anaumelp1
 ld (HL),5fh;"_"
 djnz anaumelp1

 ld A,(anadataM)
 ld HL,free-24
 ld DE,0100h	;表示位置
 ld B,A
anaumelp2:
 push BC
 ld A,5fh
 cpi
 push DE
 push HL
 call z,ascinp1
 pop HL
 pop DE
 inc E
 pop BC
 djnz anaumelp2

 ld DE,anadataM
 ld HL,(anadataA)
 call seigoana

 push AF;flag save
 call seigoprint
 ld HL,(dataOXA)
 call anaincA
 pop AF
 jr nz,anadjnz
anaX:
 inc HL
 call anaincA
 ld HL,a2
 inc (HL)
anadjnz:
 ld A,(gameN)
 dec A
 ld (gameN),A
 jp nz,anagamelp

 ld HL,a2
 ld A,(HL)
 call anakaisu
 ld HL,anaumeseigom
 ld DE,0302h
 ld B,19
 call msp
 call timB
 call khit
 jp main


seigoprint:
 jr z,$+6
 ld A,0f0h;"×"
 jr $+4
 ld A,0edh;"○"
 ld DE,0300h
 call chrput
 call timD
 call dataldir
 ld HL,free-24
 ld DE,0100h
 ld B,48
 call msp
 call khit
 ret



anakaisu:
 ld (HL),30h
 sub 10
 jr c,anakaisu1
 inc (HL)
 jr anakaisu+2
anakaisu1:
 inc HL
 ld (HL),30h
 add A,10
 ret z
anakaisu2:
 inc (HL)
 dec A
 jr nz,anakaisu2
 ret


anaincA:
 ld A,(HL)
 inc A
 inc A
 jr nz,anacountreset
 ld A,1
anacountreset:
 dec A
 ld (HL),A
 ret


oneninec:
 call khit
 ld B,0
 cp 2ch;1
 jr z,oneninel+8
 cp 2dh;2
 jr z,oneninel+7
 cp 2eh;3
 jr z,oneninel+6
 cp 34h;4
 jr z,oneninel+5
 cp 35h;5
 jr z,oneninel+4
 cp 36h;6
 jr z,oneninel+3
 cp 3ch;7
 jr z,oneninel+2
 cp 3dh;8
 jr z,oneninel+1
 cp 3eh;9
 jr z,oneninel
 jr oneninec
oneninel:
 inc B
 inc B
 inc B
 inc B
 inc B
 inc B
 inc B
 inc B
 inc B
 ld A,B
 ret


datastr:;0はダメ
 ld HL,(dataqu)
 call decHL
 ld DE,data
 jr z,datastr1
 push DE
 call randomeHL
 ld (free),HL	;HL=ランダム乱数
 ld DE,0
 or A
 sbc HL,DE
 pop HL		;HL=data
 jr z,datastr1+1
datastrl1:	;cpirでﾃﾞｰﾀの先頭を求める
 ld A,0ffh
 ld C,0ffh
 cpir
 ex DE,HL	;DE=data++ HL=?
 ld HL,(free)	;HL=loop count
 call decHL
 ld (free),HL
 ex DE,HL	;HL=data++
 jr nz,datastrl1
 ex DE,HL
datastr1:
 ex DE,HL
 ld (anadataA),HL
 xor A
 ld C,0ffh
 cpir
 ld (imidataA),HL
 ld A,C
 cpl
 dec A
 ld (anadataM),A
 xor A
 ld C,0ffh
 cpir
 ld (dataOXA),HL
 ld A,C
 cpl
 dec A
 ld (imidataM),A
dataldir:
 call freecl2
 ld HL,(anadataA)
 ld DE,free-24
 ld A,(anadataM)
 ld C,A
 ld B,0
 ldir
 ld HL,(imidataA)
 ld DE,free
 ld A,(imidataM)
 ld C,A
 ld B,0
 ldir
; ld HL,free-24
; ld DE,0
; ld B,48
; call msp
 ret


seigoana:
 ld BC,free-24
 jr seigol
seigoimi:
 ld BC,free
seigol:;DE=ana(imi)dataM HL=(ana(imi)dataA)
 push BC
 ld A,(DE)
 ld B,A
 pop DE
seigolp:
 push BC
 ld A,(DE)
 cpi
 inc DE
 pop BC
 ret nz
 djnz seigolp
 xor A	;zero flag
 ret

ascinp1:;DE=表示位置 HL=free++ 破壊 DE,HL,BC,AF
 dec HL
 ld (HL),87h
ascinp1lp:
 push BC
 push HL
 push DE
 ld DE,0100h
 ld HL,free-24
 ld B,24
 call msp
 call aschit	;ENT=0ffh BS=1fh
 pop DE
 pop HL
 pop BC
 cp 01fh;BS
 jr z,imip
 cp 0ffh
 ret z
 ld (HL),A
 jr ascinp1lp
imip:
 push DE
 push HL
 push BC
 ld DE,0200h
 ld HL,free
 ld B,24
 call msp
 pop BC
 pop HL
 pop DE
 jr ascinp1lp


anaumem:
 db "ｱﾅﾉｶｽﾞｦﾀｲﾌﾟｼﾃｸﾀﾞｻｲ 1~9? "
 db "ｶｲｽｳｦﾀｲﾌﾟｼﾃｸﾀﾞｻｲ 8*1~9?"
anam:
 db "_ｦｳﾒﾖ BS:ｲﾐｦﾐﾙ ENT:ﾂｷﾞ";22
anaN:
 db 0
gameN:
 db 0
anadataA:
 db 0,0
anadataM:
 db 0
imidataA:
 db 0,0
imidataM:
 db 0
dataOXA:
 db 0,0
anaumeseigom:
 db "ｶｲﾄｳｽｳ:"	;7
a1:		;9
 db 0,0	
 db " ｾｲｶｲｽｳ:"	;17
a2:
 db 0,0		;19




decHL:
 push DE
 ld DE,1
 or A
 sbc HL,DE
 pop DE
 ret
kakikomu:
 call gre
 ld DE,0004h
 ld HL,kakikomum
 ld B,15
 call msp
 ld HL,0102h
 ld (cursL),HL
 call kinpline					;;;
 ld HL,free
 ld A,(HL)
 or A
 jp z,main
 cp 20h
 jp z,main
 ld DE,free-24
 ld BC,24
 ldir
 call freecl
 ld DE,0204h
 ld HL,kakikomum+15
 ld B,11
 call msp
 ld HL,0302h
 ld (cursL),HL
 call kinplinekana
 ld A,(free)
 or A
 jp z,main
 
 call ADsearch;HL

 push HL	;転送先アドレス
 ld HL,free-24
 xor A
 ld c,0ffh
 cpir		;ﾃﾞｰﾀの終わり
 ld BC,65536-(free-24)
 add HL,BC	;HL-BC=転送回数-1
 push HL
 pop BC		;HL→BC
 pop DE		;転送先アドレス
 ld HL,free-24
 ldir
 ld HL,free
 xor A
 ld C,0ffh
 cpir
 ld BC,65536-free
 add HL,BC
 push HL
 pop BC
 ld HL,free
 ldir
 ex DE,HL
 xor A
 ld (HL),A	;回答数
 inc HL
 ld (HL),A	;正答数
 inc HL
 ld (HL),0ffh	;endsign
 
 ld HL,dataqu
 inc (HL)

 ld DE,0403h
 ld HL,kakikomum+15+11
 ld B,19
 call msp
 call khit
 cp 07h;y
 jp z,kakikomu
 jp main

ADsearch:
 ld HL,(dataqu)
 ld DE,1
 call cpHLDE
 ld DE,data
 ex DE,HL	;DE=(dataqu) loop count	HL=dataAD
 ret c
ADsearchlp:
 ld A,0ffh
 ld C,0ffh
 cpir
 dec DE
 push HL	;
 ex DE,HL		;
 ld DE,1
 call cpHLDE
 ex DE,HL		;
 pop HL		;
 jr nc,ADsearchlp
 ret

kakikomum:
 db "ｴｲﾀﾝｺﾞｦｲﾚﾃｸﾀﾞｻｲ";15
 db "ｲﾐｦｲﾚﾃｸﾀﾞｻｲ";11
 db "ﾂﾂﾞｹﾃｶｷﾏｽｶ? Y:ﾂﾂﾞｹﾙ";15
kesu:
 call datack
 call gre
 ld HL,kesum
 ld DE,0002h
 ld B,19
 call msp
 ld HL,0
 call datacs

 ld HL,kesum+19
 ld DE,0402h
 ld B,18
 call msp

 call khit
 cp 07h;y
 jp nz,main

 ld HL,(anadataA)
 push HL	;転送先
 ld A,0ffh
 ld BC,0ffh
 cpir
 push HL	;転送元
 ld HL,(dataqu)
 ld BC,53
 call decHL
 ld (dataqu),HL	;ﾃﾞｰﾀの総量-1
 jr z,kesuldir
 ld BC,(datacsHL)
 or A
 sbc HL,BC	;cpir回数
 jr z,kesuldirset
 ex DE,HL	;DE=cpir count
 pop HL		;cpir startAD.
 push HL
kesulp:
 ld A,0ffh
 ld BC,60
 cpir
 ex DE,HL
 call decHL
 ex DE,HL
 jr nz,kesulp

 pop DE		;転送元のアドレス
 push DE
 or A
 sbc HL,DE
 push HL
 pop BC
kesuldir:
 pop HL
 pop DE
 ldir
 ld HL,kesum+(19+18)
 ld DE,0504h
 ld B,6
 call msp
 call khit
 jr kesu
kesuldirset:
 ld BC,53
 jr kesuldir
 

 jp main

datacs:
 push HL
 ld (free),HL
 ld (datacsHL),HL
 inc HL
 call decHL
 ld HL,data
 jr nz,datacs1
 call datastr1-1;z,kesu0
 jr datacs1+3
datacs1:
 call datastrl1
 ld HL,free-24
 ld DE,0100h
 ld B,48
 call msp
 ld HL,(dataOXA)
 push HL
 ld A,(HL)
 ld HL,a1
 call anakaisu
 pop HL
 inc HL
 ld A,(HL)
 ld HL,a2
 call anakaisu

 ld HL,anaumeseigom
 ld DE,0302h
 ld B,19 
 call msp

datacsK:
 call khit
 ld DE,(dataqu)
 pop HL
 inc HL
 call decHL
 jr z,$+6
 cp 20h;u
 jr z,datacsid
 cp 1fh;d
 jr z,datacsid+2
 cp 28h
 ret z
 push HL
 jr datacsK
datacsid:
 dec HL
 dec HL
 inc HL
 call cpHLDE
 jr nc,datacsid
 jr datacs
 
datacsHL:
 db 0,0
 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

kesum:
 db "ﾃﾞｰﾀﾉｾﾝﾀｸ ｳｴ,ｼﾀ,ENT";19
 db "ｺﾉﾃﾞｰﾀｦｹｼﾏｽｶ? Y/N?";18
 db "ｹｼﾏｼﾀ!";6
zishom:
 db "ｶｷｺﾑ","ｶｷｶｴ","ｹｽ  ","ﾓﾄﾞﾙ"



bookpr:
 call rand4
 cp 1
 jr c,bookp1
 jr z,bookp2
 cp 3
 jr c,bookp3
 jr bookpr
bookp1:
 ld HL,book1
 jr bookp
bookp2:
 ld HL,book2
 jr bookp
bookp3:
 ld HL,book3
bookp:
 ld D,02
 ld B,3
bookpl:
 push BC
 ld E,11h
 ld B,24
 call grp
 inc HL
 inc D
 pop BC
 djnz bookpl
 ret

datack:
 ld HL,(dataqu)
 ld A,H
 or A
 ret nz
 ld A,L
 or A
 ret nz
 call gre
 ld HL,datackm
 ld DE,0106h
 ld B,11
 call msp
 call khit
 pop AF
 jp main

datackm:
 db "ﾃﾞｰﾀｶﾞｱﾘﾏｾﾝ"


mspmn:
 ld B,4
 ld D,02h
mainl1:
 push BC
 ld E,04h
 ld B,4
 call msp
 call timA
 inc D
 inc HL
 pop BC
 djnz mainl1
 ret


cursor:;(>)移動
 push AF
 ld DE,(cursL)
 ld A," "
 call chrput
 pop AF
 ex DE,HL
 cp 1fh	;down
 jr z,cursdw
 cp 20h	;up
 jr z,cursup
;cp 21	;left
;jr z,curslf
;cp 22	;right
;jr z,cursrg
 jr cursst
cursup:
 ld A,(cursD)
 cp H
 jr z,cursst
 dec H
 jr cursst
cursdw:
 ld A,(cursE)
 cp H
 jr z,cursst
 inc H
; jr cursst
cursst:
 push AF
 ld (cursL),HL
 ex DE,HL
 ld A,">"
 call chrput
 call timB
 pop AF
 ret


aschit:
 ld HL,ascrt
 push HL
 call khit
 cp 51h
 jp z,SPpoint
 cp 18h
 jr nc,aschi2
 dec A
 jr z,aschi3
 dec A
 ld HL,ascd
 ld D,0
 ld E,A
 add HL,DE
 ld A,(HL)
 ret
aschi2:
 cp 1eh
 jr z,ascSP
 cp 28h
 jr z,ascENT
 cp 29h
 jr z,ascL
 cp 31h
 jr z,ascI
 cp 32h
 jr z,ascO
 cp 39h
 jr z,ascP
 cp 3ah
 jr z,ascBS
aschi3:
 pop AF
 xor A
 ret
ascSP:
 ld A," "
 ret
ascENT:
 pop HL
 ld A,0ffh
 ret
ascL:
 ld A,"l"
 ret
ascI:
 ld A,"i"
 ret
ascO:
 ld A,"o"
 ret
ascP:
 ld A,"p"
 ret
ascBS:
 ld A,1fh
 ret
ascrt:
 ld (freeM),A
 ret
ascd:
 db "qwertyuasdfghjkzxcvbnm"
kinpline:;cursHLに座標
;ld HL,0200h
;ld (cursL),HL
 call freest
 push HL
kinplp:
 call aschit
 pop HL
 or A
 jr z,kinplp-1
 cp 1fh
 jr z,kBS
 cp 0ffh
 jr z,kENT
 ld (HL),A
 ld DE,free+20
 call cpHLDE
 jr nc,ascprn
 inc HL
ascprn:
 push HL
 ld DE,(cursL)
 ld HL,free
 ld B,24
 call msp
 jr kinplp
kBS:
 ld (HL),0
 ld DE,free+1
 call cpHLDE
 jr c,ascprn
 dec HL
 ld (HL),0
 jr ascprn
kENT:
 ret



kinplinekana:
 call freest
 xor A
 ld (kanasc),A
 ld (kanasc+1),A
 push HL
kinplpkana:
 call aschit
 pop HL
 or A
 jr z,kinplpkana-1
 cp 1fh
 jp z,kBSka
 cp 0ffh
 jr z,kENT
 call kanatr
kanaprn:
 push HL
 push AF
 ld DE,(cursL)
 ld HL,free
 ld B,24
 call msp
 pop AF
 jr nc,kinplpkana
 pop HL
 ld DE,free+20
 call cpHLDE
 jr nc,kinplpkana-1
 inc HL
kanadakuM:
 push AF
 ld A,0
 cp 13
 jr z,handakuput
 cp 9
 jr nc,dakuonput
 xor A
 ld (kanadakuM+2),A
 pop AF
 jr kinplpkana-1
dakuonput:
 ld A,"ﾞ"
 jr handakuput+2
handakuput:
 ld A,"ﾟ"
 ld (HL),A
 xor A
 ld (kanadakuM+2),A
 pop AF
 jr kanaprn
 






kanatr:
 push HL	;1 free
 ex AF,AF'
 ld HL,kanasc
 ld A,(HL)
 or A
 jp z,kanatrl
 inc HL			;2文字目
;ld A,(HL)
; or A
; jr z,kanatrl2
;kanatrl3:
; ex AF,AF'
;
;
;
kanatrl2:
 dec HL
 ld A,(HL)
 ex AF,AF'
 cp "a"
 jr z,kanatrl2lb
 cp "i"
 jr z,kanatrl2lb
 cp "u"
 jr z,kanatrl2lb
 cp "e"
 jr z,kanatrl2lb
 cp "o"
 jr z,kanatrl2lb
 cp "n"
 jr z,kanatrl2lbN
 jp kanatrl+1
kanatrl2lb:
 ex AF,AF'	;memori no hou
 ld HL,kanatb+13
 ld BC,14
 cpdr
 jp nz,kanatrl
 ld B,C
 ld A,B
 ld (kanadakuM+2),A
 ld A,5
 call xsan
 ld H,0
 ld DE,kanatb2
 add HL,DE
kanatruns:
 ex AF,AF'
 cp "a"
 jr z,kanatrunsl+4
 cp "i"
 jr z,kanatrunsl+3
 cp "u"
 jr z,kanatrunsl+2
 cp "e"
 jr z,kanatrunsl+1
 cp "o"
kanatrunsl:
 inc HL
 inc HL
 inc HL
 inc HL
 ld A,(HL)
 jp kanastr
kanatrl2lbN:
 ld A,"ﾝ"
 jp kanastr
;kanadakuon:
 
 



kanatb:
 db "kstnhmyrwgzdbp"
kanatb2:
 db "ｶｷｸｹｺｻｼｽｾｿﾀﾁﾂﾃﾄﾅﾆﾇﾈﾉﾊﾋﾌﾍﾎﾏﾐﾑﾒﾓﾔｲﾕｴﾖﾗﾘﾙﾚﾛﾜｲｳｴｦ"
kanatb3:
 db "ｶｷｸｹｺｻｼｽｾｿﾀﾁﾂﾃﾄﾊﾋﾌﾍﾎﾊﾋﾌﾍﾎ"



kanatrl:
 ex AF,AF'
 ld DE,kanastr
 push DE	;2
 cp "a"
 jr z,kanaA
 cp "i"
 jr z,kanaI
 cp "u"
 jr z,kanaU
 cp "e"
 jr z,kanaE
 cp "o"
 jr z,kanaO
 cp " "
 jr z,kanaSP
 pop DE
 ld DE,kanainp
 push DE

 cp "k"
 ret z
 cp "s"
 ret z
 cp "t"
 ret z
 cp "n"
 ret z
 cp "h"
 ret z
 cp "m"
 ret z
 cp "y"
 ret z
 cp "r"
 ret z
 cp "w"
 ret z

 cp "g"
 ret z
 cp "z"
 ret z
 cp "d"
 ret z
 cp "b"
 ret z
 cp "p"
 ret z

 pop DE
 pop HL
 or A
 ret


 


kanaA:
 ld A,"ｱ"
 ret
kanaI:
 ld A,"ｲ"
 ret
kanaU:
 ld A,"ｳ"
 ret
kanaE:
 ld A,"ｴ"
 ret
kanaO:
 ld A,"ｵ"
 ret
kanaSP:
 ld A," "
 ret
kanastr:
 pop HL
 ld (HL),A
 push HL
 ld HL,kanasc
 xor A
 ld (HL),A
 inc HL
 ld (HL),A
 ld HL,space
 ld DE,0500h
 ld B,3
 call msp
 pop HL
 scf				;;;;;
 ret
kanainp:
 ld (kanasc),A	;kanasc sion AD.
 ld DE,0500h
 call chrput
 pop HL
 or A
 ret


 
kanasc:;ここに子音ascを入れる
 db 0,0










kBSka:
 push HL	;kanaAL
 ld HL,kanasc
 ld E,(HL)
 inc E
 dec E
 jr z,kBSkal
 ld (HL),0
 inc HL
 ld (HL),0
 ld HL,space
 ld DE,0500h
 ld B,3
 call msp
kBSkal:
 pop HL		;kana
 ld (HL),0
 ld DE,free+1
 call cpHLDE
 jp c,kanaprn
 dec HL
 ld (HL),0
 or A
 jp kanaprn
 









freecl2:
 exx
 ld HL,free-24
 ld (HL),0
 ld DE,free-23
 ld BC,47
 ldir
 exx
 ret
freecl:
 exx
 ld HL,free
 ld (HL),0
 ld DE,free+1
 ld BC,23
 ldir
 exx
 ret
 ds 24
free:
 ds 24

freest:
 ex DE,HL
 ld A,">"
 call chrput
 call freecl
 ld HL,free
 ret

cpHLDE:
 push DE
 push HL
 or A
 sbc HL,DE
 pop HL
 pop DE
 ret

rand16:
 push AF
 call rand
 push AF
 ld B,127
 call rand;loop
 djnz $-3
 ld L,A
 pop AF
 res 7,A
 ld H,A
 pop AF
 ret
rand:
 ld HL,0
 ld D,H
 ld E,L
 add HL,HL
 add HL,HL
 add HL,DE
 ld DE,6411H
 add HL,DE
 ld (rand+1),HL
 ld A,H
 ret
rand4:
 call rand
 and 00000111b
 ret

;［  範囲乱数公式  ］
;最小値 + (int)( rand() * (最大値 - 最小値 + 1.0) / (1.0 + RAND_MAX) )


randomeA:;HL=最大の数	brakeALL not IX,IY
 ld L,A
 ld H,0
randomeHL:;最大の数以下の乱数 12/5 
 push HL
 call rand16		;HL=0~0ffffh
 pop DE	;HL=rand DE=最大数
 call cpHLDE
 jr c,randomeHLsubDEj	;if DE>HL then goto randomeHLsubDEj
 or A
randomeHLsubDE:
 sbc HL,DE	;rand - randMAX
 call cpHLDE	;if randMAX < rand then loop
 jr z,randomeLorH
 jr nc,randomeHLsubDE
 ret
randomeHLsubDEj:
 ex DE,HL	;randMAX ==> HL
 jr randomeHL
randomeLorH:
 push HL
 call rand
 pop HL
 cp 80h
 ret c
 ld HL,0
 ret
mspwt:
 call khit2
 jr c,mspwt
mspwt2:
 call rand
 call khit2
 ret c
 jr mspwt2

 org 09F6h

xsan:;A*B=HL
 push BC
 push DE
 ld E,A
 ld D,0
 ld HL,0
 or A
 jr z,xsanrt
 dec B
 inc B
 jr z,xsanrt
xsanl:
 add HL,DE
 djnz xsanl
xsanrt:
 pop DE
 pop BC
 ret



timD:
 ld A,250
 jr TIMER
timC:
 ld A,120
 jr TIMER
timB:
 ld A,80
 jr TIMER
timA:
 ld A,40
TIMER:;A:ｼﾞｶﾝ
 push BC
 LD BC,0
T1:INC BC
 DB 0,0,0,0,0
 cp B
 jr z,tret
 JR T1
tret:
 pop BC
 ret
timr200:
 ld A,200
 jr timr
timr0:
 ld A,1
 jr timr
timr120:
 ld A,120
timr:;A:ｼﾞｶﾝ
 push BC
 ld B,A
T2:
 push BC
 call khit2
 pop BC
 jr c,tret
 or A	;cy reset
 dec B
 jr z,tret
 jr T2
gre:
 ld D,0
grelp:
 push DE
grel:
 ld B,12
 ld E,0
grel2:
 push BC
 push DE
 ld HL,space
 ld B,12
 call grp
 pop DE
 inc E
 inc E
 pop BC
 djnz grel2
 pop DE
 inc D
 ld A,D
 cp 6
 jr nz,grelp
 ret

SPpoint:
 ld SP,0
 jp main
manum:
 db "MODE SELECT";11
manum2:
 db "ｱﾅｳﾒ","ｶｷｺﾑ","ｹｽ  ","ｵﾜﾙ ";4*4
titlem:
 db "push space key";14
space:
 db 0,0,0,0,0,0,0,0,0,0,0,0,0,0
titleg:
 db 00,00,10h,30h,30h,30h,30h,30h,30h,30h,0FEh,0FEh,0FEh,30h,30h,30h,30h
 db 30h,30h,0FEh,0FEh,0FEh,30h,30h,30h,30h,30h,30h,30h,20h,00,00,00,00,00,00,00
 db 00,00,04,0Ch,3Ch,78h,70h,04,0Ch,3Ch,78h,70h,00,00,80h,0E0h,7Ch,3Ch,1Ch
 db 08,00,00,00,00,00,00,00,00,00,80h,98h,98h,98h,98h,98h,98h,98h,98h,88h
 db 80h,08,18h,18h,18h,0F8h,0F8h,0F8h,18h,18h,18h,98h,98h,1Ch,1Ch,18h,10h,00,00,00
 db 00,00,00,00,00,00,00,0F8h,0F8h,0F8h,19h,19h,19h,18h,18h,0FFh,0FFh,0FFh
 db 18h,19h,19h,19h,0FCh,0FCh,0F8h,10h,00,00,00,00,00,00,00,00,00,00,00,00
 db 0FFh,0FFh,0FFh,63h,63h,63h,63h,63h,0FFh,0FFh,0FFh,0FFh,63h,63h,63h,63h
 db 63h,0FFh,0FFh,0FEh,00,00,00,00,00,00,00,00,01,0D9h,0D9h,0D9h,0D9h,0D9h
 db 0D9h,0D9h,0D9h,49h,01,0C0h,0C3h,0C3h,0FFh,0FFh,0FFh,0C3h,0C3h,0C3h,0C3h
 db 0FFh,0FFh,0FFh,0C2h,0E0h,0E0h,0C0h,80h,00
 db 00,00,06,06,06,06,06,07,07,07,06,86h,0C6h,0F6h,0FEh,7Fh,3Fh,7Fh,0F6h,0E6h
 db 0C6h,86h,07,07,07,06,06,07,07,06,04,00,00,40h,0C0h,0C0h,0C0h,0C0h,0DFh,0DFh
 db 0CFh,0C6h,0C6h,0C6h,0C6h,0C6h,0FFh,0FFh,0FFh,0FFh,0C6h,0C6h,0C6h,0C6h,0C6h
 db 0CFh,0CFh,0CFh,0E0h,0E0h,0E0h,40h,00,00,00,00,00,0FCh,0FCh,0FCh,18h,18h,0F8h
 db 0FCh,0FCh,00,00,00,0FCh,0FCh,0FCh,18h,18h,18h,18h,18h,18h,18h,0FCh,0FCh,0F8h
 db 00,00,00,00,00
 db 00,00,10h,30h,30h,18h,18h,1Ch,0Ch,0Eh,07,07,03,01,00,00,00,00,00,01,03,07,0Fh
 db 0Fh,1Eh,1Eh,3Eh,3Ch,1Ch,0Ch,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00
 db 3Fh,3Fh,3Fh,3Fh,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,1Fh,1Fh
 db 1Fh,06,06,1Fh,1Fh,1Fh,00,00,00,3Fh,3Fh,1Fh,06,06,06,06,06,06,06,1Fh,1Fh,1Fh
 db 00,00,00,00,00
book1:
 db 80h,40h,20h,20h,20h,20h,20h,20h,20h,20h,40h
 db 0C0h,0C0h,40h,20h,20h,20h,20h,20h,20h,20h,20h,40h,80h
 db 0FFh,00h,11h,44h,11h,04h,00h,00h,51h,04h,00h,0FFh
 db 0FFh,00,10h,45h,10h,44h,00,00,11h,44h,00h,0FFh
 db 3Fh,2Ch,34h,1Ah,16h,1Ah,16h,1Ah,16h,1Ah,34h,3Fh,3Fh
 db 34h,1Ah,16h,1Ah,16h,1Ah,16h,1Ah,34h,2Ch,3Fh
book2:
 db 80h,40h,20h,20h,20h,0FCh,04,0A8h,08h,50h,20h,0C0h
 db 0C0h,40h,20h,20h,20h,20h,20h,20h,20h,20h,40h,80h
 db 0FFh,00,11h,44h,11h,3Fh,40h,42h,90h,05h,00h,0FFh
 db 0FFh,00,10h,45h,10h,44h,00,00,11h,44h,00,0FFh
 db 3Fh,2Ch,34h,1Ah,16h,1Ah,16h,1Ah,16h,1Bh,36h,3Fh
 db 3Fh,34h,1Ah,16h,1Ah,16h,1Ah,16h,1Ah,34h,2Ch,3Fh
book3:
 db 80h,40h,20h,20h,20h,20h,20h,20h,20h,20h,40h,0C0h
 db 0C0h,20h,90h,08h,08h,24h,44h,0F8h,20h,20h,40h,80h
 db 0FFh,00h,11h,44h,11h,04h,00h,00h,51h,04h,00h,0FFh
 db 0FFh,00h,12h,80h,49h,42h,64h,3Fh,11h,44h,00h,0FFh
 db 3Fh,2Ch,34h,1Ah,16h,1Ah,16h,1Ah,16h,1Ah,34h,3Fh,3Fh
 db 37h,1Bh,16h,1Ah,16h,1Ah,16h,1Ah,34h,2Ch,3Fh




dataqu:;ﾃﾞｰﾀ総量 65535
 db 0,0
data:;0,word,0,意味,0,やった回数,正解した回数,0ffh,~~~~
 db 0

end