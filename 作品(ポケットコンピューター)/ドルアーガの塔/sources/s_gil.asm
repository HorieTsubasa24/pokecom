org 0100h

overwrite:equ 0
x0:equ 30
xm:equ 140
y0:equ 0
ym:equ 47
t:equ 80h
f:equ 0
m:equ 80h
n:equ 0

grp:equ 0bfd0h
msp:equ 0bff1h
kwait:equ 0bcfdh
kscan:equ 0be53h



;*******************Title graph********************
start:
 ld HL,0
 add HL,SP
 ld (retP+1),HL
 ld (rec+1),HL
 ld (rec2+1),HL
 call cls 
 ld HL,graph_title
 ld DE,0008h
 ld B,50
 call grp_open
start_l:
 ld A,1
 ld (floor),A
 call keysc;left,right,on,0,/,space,down,up
 bit 2,A
 ret nz
 bit 3,A
 jr nz,before_game_c
 bit 5,A
 jr nz,init
 jr start_l
;*****************Continue*******************
before_game_c:
 bit 5,A
 jr z,start_l
 call cls
 ld HL,continue_ms
 ld DE,0102h
 ld B,18
 call msp
 ld HL,(floor)
 ld H,0
 call ascn
before_game_c_floor:
 ld HL,(floor)
 ld H,0
 call ascn
 ld HL,nmemry+3
 ld DE,030bh
 ld B,2
 call msp
 call kwait
 ld HL,floor
 cp 1eh
 jr z,Stating_before
 cp 20h
 jr z,before_game_c_u
 cp 1fh
 jr nz,before_game_c_floor
before_game_c_d:
 dec (HL)
 xor A
 cp (HL)
 jr nz,before_game_c_floor
 inc (HL)
 jr before_game_c_floor
before_game_c_u:
 inc (HL)
 ld A,(hi_floor)
 inc A
 cp (HL)
 jr nz,before_game_c_floor
 dec (HL)
 jr before_game_c_floor
 
 
 
;***************init************************** 
init:
 call init_c
 
;***************Starting game****************
;***************massage*********************

Stating_before:
rec:
 ld SP,0
 call stating_before_c

;***********************free aria cleen****************
 
 call freecls

;***********************map set************************
 call Map_make

;********************************obj set***************************

 call nextck

;***********************obj init************************
stating_obj:
 ld HL,obj
 ld (HL),0
 ld DE,obj+1
 ld BC,48+48+48+96+48+48
 ldir
;***********************obj countor**************
 ld HL,obj_1
 ld A,(floor)
 dec A
 jr z,stating_obj_1

 ld D,A
;*********************0=end sign****next floor data***ldi loop**********
stating_obj_2:
 ld BC,0
 ld A,0
 cpir
 dec D
 jr nz,stating_obj_2
stating_obj_1:
 ld DE,obj
stating_obj_3:
 ld A,(HL)
 or A
 jr z,stating_obj_7
 ldi
 jr stating_obj_3

;*********************obj cp= then goto mainbefore***************

stating_obj_7:
 ld HL,obj
 ld DE,0
stating_obj_4:
 xor A
 cp (HL)
 jp z,main_before;stating_obj_hp
 push HL
 push DE

;x=x+7*A
 ld A,R;call rand
 and 0fh;a=0~15
 ld HL,001eh;30
 ld DE,0007h
 call xsan



;y=y+7*A
 call rand
stating_obj_5:
 sub 7
 jr nc,stating_obj_5
 add A,7
 ld DE,0700h
 call xsan

 pop DE
 push HL;xy

 ld HL,obj_xy;address
 add HL,DE;address+

 call stating_obj_hp_wp

 add HL,DE;address++
 ld (stating_obj_6+1),HL
; add HL,DE;address++(direction)
 inc DE

 pop HL

; ld HL,151eh;(30,0)

stating_obj_6:
 ld (overwrite),HL
 ld (gil_xy),HL
 pop  HL
 inc HL
 jr stating_obj_4


;****************before farse***pgil_xy set**************

main_before:
 call main_before_c
 xor A
 call itemprint
 jp main_gil


;**************************************************************************
;***************************init sub****************************************
;**************************************************************************

init_c:
 ld HL,gil_matk
 ld DE,gil_matk+1
 ld BC,50
 ld A,0
 ld (HL),A
 ldir
 ret
 
 
Stating_before_c:
 call cls
 ld HL,stating_ms1
 ld DE,0108h
 ld B,9
 call msp
 ld HL,stating_ms2
 ld De,0208h
 ld B,10
 call msp
 ld HL,stating_msf
 ld De,0408h
 ld B,5
 call msp
 ld HL,(floor)
 ld H,0
 call ascn
 ld HL,nmemry+3
 ld DE,040eh
 ld B,2
 call msp
 call tim255
 call kwait
 ret
 
freecls:
 ld HL,dammy
 xor A
 ld (HL),A
 ld DE,dammy+1
 ld BC,23
 ldir
 ret

main_before_c:
 ld HL,(gil_xy)
 ld (pgil_xy),HL 
 ld HL,obj_1
 ld A,(floor)
 dec A
 jr z,main_before_15
 ld D,A
 xor A
 ld BC,0
main_before_1:
 cpir
 dec D
 jr nz,main_before_1
 ld HL,obj
 or A
 sbc HL,BC;it's start pointa**obj++


;******************door set****************************
main_before_15:
 push HL;obj
 ld A,83h
 ld BC,0
;main_before_2:
 cpir
 inc BC
 ld HL,obj_xy
 or A
 sbc HL,BC
 or A
 sbc HL,BC
 ld E,(HL)
 inc HL
 ld D,(HL)
 ld (pdoor_xy),DE

;*****************key set*******************************

 pop HL
 ld A,85h
 ld BC,0
;main_before_3:
 cpir
 inc BC
 ld HL,obj_xy
 or A
 sbc HL,BC
 or A
 sbc HL,BC
 ld E,(HL)
 inc HL
 ld D,(HL)
 ld (pkey_xy),DE
 xor A
 ld (key),A

;*********************obj cross gil********************

 ld HL,(gil_xy)
 ld C,L
 ld B,H
 ld HL,obj_xy
main_before_gil:
 push HL
 ld E,(HL)
 inc HL
 ld D,(HL)
 ex DE,HL
 or A
 sbc HL,BC
 pop HL
 jr z,main_before_gil_z
 inc HL
 inc HL
 jr main_before_gil
main_before_gil_z:
 inc HL
 inc HL
 ld A,(HL)
 or A
 jp nz,stating_obj
 
 ld A,(stating_obj_6+1)
 ld L,A
 ld A,(stating_obj_6+2)
 ld H,A
 ld A,21
 ld (HL),A
 inc HL
 ld A,42
 ld (HL),A
 ld (0f0h),HL
 ret
 
 
nextck:
 xor A
 ld (key),A
 ld A,(posion)
 cp 3
 jr nc,nextck2
 xor A
 ld (posion),A
nextck2:
 ld A,(floor)
 cp 10
 jr z,nextck3
 cp 15
 jr z,nextck3
 ret
nextck3:
 xor A
 ld (kndl),A
 ret

 
;*********************obs  hp  wp set*********************
stating_obj_hp_wp:
 push HL
 push DE

 ld HL,obj
 add HL,DE
 ld A,(HL)
 and 0fh
 bit 7,(HL)
 jr nz,stating_obj_hp_wp5
 bit 6,(HL)
 jr nz,stating_obj_hp_wp4
 bit 5,(HL)
 jr nz,stating_obj_hp_wp3
 bit 4,(HL)
 jr nz,stating_obj_hp_wp2
stating_obj_hp_wp1:
 ld HL,hp_table1
 jp stating_obj_hp_wp6
 ret
stating_obj_hp_wp2:
 ld HL,hp_table2
 jp stating_obj_hp_wp6
 ret
stating_obj_hp_wp3:
 ld HL,hp_table3
 jp stating_obj_hp_wp6
 ret
stating_obj_hp_wp4:
 ld HL,hp_table4
 jp stating_obj_hp_wp6
 ret
stating_obj_hp_wp5:
 ld HL,hp_table5
 jp stating_obj_hp_wp6
 ret
stating_obj_hp_wp6:
 ld E,A
 dec E
 ld D,0
 add HL,DE
 ld A,(HL)
 pop DE
 ld HL,obj_hp
 add HL,DE
 ld (HL),A
 
 pop HL
 and 01111111b
 ;********************************************************HP*******************************
 ld A,00111000b
 ld (gil_hp),A
 ret;gil is end of data.
 
 
;************************item print1*******************************************
 
itemprint:
 ld (iteme+1),HL
 call item_get
 ld A,(key)
 or A
 jr z,itemprint_matk
 ld HL,graph_key
 ld DE,0000h
 call grp_set
itemprint_matk:
 ld A,(matk)
 or A
 jr z,itemprint_boot
 call matk_set
 ld HL,graph_matk
 ld DE,0700h
 call grp_set
itemprint_boot:
 ld A,(boot)
 or A
 jr z,itemprint_po
 ld HL,graph_boot
 ld DE,0707h
 call grp_set
itemprint_po:
 ld A,(posion)
 or A
 jr z,itemprint_sword
 ld HL,graph_po
 ld DE,070eh
 call grp_set
itemprint_sword:
 ld A,(sword)
 or A
 jr z,itemprint_kndl
 ld HL,graph_sword
 ld DE,0e00h
 call grp_set
itemprint_kndl:
 ld A,(kndl)
 or A
 jr z,itemprint_gnt
 ld HL,graph_kndl
 ld DE,1500h
 call grp_set
itemprint_gnt:
 ld A,(gnt)
 or A
 jr z,itemprint_armor
 ld HL,graph_gnt
 ld DE,0e07h
 call grp_set
itemprint_armor:
 ld A,(armor)
 or A
 jr z,itemprint_shield
 ld HL,graph_armor
 ld DE,0e0eh
 call grp_set
itemprint_shield:
 ld A,(shield)
 or A
 jr z,itemprint_hlmt
 ld HL,graph_shield
 ld DE,1507h
 call grp_set
itemprint_hlmt:
 ld A,(hlmt)
 or A
 jr z,itemprint_nec
 call hlmt_set
 ld HL,graph_hlmt
 ld DE,1c00h
 call grp_set
itemprint_nec:
 ld A,(nec)
 or A
 jr z,itemprint_brns
 ld HL,graph_nec
 ld DE,150eh
 call grp_set
itemprint_brns:
 ld A,(brns)
 or A
 jr z,itemprint_meis
 ld HL,graph_brns
 ld DE,1c07h
 call grp_set
itemprint_meis:
 ld A,(meis)
 or A
 jr z,itemprint_rod
 ld HL,graph_meis
 ld DE,1c0eh
 call grp_set
itemprint_rod:
 ld A,(rod)
 or A
 jr z,itemprint_
 ld HL,graph_rod
 ld DE,2300h
 call grp_set
itemprint_:

 call grp_o
iteme:
 ld HL,overwrite
 ret
 
 
;****************************item set************************************
matk_set:
 cp 1
 jr z,cmtk
 cp 2
 jr z,smtk
gmtk:
 ld A,255
 ld (gil_matk_count),A
 ret
smtk:
 ld A,4
 ld (gil_matk_count),A
 ret
cmtk:
 ld A,2
 ld (gil_matk_count),A
 ret
 
hlmt_set:
 or A
 ret z
 cp 2
 jr z,ihlmt
 ld A,96
 ld (gil_hp),A
 ret
ihlmt:
 ld A,16
 ld (gil_hp),A
 ret

 
;**************item get*************************
item_get:
 or A
 ret z
 ld HL,graph_matk
 dec A
 ld DE,6
 call xsan
 ld DE,0007h
 call grp_set
 ret

stating_ms1:
 db "GET READY"
stating_ms2:
 db "PLAYER ONE"
stating_msf:
 db "FLOOR"
continue_ms:
 db "SELECT START FLOOR"
wall_grp:
 db 0ffh,0ffh,0ffh
pole_grp:
 db 1h
 
 
;*************************************************************************************
;********************************recover**********************************************
stating_rec:
rec2:
 ld SP,0
 call Stating_before_c
 call map_make
 call freecls
 xor A
 ld (key),A
; xor A
; ld (posion),A
 ld DE,(pgil_xy)
 ld (gil_xy),DE
stating_rec1:
 ld IX,obj_hp
 ld HL,obj_xy
 ld DE,0
stating_rec2:
 ld A,(IX-48)
 cp 8fh
 jp z,stating_rec3
 push DE
 call stating_obj_hp_wp
 call cross_ck_a
 jp c,obj_of
 pop DE
 inc HL
 inc HL
 inc DE
 inc IX
 jr  stating_rec2
 
obj_of:
 push HL
 ld DE,7
 ld HL,0
 call rand
 and 0eh
 call xsan
 ld DE,30
 add HL,DE
 ld A,L
 pop HL
 ld (HL),A
 push HL
 ld DE,7
 ld HL,0
 ld A,R
 and 06
 call xsan
 ld A,L
 pop HL
 inc HL
 ld (HL),A
 dec HL
 jp stating_rec1
 
stating_rec3:
 xor A
 ld (IX+46),A
 xor A
 call itemprint
 jp main_gil
 
 

main_gil:
 ld HL,graph_gil_ulf
 ld DE,(pgil_xy)
 call grp_set
 call grp_o
 call kwait
 ld A,00000010b
 ld (gil_st2),A
 ld HL,gil_xy+1
 set 7,(HL)

;**************************************************************************************
;************************************Main*********************************************
;**************************************************************************************
main:
 call grp_o
; call tim30
 ld A,48
 ld (count+1),A
 ld HL,obj_xy
 ld IX,obj_hp
 ld IY,obj_st2
mains:
; ret
count:
 ld A,overwrite
 or A
 jp z,main
;unknown_ID_throght(0)
 ld A,(IX-48)
 or A
 jp z,mains_end
;count out then main

;hp_zero_throght

 ld A,(IX)
 or A
 jp z,mains_end
 
;graph_delete

 push HL;>
 ld E,(HL)
 inc HL
 ld D,(HL)
 call grp_del
 pop HL;<




;******************************ivent action **********************
 
 ld A,(IX-48)
 ld B,A
 and 0e0h
 jp nz,st_action
 ld A,B
 cp 0ah
 jp z,spells_action
 cp 0bh
 jp z,spells_action
 cp 0ch
 jp z,bress_action

;wp
 ld A,(IX+48)
 or A

;wp=0
 jp z,st_check



;wp>0
 dec A
 ld (IX+48),A
 ld A,(IX-48);(Syubetsu)
 bit 4,A
 jp z,sraim_move3_e;(suraimuGPRINT)
 jp wizard_move_e_wpp
; jp wizard_act_e
; jp nz,mains_end
; jp st_check
st_check:
 ld A,(IX+96)
 or A
 jp nz,st_dec

;wp=0,st=0
;wp setting((di)=move lutin)

 ld A,(IX-48);(Syurui)
 bit 4,A
 jr z,wp_str_b
 ld A,R;(wizard)
 and 00011111b
 set 5,A
 jr wp_str
wp_str_b:
 push AF
 ld A,R
 and 7fh
 ld B,A
 ld A,R
 and 7fh
 add A,B
 ld B,A
 pop AF
 cp 2
 jr c,wp_G
 jr z,wp_B
 cp 4
 ld A,B
 jr c,wp_R
 jr z,wp_BL
wp_D:
wp_DY:
 and 8
 jr wp_str
wp_BL:
wp_R:
 and 16
 jr wp_str
wp_B:
 ld A,B
 and 8
 jr wp_str
wp_G:
 ld A,B
 and 16
wp_str:
 add A,8
 ld (IX+48),A
 ld A,25
 ld (IX+96),A

 ld A,(IX-48);(Syubetsu)
 bit 4,A
 jp z,sraim_move3_e;(suraimuGPRINT)
 jp wizard_move_e_wpp;(wizard not print)mains_end
; jp Egraph;



;wp=0,st=x
st_dec:
 dec A
 ld (IX+96),A
 jp sraim_or_wiz_action
 
 
;***********************************knight,quox,ivent*********************************
st_action:;Individual action
; call bls
 ld A,(IX-48)
 cp 41h
 jp z,quox_action
 cp 42h
 jp z,quox_action
 cp 43h
 jp z,quox_action
 cp 44h
 jp z,quox_action
 cp 45h
 jp z,goast_action
 cp 46h
 jp z,goast_action
 bit 5,A
 jp nz,knight_action
 cp 81h
 jp z,druaga
 cp 85h
 jp z,key_action
 cp 84h
 jp z,door_action
 cp 83h
 jp z,box_action
 cp 86h
 jp z,excarivor
 cp 87h
 jp z,sacubus
 
 cp 8ah
 jp z,grod
 cp 8bh
 jp z,rrod
 cp 8ch
 jp z,brod
 cp 8dh
 jp z,ishitar
 cp 8eh
 jp z,kai
 
 cp 8fh
 jp z,gil_action
 jp mains_end

 ld (0f0h),A
 ld A,(IX-48)
 ld (0f4h),A
 ld A,(IX-0)
 ld (0f5h),A
 ld A,(IX+48)
 ld (0f6h),A
 ld A,(IX+96)
 ld (0f7h),A
 jp retP



















;****************************************************************************
;*********************************sraim or wiz*******************************

sraim_or_wiz_action:;HL=obj_xy++
 bit 4,(IX-48);(NO.)
 jp nz,wiz_action

 ;;;;
 ;;;;
 ld A,(IX+96);(st)
 
; ld (0f0h),A
; jp retP

 cp 9
 jr z,sraim_move1_B
 cp 5
 jr z,sraim_move1
 cp 1
 jr z,sraim_move3
 jp sraim_move3_e;mains_end


sraim_move1_B:
 ld A,(IX-48)
 cp 3
 jr c,sraim_move1_nspell
 call rand
 cp 64
 jr nc,sraim_move1_nspell
 call spell_create
sraim_move1_nspell:
 call wall_ck
 jr z,sraim_move1
 inc HL
 res 7,(HL)
 res 6,(HL)
 ld A,R
; rla
 rra
 rra
 rra
 and 0c0h
 or (HL)
 ld (HL),A
 dec HL
 ld A,80
 ld (IX+96),A
 jp sraim_move3_e
sraim_move1:


;graph_delete

; push HL;>
; call bls
; ld E,(HL)
; inc HL
; ld D,(HL)
; call grp_del
; pop HL;<


 inc HL
 ld A,(HL)
 and 0c0h
 jr z,sraim_move1_u
 cp 80h
 jr c,sraim_move1_r
 jr z,sraim_move1_d
sraim_move1_l:
 dec HL
 dec (HL)
 dec (HL)
 jr sraim_move3_e
sraim_move1_u:
 dec (HL)
 dec (HL)
 dec HL
 jr sraim_move3_e
sraim_move1_r:
 dec HL
 inc (HL)
 inc (HL)
 jr sraim_move3_e
sraim_move1_d:
 inc (HL)
 inc (HL)
 dec HL

 jr sraim_move3_e


sraim_move3:

 inc HL
 ld A,(HL)
 and 0c0h
 jr z,sraim_move3_u
 cp 80h
 jr c,sraim_move3_r
 jr z,sraim_move3_d
sraim_move3_l:
 dec HL
 dec (HL)
 dec (HL)
 dec (HL)
 jr sraim_move3_e
sraim_move3_u:
 dec (HL)
 dec (HL)
 dec (HL)
 dec HL
 jr sraim_move3_e
sraim_move3_r:
 dec HL
 inc (HL)
 inc (HL)
 inc (HL)
 jr sraim_move3_e
sraim_move3_d:
 inc (HL)
 inc (HL)
 inc (HL)
 dec HL
sraim_move3_e:
 ld DE,graph_sraimd
Egraph:;(DE=)
 ld (Egraph_put+1),DE
 push HL;>
 ld E,(HL)
 inc HL
 ld D,(HL)
Egraph_put:
 ld HL,overwrite
 call grp_set
 pop HL;<
 ld A,(IX-48)
 and 11111000b
 jp z,sraim_cross_ck;
 ret
 
sraim_cross_ck:
 ld A,(gil_st2)
 bit 7,A;(gil sworud MIRU)
 jr z,s1
 call cross_ck_a;s
 call c,cha_kill;(suraim HP=0)
 jr s2
s1:;(gil_st=0-x)
 call cross_ck_a
 jr nc,s2
 jp gil_killing
 
s2:
; jp c,retP
 jp mains_end


;******************wiz actions**Main***********************
wiz_action:
 ld A,(IX-48)
 cp 14h
 jr nz,wiz_action2
 ld A,(dammy+12)
 or A
 jp z,mains_end
wiz_action2:
 ld A,(IX+96)
 cp 24
 jp z,wiz_ap
 cp 12
 jp z,wiz_sp
 ld A,(IY)
 or A
 jp nz,wiz_dec
wiz_dec2:
 ld DE,magic
 call Egraph
;********************cross chack wiz*******************
wizard_cross_ck;
 ld A,(gil_st2)
 bit 7,A;(gil sworud MIRU)
 jr z,ss1
 call cross_ck_a;s
 call c,cha_kill;(suraim HP=0)
 jr ss2
ss1:;(gil_st=0-x)
 call cross_ck_a
 jr nc,wizard_end
; jp gil_killing
ss2:
wizard_end:
;********************wiz end***************************
 jp mains_end

wiz_ap:

gil_notaction_f:
 ld A,(gil_button)
 inc (IX+48)
 inc (IX+96)
 and 11000011b
 jp z,wizard_end
 dec (IX+48)
 dec (IX+96)
 
 ld A,(IX+96)
 ld A,10
 ld (IY),A
 call wiz_locate
 jp wiz_dec2
wiz_sp:
 call spell_create
 jp wiz_dec2
wiz_dec:
 inc (IX+96)
 dec (IY)
 ld A,(IY)
 jp wiz_dec2

;***********************wp>0 then noting*********************
wizard_move_e_wpp;wp>0
 jp mains_end

;***********************wiz_locate**************************
wiz_locate:

 push HL;>
 ld HL,gil_xy
 ld E,(HL);x
 inc HL
 ld D,(HL);y

; ld A,E
; ld (0f0h),A
; ld A,D
; ld (0f1h),A
 
 pop HL;<
 ld A,R
 ld C,A
 ld A,R
 and 00000011b
 or A
 jp z,wiz_locate_left
 cp 2
 jp c,wiz_locate_down
 jp z,wiz_locate_right
wiz_locate_up:
 ld A,D
 and 00111111b
 sub 14
 jr c,wiz_locate
 or 10000000b
 ld D,A
 
 ld A,E
 ld (HL),A
 inc HL
 ld A,D
 ld (HL),A
 dec HL
 
 jp wiz_locate_end
wiz_locate_left;
 ld A,E
 sub 14
 cp 30
 jr c,wiz_locate
 ld E,A
 
 ld A,D
 and 00111111b
 or 01000000b
 ld D,A
 
 ld A,E
 ld (HL),A
 inc HL
 ld A,D
 ld (HL),A
 dec HL
 
 jp wiz_locate_end
wiz_locate_down;
 ld A,D
 and 00111111b
 ld A,D
 add A,14
 cp 47+1
 jr nc,wiz_locate
 ld D,A
 
 ld A,E
 ld (HL),A
 inc HL
 ld A,D
 ld (HL),A
 dec HL
 
 jp wiz_locate_end
wiz_locate_right;
 ld A,E
 add A,14
 cp 135+1
 jp nc,wiz_locate
 ld E,A
 
 ld A,D
 and 00111111b
 or 11000000b
 ld D,A
 
 ld A,E
 ld (HL),A
 inc HL
 ld A,D
 ld (HL),A
 dec HL
 
 jp wiz_locate_end
 
;
wiz_locate_end:
 call wall_mod
 ld A,(HL)
 sub C
 ld (HL),A 
 inc HL;>
 ld A,(HL)
 sub B
 ld (HL),A
 and 00111111b
 cp 7*6
 jr nz,wizle
 ld (dammy+3),A
wizle:
 dec HL;<
 ret
 
;******************************goast action***************************
goast_action:
 ld A,(IX+96)
 ld B,A
 ld A,(IX)
 cp B
 jr c,goast_action_b
 ld (IX+96),A
goast_action_b:
 ld A,(IX+48)
 or A
 jp z,goast_action_a
 dec A
 ld (IX+48),A
 jp z,goast_warp_ap
 jp goast_end
goast_action_a:
 call wall_mod
 ld A,C
 or A
 jp nz,goast_move
 ld A,B
 or A
 jp nz,goast_move 
 
goast_action_0:
 call rand4
 cp 0a0h
 jr c,goast_action_1
 call spell_create
goast_action_1:
 call xyload
 ld A,(gil_xy)
 sub E
 jr nc,goast_cp1
 jr z,goast_y
 neg
goast_cp1:
 ld C,A
 ld A,(gil_xy+1)
 and 00111111b
 sub D
 jr nc,goast_cp2
 jr z,goast_x
 neg
goast_cp2:
 cp C
 jr c,goast_x 
goast_y:
 call y_ck
 jr c,goast_up
 jr goast_do
goast_x:
 call x_ck
 jr c,goast_le
 jr goast_ri
goast_le:
 inc HL
 set 7,(HL)
 set 6,(HL)
 dec HL
 jr goast_wc
goast_ri:
 inc HL
 res 7,(HL)
 set 6,(HL)
 dec HL
 jr goast_wc
goast_up:
 inc HL
 res 7,(HL)
 res 6,(HL)
 dec HL
 jr goast_wc
goast_do:
 inc HL
 set 7,(HL)
 res 6,(HL)
 dec HL
 jr goast_wc
goast_wc:
 call wall_ck
 jr z,goast_move
 jp goast_warp
goast_move:
 call empty_move
goast_end:
 
;*****************************cross ck goast*****************************
 ld A,(IX-48)
 cp 81h
 jp z,druaga_cross

 ld A,(gil_st2)
 or A
 jr z,sssss1
 bit 7,A
 jr z,sssss0
 call cross_ck_a;s
 call c,HP_decB;
 jr z,sssss2
sssss0:
 call cross_ck_a;
 jr sssss2
sssss1:;(gil_st=0-x)
 call cross_ck_a
 jr nc,sssss2
 jp gil_killing
sssss2:
 ld A,(kndl)
 or A
 jp z,mains_end
 ld DE,graph_goast
 call Egraph
 jp mains_end
 
;****************************goast sub*********************************** 
goast_warp:
 ld A,18
 ld (IX+48),A
 jp goast_end
 
goast_warp_ap:
 inc HL
 ld A,(HL)
 dec HL
 and 11000000b
 jr z,goast_warp_ap_u
 cp 80h
 jr c,goast_warp_ap_r
 jr z,goast_warp_ap_d
goast_warp_ap_l:
 ld A,(HL)
 sub 7
 ld (HL),A
 jr goast_warp_ap_e
goast_warp_ap_u:
 inc HL
 ld A,(HL)
 sub 7
 ld (HL),A
 dec HL
 jr goast_warp_ap_e
goast_warp_ap_r:
 ld A,(HL)
 add A,7
 ld (HL),A
 jr goast_warp_ap_e
goast_warp_ap_d:
 inc HL
 ld A,(HL)
 add A,7
 ld (HL),A
 dec HL
 jr goast_warp_ap_e
goast_warp_ap_e:
 ld A,(dammy+8)
 inc A
 ld (dammy+8),A
 jp goast_end
 
;******************************spell create*************************** 
;******************************spell create*************************** 
spell_create:
 push HL
 ld HL,obj
 xor A
 ld BC,0
 cpir;BC<0
 inc BC
 
 
; ld (HL),0;chr clr
 dec HL;spell address
 ld A,(IX-48)
 cp 4h
 jr z,spellB
 ld A,(IX-48)
 cp 13h
 jr z,spellB
 cp 14h
 jr z,spellB
 cp 46h
 jr z,spellB
 cp 41h
 jr z,bress
 cp 42h
 jr z,bress
 cp 43h
 jr z,bress
 cp 44h
 jr z,bress
 ld (HL),0Ah
 jr spellsetok
spellB:
 ld (HL),0Bh
 jr spellsetok
bress:
 ld (HL),0ch
spellsetok:
;hp
 ld DE,48
 add HL,DE
 ld (HL),1
 ;st2
 ld DE,48*5
 add HL,DE
 ld (HL),0
 
 pop HL
 
; ld (0f4h),HL

 ld A,(HL)
 ld E,A
 inc HL
 ld A,(HL)
 ld D,A
 dec HL
 
 push HL
 ld HL,0
 or A
 sbc HL,BC;xy_countor
 or A
 sbc HL,BC
 ld BC,obj_xy
 add HL,BC
 
 
 ld A,E
 ld (HL),A
 inc HL
 ld A,D
 ld (HL),A
 
; ld (0f0h),HL
; ld (0f2h),BC
 
 
 pop HL
 ret
;******************************spell action****************************
spells_action:
 ld A,(IY)
 cp 1
 jp z,spells_action1
 cp 2
 jp z,spells_action2

 call wall_mod
 ld A,B
 or A
 jp nz,spells_action_delete
 ld A,C
 or A
 jp nz,spells_action_delete
 
 call wall_ck
 jp nz,spells_action_dol
 
 ld A,(HL)
 cp 30
 jp c,spells_action_delete
 cp 141
 jp nc,spells_action_delete
 
 inc HL
 ld A,(HL)
 dec HL
 and 00111111b
 cp 48
 jp nc,spells_action_delete
 
spells_action_wiz:
 inc HL
 ld A,(HL)
 dec HL
 and 11000000b
 jr z,spells_action_u
 cp 80h
 jr c,spells_action_r
 jr z,spells_action_d
spells_action_l:
 dec (HL)
 dec (HL)
 jr spells_action_urdl
spells_action_u:
 inc HL
 dec (HL)
 dec (HL)
 dec HL
 jr spells_action_urdl
spells_action_r:
 inc (HL)
 inc (HL)
 jr spells_action_urdl
spells_action_d:
 inc HL
 inc (HL)
 inc (HL)
 dec HL
 jr spells_action_urdl
spells_action_urdl:
 ld A,1
 ld (IY),A
 jp spells_actionend
 
 
 
spells_action1:
 inc HL
 ld A,(HL)
 dec HL
 and 11000000b
 jr z,spells_action1_u
 cp 80h
 jr c,spells_action1_r
 jr z,spells_action1_d
spells_action1_l:
 dec (HL)
 dec (HL)
 jr spells_action1_urdl
spells_action1_u:
 inc HL
 dec (HL)
 dec (HL)
 dec HL
 jr spells_action1_urdl
spells_action1_r:
 inc (HL)
 inc (HL)
 jr spells_action1_urdl
spells_action1_d:
 inc HL
 inc (HL)
 inc (HL)
 dec HL
 jr spells_action1_urdl
spells_action1_urdl:
 ld A,2
 ld (IY),A
 jp spells_actionend
 
 

spells_action2:
 inc HL
 ld A,(HL)
 dec HL
 and 11000000b
 jr z,spells_action2_u
 cp 80h
 jr c,spells_action2_r
 jr z,spells_action2_d
spells_action2_l:
 dec (HL)
 dec (HL)
 dec (HL)
 jr spells_action2_urdl
spells_action2_u:
 inc HL
 dec (HL)
 dec (HL)
 dec (HL)
 dec HL
 jr spells_action2_urdl
spells_action2_r:
 inc (HL)
 inc (HL)
 inc (HL)
 jr spells_action2_urdl
spells_action2_d:
 inc HL
 inc (HL)
 inc (HL)
 inc (HL)
 dec HL
 jr spells_action2_urdl
spells_action2_urdl:
 ld A,0
 ld (IY),A
 jp spells_actionend
spells_action_dol:
 ld A,(IX-48)
 cp 0bh
 push HL
 call z,matk_action
 pop HL
 jp spells_action_delete
 
spells_actionend:
spells_action_cross

;********************cross chack spell*******************
spell_cross_ck;
 call cross_ck_a;s
 jr nc,spell_cross_ck_end
spell_cross_ck_1:

 ld A,(gil_xy+1)
 and 11000000b
 rla
 rla
 rla
 ld B,A
 inc HL
 ld A,(HL)
 dec HL
 and 11000000b
 rla
 rla
 rla
 inc A
 inc A
 and 00000011b
 ld C,A
 push BC

 ld A,(gil_st2)
 bit 7,A;(gil sworud MIRU)
 jr nz,spell_cross_ck_s
spell_cross_ck_n:
 pop BC
 ld A,C
 xor B;urdl = turdl
 jp z,spells_action_delete_g
 jp gil_killing
spell_cross_ck_s:
 pop BC
 ld A,C
 inc A
 and 00000011b
 xor B;urdl = turdl
 jp z,spells_action_delete_g
 jp gil_killing
spell_cross_ck_end:
 ld DE,graph_spell
 call Egraph;call Egraph
 jp mains_end
 
spells_action_delete_g
 ld A,(dammy+1)
 inc A
 ld (dammy+1),A
spells_action_delete:
 xor A
 ld (IX-48),A
 ld (IX),A
 ld (IY),A
 ld (HL),0
 inc HL
 ld (HL),0
 dec HL
 jp mains_end
 
;******************************bress action****************************
bress_action:

 call wall_mod
 ld A,B
 or A
 jp nz,spells_action_delete
 ld A,C
 or A
 jp nz,spells_action_delete
 call wall_ck
 jp nz,spells_action_delete
 
 inc HL
 ld A,(HL)
 dec HL
 and 11000000b
 jr z,bress_u
 cp 80h
 jr c,bress_r
 jr z,bress_d
bress_l:
 dec (HL)
 dec (HL)
 dec (HL)
 dec (HL)
 dec (HL)
 dec (HL)
 dec (HL)
 jr bress_e
bress_d:
 inc HL
 inc (HL)
 inc (HL)
 inc (HL)
 inc (HL)
 inc (HL)
 inc (HL)
 inc (HL)
 dec HL
 jr bress_e
bress_r:
 inc (HL)
 inc (HL)
 inc (HL)
 inc (HL)
 inc (HL)
 inc (HL)
 inc (HL)
 jr bress_e
bress_u:
 inc HL
 dec (HL)
 dec (HL)
 dec (HL)
 dec (HL)
 dec (HL)
 dec (HL)
 dec (HL)
 dec HL
 jr bress_e
bress_e:
bress_cross_ck:
 ld A,(nec)
 cp 2
 jr nc,bress_action_end
 call cross_ck_a;s
 call c,gil_killing;(suraim HP=0)

bress_action_end:
 ld DE,graph_brack
 call Egraph
 jp mains_end


 jp mains_end
 
 
 
;***************************************************************
;**************************knight action************************
knight_action:;HL=obj_xy++
;******************ricaba*******************
 ld A,(IX+96)
 ld B,A
 ld A,(IX)
 cp B
 jr c,knight_actiona
 ld (IX+96),A
knight_actiona:
 ld A,(IX-48)
 cp 23h
 jr z,knight_action1
 cp 27h
 jr z,knight_action1
 ld A,(IX+48)
 or A
 jp z,knight_action_end

knight_action1:
 call wall_mod
 ld A,B
 or A
 jp nz,knight_move
 ld A,C
 or A
 jp nz,knight_move
 
 call xy_ck
 jp z,knight_xy
 call x_ck
 jp z,knight_x
 call y_ck
 jp z,knight_y
kight_accel:

 
 call right_turn
 call wall_ck
; call z,48381
 jp z,knight_move
 call left_turn
 
 call wall_ck
 jp nz,rndurdl
 jp knight_move
kight_accel_2:
rndurdl:
 call right_turn
 call wall_ck
 jp z,knight_move

 call right_turn 
 call right_turn
 call wall_ck
 jp z,knight_move
 
 call left_turn 
 jp knight_move


knight_xy:
 inc HL
 ld A,(HL)
 or 11000000b
 ld (HL),A
 dec HL
 call wall_ck
 jp z,knight_move
 jp kight_accel_2 
 
knight_x:
 call y_ck
 jr c,knight_x_1
 inc HL
 set 7,(HL)
 res 6,(HL)
 dec HL
 jr knight_x_2
knight_x_1:
 inc HL
 res 7,(HL)
 res 6,(HL)
 dec HL
knight_x_2:
 call wall_ck
 jp z,knight_move
 ld A,(IX-48)
 cp 27h
 jr nz,rndurdl3
 jp knight_action_end
rndurdl3:
 jp kight_accel_2 
 
knight_y:
 call x_ck
 jr c,knight_y_1
 inc HL
 res 7,(HL)
 set 6,(HL)
 dec HL
 jr knight_y_2
knight_y_1:
 inc HL
 set 7,(HL)
 set 6,(HL)
 dec HL
knight_y_2:
 call wall_ck
 jp z,knight_move
 ld A,(IX-48)
 cp 27h
 jr nz,rndurdl2
 jp knight_action_end
rndurdl2:
 jp kight_accel_2 
 






knight_move:;a=0~3
 ld DE, knight_action_end
 push DE
empty_move:
 inc HL
 ld A,(HL)
 dec HL
 and 11000000b
 jr z,knight_action_up
 cp 80h
 jr c,knight_action_ri
 jr z,knight_action_do
knight_action_le:
 dec (HL)
 ret
knight_action_up:
 inc HL
 dec (HL)
 dec HL
 ret
knight_action_ri:
 inc (HL)
 ret
knight_action_do:
 inc HL
 inc (HL)
 dec HL
 ret

 
 


knight_action_end:
 ld A,(IY+48)
 xor 1
 and 00000001b
 ld (IY+48),A
 or A
 jr z,knight_action_end2
 
 ld DE,graph_n_knightu
 jr knight_action_end3
knight_action_end2:
 ld DE,graph_n_knightu+24
knight_action_end3:
 call Egraph
 
 
;********************chack knight cross*******************
; call kwait

 push HL
 ld HL,(obj_xy)
 ld (dammy+6),HL
 pop HL


 ld A,(gil_st2)
 or A
 jr z,ssss1
 bit 7,A;(gil sworud MIRU) 
 jr z,ssss0
 call cross_ck_a;s
 call c,HP_dec;(suraim HP=0)
 jr ssss2
ssss0:
 call cross_ck_a;s
 call c,HP_dec_swdbc
 jr ssss2
ssss1:;(gil_st=0-x)
 call cross_ck_a
 jr nc,ssss2
 jp gil_killing
ssss2:
 ld A,(IX+48)
 xor 0ffh
 ld (IX+48),A
 jp mains_end
 


knight_front_ck:
 call xyload
 push AF
 ld (knight_front_ck_end+3),A
 ld A,E
 ld (knight_front_ck_end+1),A 
 pop AF
 and 11000000b
 jr z,knight_front_ck_u
 cp 2
 jr c,knight_front_ck_r
 jr z,knight_front_ck_d
knight_front_ck_l:
 ld A,E
 sub 7
 cp 30
 jp c,knight_front_outerwall
 jr knight_front_ck_e
knight_front_ck_u:
 ld A,D
 sub 7
 jp c,knight_front_outerwall
 jr knight_front_ck_e
knight_front_ck_r:
 ld A,E
 add A,7
 cp 136
 jp nc,knight_front_outerwall
 jr knight_front_ck_e
knight_front_ck_d:
 ld A,D
 add A,7
 cp 43
 jp nc,knight_front_outerwall
 jr knight_front_ck_e
knight_front_ck_e:
 call right_turn
 call wall_ck
 jp z,knight_front_ck_end

 call left_turn
 call wall_ck
 jp z,knight_front_ck_end

 call left_turn
 call wall_ck
 jp z,knight_front_ck_end
 
 call right_turn
 call right_turn
 
 inc HL
 ld A,(HL)
 and 11000000b
 ld B,A
 ld A,(knight_front_ck_end+3)
 and 00111111b
 or B
 ld (knight_front_ck_end+3),A
 dec HL
 
 jr knight_front_ck_e
 
knight_front_ck_end:
 ld E,overwrite
 ld D,overwrite
 ld A,E
 ld (HL),A
 inc HL
 ld A,D
 ld (HL),A
 dec HL
 jp knight_move

knight_front_outerwall:
 jp kight_accel_2



;************************************************************************
;***********************quox action***************************************

quox_action:
 ld A,(IX-48)
 cp 44h
 jr nz,quox_action_nf

 ld A,(dammy+13)
 cp 4
 jp c,mains_end

quox_action_nf:
 ld A,(IX+96)
 ld B,A
 ld A,(IX)
 cp B
 jr c,quox_actiona
 ld (IX+96),A
quox_actiona:
 ld A,(IY+48)
 cp 3
 jp nz,quox_action_end

quox_action1:

 
 call wall_mod
 ld A,B
 or A
 jp nz,quox_move
 ld A,C
 or A
 jp nz,quox_move
 
quox_bress:
 ld A,(IY)
 cp 5
 jp z,bress_create
 
 inc (IY)
 call xy_ck
 jp z,quox_xy
 call x_ck
 jp z,quox_x
 call y_ck
 jp z,quox_y
 
 
 
quox_accel:
 call right_turn
 call wall_ck
 jp z,quox_move
 call left_turn
 call wall_ck
 jp z,quox_move
 jp rndurdlq
 
quox_xy:
 inc HL
 ld A,(HL)
 or 11000000b
 ld (HL),A
 dec HL
 call wall_ck
 jp z,quox_move
 jp rndurdlq 
quox_x:
 call y_ck
 jr c,quox_x_1
 inc HL
 set 7,(HL)
 res 6,(HL)
 dec HL
 jr quox_x_2
quox_x_1:
 inc HL
 res 7,(HL)
 res 6,(HL)
 dec HL
quox_x_2:
 call wall_ck
 jp z,quox_move
 call matk_action
 call wall_ck
 jp z,quox_move
 jp rndurdlq
 
quox_y:
 call x_ck
 jr c,quox_y_1
 inc HL
 res 7,(HL)
 set 6,(HL)
 dec HL
 jr quox_y_2
quox_y_1:
 inc HL
 set 7,(HL)
 set 6,(HL)
 dec HL
quox_y_2:
 call wall_ck
 jp z,quox_move
 call matk_action
 call wall_ck
 jp z,quox_move
 jp rndurdlq
 
 
 
quox_action_end:
 ld A,(IY+48)
 inc A
 and 00000011b
 ld (IY+48),A
 cp 1
 jr z,quox_action_end2
 cp 3
 jr z,quox_action_end2
 
 ld DE,graph_quox_ulf
 jr quox_action_end3
quox_action_end2:
 ld DE,graph_quox_ulf+24
quox_action_end3:
 call Egraph

;********************chack quox cross*******************
; call kwait


 ld A,(gil_st2)
 or A
 jr z,ssssss1
 bit 7,A;(gil sworud MIRU) 
 jr z,ssssss0
 call cross_ck_a;s
 call c,HP_decC;(suraim HP=0)
 jr ssssss2
ssssss0:
 call cross_ck_a;s
 call c,HP_dec_swdbc
 jr ssssss2
ssssss1:;(gil_st=0-x)
 call cross_ck_a
 jr nc,ssssss2
 jp gil_killing
ssssss2:
 ld A,(IX+48)
 xor 0ffh
 ld (IX+48),A
 jp mains_end




quox_move:
 ld DE,quox_action_end
 push DE
 jp empty_move
 

rndurdlq:
 call right_turn
 call wall_ck
 jp z,quox_move

 call right_turn 
 call right_turn
 call wall_ck
 jp z,quox_move
 
 call left_turn 
 jp quox_move
 
bress_create:
 xor A
 ld (IY),A
 call wall_ck
 jr z,brsc
 call right_turn
brsc:
 call spell_create
 jp quox_action_end
 

;***************************ckeck sub****************************

xy_ck:;chr cp
 call xyload
 push HL;>
 ld HL,(gil_xy)
 ld A,H
 and 00111111b
 ld H,A
 sbc HL,DE
 pop HL;<
 ret
x_ck:
 call xyload
 ld A,(gil_xy)
 sub E
 ret
y_ck:
 call xyload
 ld A,D
 and 00111111b
 ld A,(gil_xy+1)
 and 00111111b
 sub D
 ret


xyload:;A=urdl D=none
 ld E,(HL)
 inc HL
 ld A,(HL)
 and 00111111b
 ld D,A
 dec HL
 ret

right_turn:
 inc HL
 ld A,(HL)
 and 11000000b
 add A,40H
 ld B,A
 ld A,(HL)
 and 00111111b
 or B
 ld (HL),A
 dec HL
 ret
 
left_turn:
 call right_turn
 call right_turn
 call right_turn
 ret

;*************************hp dec*****************************
HP_dec:
 ld A,(sword)
 cp 4
 jp z,gil_HP_dec
 
 cp 3
 ld A,(IX)
 jr nz,HP_dec1
 dec A
 jr z,HP_dec2
HP_dec1:
 dec A
HP_dec2:
 ld (IX),A
 jr z,HP_rec
HP_dec_swdbc:
gil_HP_dec:
 ld A,(gil_hp)
 dec A
 ld (gil_hp),A
 jp z,gil_killing
 ret
 
HP_decB:
 ld A,(sword)
 cp 4
 ret z
 cp 2
 ld A,(IX)
 jr nz,HP_decb1
 dec A
 jr z,HP_decb2
HP_decb1:
 dec A
HP_decb2:
 ld (IX),A
 jr z,HP_rec2
 ret


HP_decC:;dragon
 ld A,(sword)
 cp 2
 jp c,HP_dec_swdbc
 
 ld A,(IX-48)
 cp 44h
 jr z,HP_decE
 jp HP_dec


HP_decD:;druaga
 ld A,(sword)
 cp 3
 jp c,gil_killing
 ld A,(gnt)
 cp 2
 jp c,gil_killing
 ld A,(armor)
 cp 2
 jp c,gil_killing
 ld A,(shield)
 cp 2
 jp c,gil_killing
 ld A,(hlmt)
 cp 1
 jp c,gil_killing
 ld A,(rod)
 cp 3
 jp c,gil_killing
 jp HP_dec
 
HP_decE:;ruby meis
 ld A,(meis)
 or A
 jp z,gil_killing
 call cha_kill
 ld A,1
 ld (dammy+14),A
 jp mains_end

HP_rec:
 ld A,(IX+96)
 ld B,A
 xor A
 ld (IX+96),A
 ld A,(gil_HP)
 add A,B
 jr nc,H_recP2
 ld A,255
H_recP2:
 ld (gil_HP),A
HP_rec2:
 ld A,1
 ld (dammy+12),A
 xor A
 ld (IX),A
 ld (IX+48),A
 ld (IX+96),A
 ld (IY),A
 push HL
 ld E,(HL)
 inc HL
 ld D,(HL)
 call grp_del
 pop HL
 ret

;*************************key actions************************
key_action:
 ld A,(key)
 or A
 jr z,key_action_1
 xor A
 call itemprint
 xor A
 ld (IX),A
 jp mains_end
key_action_1:
 push HL
 call cross_ck_a
 pop HL
 jr nc,key_action_end
 ld A,1
 ld (key),A
key_action_end:
 ld DE,graph_key
 call Egraph
 jp mains_end

;*************************************************************
excarivor:
 ld A,(posion)
 cp 4
 jr z,ext
 jp box_action_end
ext:
 ld A,(IX+48)
 or A
 jp nz,mains_end
 push HL
 call cross_ck_a
 pop HL
 jp nc,box_action_end
 ld A,(brns)
 or A
 jr nz,exttu
 ld A,4
 ld (sword),A
 jr exttt
exttu:
 ld A,3
 ld (sword),A
exttt:
 xor A
 ld (brns),A
 ld (posion),A
 ld A,03h+1
 call itemprint
 ld A,1
 ld (IX+48),A
 jp mains_end


grod:
 ld A,(dammy+10)
 or A
 jp z,mains_end
 
 push HL
 ld DE,0a34fh
 ld (HL),E
 inc HL
 ld (HL),D
 
 ld DE,0a34fh+7
 ld HL,(gil_xy)
 or A
 sbc HL,DE
 ld HL,dammy+11
 jr nz,groda
 set 0,(HL)
groda:
 bit 0,(HL)
 jp z,grode
 pop HL
 ld DE,graph_3rod
 call Egraph
 jp mains_end
grode:
 pop HL
 jp mains_end
 
rrod:
 ld A,(dammy+11)
 or A
 jp z,mains_end
 
 push HL
 ld DE,874fh
 ld (HL),E
 inc HL
 ld (HL),D
 
 ld DE,874fh+7
 ld HL,(gil_xy)
 or A
 sbc HL,DE
 ld HL,dammy+12
 jr nz,rroda
 set 1,(HL)
rroda:
 bit 1,(HL)
 jp z,rrode
 pop HL
 ld DE,graph_3rod
 call Egraph
 jp mains_end
rrode:
 pop HL
 jp mains_end
 
brod:
 ld A,(dammy+13)
 or A
 jp z,mains_end
 
 push HL
 ld DE,954fh
 ld (HL),E
 inc HL
 ld (HL),D
 
 ld HL,(gil_xy)
 or A
 sbc HL,DE
 ld HL,dammy+14
 jr nz,broda
 set 2,(HL)
broda:
 bit 2,(HL)
 jp z,brode
 pop HL
 ld DE,graph_3rod
 call Egraph
 xor A
 ld (rod),A
 call itemprint
 
 push HL
 ld DE,954fh+7
 ld HL,(gil_xy)
 or A
 sbc HL,DE
 jp z,ending
 
 pop HL
 jp mains_end
brode:
 pop HL
 jp mains_end

ishitar:
 ld D,21
 ld E,135
 ld (HL),E
 inc HL
 ld (HL),D
 dec HL
 ld A,(dammy+10)
 or A
 jr z,ishitar_cross
 jp mains_end
ishitar_end:
 ld DE,graph_ishitar
 call Egraph
 jp mains_end
ishitar_cross:
 call cross_ck_a
 jr nc,ishitar_end
 ld A,(gil_st2)
 bit 7,A
 jp nz,gil_zapping
 ld A,1
 ld (dammy+10),A
 jr ishitar_end
 
kai:
 ld D,21
 ld E,30
 ld (HL),E
 inc HL
 ld (HL),D
 dec HL
 ld A,(dammy+13)
 or A
 jp nz,mains_end
 ld A,(dammy+12)
 or A
 jr nz,kai_cross
 ld DE,graph_spell
 call Egraph
 jp mains_end
kai_end:
 ld DE,graph_kai
 call Egraph
 jp mains_end
kai_cross:
 call cross_ck_a
 jr nc,kai_end
 ld A,(gil_st2)
 bit 7,A
 jp nz,gil_zapping
 ld A,1
 ld (dammy+13),A
 jr ishitar_end
 jp mains_end
 
ending:
 pop HL
 ld DE,954fh-7
 ld HL,graph_kai
 call grp_set
 call grp_o
 call tim255
 call tim255
 call tim255
 call tim255
 call 48381
 
 call cls
 ld DE,0004h
 ld B,18
 ld HL,endms
 call msp
 inc HL
 ld DE,0105h
 ld B,15
 call msp
 inc HL
 ld DE,020bh
 ld B,3
 call msp
 inc HL
 ld DE,0302h
 ld B,21
 call msp
 inc HL
 ld DE,0408h
 ld B,9
 call msp
 inc HL
 ld DE,0508h
 ld B,8
 call msp
eee:
 call 48381
 jp retp
 
 
endms:
 db "CONGRATURATIONS !!"
 db "NOW YOU SAVE KI"
 db "AND"
 db "THE ADVENTURE IS OVER"
 db "THANK YOU"
 db "t.s soft"
 
 db "T.S SOFT"
 
;**********************************************************
;*********************druaga*******************************

druaga:
 ld A,(dammy+14)
 or A
 jp z,mains_end
 jp goast_action
 
 
druaga_cross:

 ld A,(gil_st2)
 or A
 jr z,dsssss1
 bit 7,A
 jr z,dsssss0
 call cross_ck_a;s
 call c,HP_decD;
 jr z,dsssss2
dsssss0:
 call cross_ck_a;
 jr dsssss2
dsssss1:;(gil_st=0-x)
 call cross_ck_a
 jr nc,dsssss2
 jp gil_killing
dsssss2:
 ld A,(IY)
 xor 1
 and 00000001b
 ld (IY),A
 or A
 jr z,dsssss23
 ld DE,graph_druaga_ulf
 jr dsssss24
dsssss23:
 ld DE,graph_druaga_ulf+24
dsssss24:
 call Egraph
 jp mains_end

;**********************************************************
;**********************succubus****************************

sacubus:
 ld DE,graph_spell
 ld A,(dammy+4)
 or A
 jr nz,sacubus_end
 ld DE,graph_spell
 call Egraph
 jp mains_end
sacubus_end:
 ld DE,graph_ishitar
 call Egraph
 
 ld A,(gil_st2)
 bit 7,A;(gil sworud MIRU)
 jr z,i1
 call cross_ck_a;s
 call c,dammy_11
 call c,cha_kill;(suraim HP=0)
 jr i2
i1:;(gil_st=0-x)
 call cross_ck_a
 jr nc,i2
 jp gil_killing
 
i2:
; jp c,retP
 jp mains_end

dammy_11:
 ld A,1
 ld (dammy+10),A
 ret

;**************************box action*************************
box_action:
 ld DE,(pgil_xy)
 ld A,E
 ld (HL),A
 ld A,D
 inc HL
 ld (HL),A
 dec HL

 ld A,(IX+48)
 or A
 ld A,(floor)
 jr nz,box_actiont
 
 dec A
 exx
 add A,A
 ld E,A
 ld D,0
 ld HL,box_action_table_farse
box_action2:
 add HL,DE
 ld E,(HL)
 inc HL
 ld D,(HL)
 ex DE,HL
 
 ld (0f0h),HL
; ret
 
 jp (HL)
box_actiont:
 dec A
 exx
 add A,A
 ld E,A
 ld D,0
 ld HL,box_action_table_true
 jr box_action2
box_action_table_farse:
 dw floor1,floor2,floor3,floor4,floor5,floor6,floor7,floor8,floor9,floor10
 dw floor11,floor12,floor13,floor14,floor15,floor16,floor17,floor18,floor19,floor20
 dw floor21,floor22,floor23,floor24,floor25,floor26,floor27,floor28,floor29,floor30
 dw floor31,floor32,floor33,floor34,floor35,floor36,floor37,floor38,floor39,floor40
 dw floor41,floor42,floor43,floor44,floor45,floor46,floor47,floor48,floor49,floor50
 dw floor51,floor52,floor53,floor54,floor55,floor56,floor57,floor58,floor59,floor60
box_action_table_true:
 dw floor1t,floor2t,floor3t,floor4t,floor5t,floor6t,floor7t,floor8t,floor9t,floor10t
 dw floor11t,floor12t,floor13t,floor14t,floor15t,floor16t,floor17t,floor18t,floor19t,floor20t
 dw floor21t,floor22t,floor23t,floor24t,floor25t,floor26t,floor27t,floor28t,floor29t,floor30t
 dw floor31t,floor32t,floor33t,floor34t,floor35t,floor36t,floor37t,floor38t,floor39t,floor40t
 dw floor41t,floor42t,floor43t,floor44t,floor45t,floor46t,floor47t,floor48t,floor49t,floor50t
 dw floor51t,floor52t,floor53t,floor54t,floor55t,floor56t,floor57t,floor58t,floor59t,floor60t


;***********************floor1******************************
floor1:
 exx
 ld A,(dammy)
 cp 3
 jp c,mains_end
 ld (IX+48),A
 jp mains_end
floor1t
 exx
 ld A,(matk)
 or A
 jp nz,mains_end
 push HL
 call cross_ck_a
 pop HL
 jp nc,box_action_end
 ld A,1
 ld (matk),A
 ld A,2
 ld (gil_matk_count),A
 ld A,1h
 call itemprint
 jp mains_end
 
 

;***********************floor2******************************
floor2:
 exx
 
 ld A,(dammy)
 cp 2
 jp c,mains_end
 ld (IX+48),A
 jp mains_end
floor2t
 exx
 ld A,(boot)
 or A
 jp nz,mains_end
 push HL
 call cross_ck_a
 pop HL
 jp nc,box_action_end
 ld A,1
 ld (boot),A
 ld A,1h+1
 call itemprint
 jp mains_end


;***********************floor3******************************
floor3:
 exx
 ld A,(obj_hp)
 or A
 jp nz,mains_end
 ld A,1
 ld (IX+48),A
 jp mains_end
floor3t:
 exx
 ld A,(posion)
 cp 1
 jp z,mains_end
 push HL
 call cross_ck_a
 pop HL
 jp nc,box_action_end
 ld A,1
 ld (posion),A
 ld A,2h+1
 call itemprint
 ld A,64
 ld (gil_hp),A
 jp mains_end
 
;***********************floor4*****************************
floor4:
 exx
 jp mains_end
floor4t:
 exx
 jp mains_end
 
;***********************floor5*****************************
floor5:
 exx
 ld A,(dammy+1)
 cp 4
 jp c,mains_end
 ld A,1
 ld (IX+48),A
 jp mains_end
floor5t:
 exx
 ld A,(sword)
 or A
 jp nz,mains_end
 push HL
 call cross_ck_a
 pop HL
 jp nc,box_action_end
 ld A,1
 ld (sword),A
 ld A,3h+1
 call itemprint
 jp mains_end
 
;***********************floor6*****************************
floor6:
 exx
 ld A,(gil_xy+1)
 and 00111111b
 jp nz,floor6l
 ld A,1
 ld (IX+96),A
floor6l:
 ld A,(IX+96)
 or A
 jp z,mains_end
 ld A,(gil_xy+1)
 and 00111111b
 cp 1
 jp nz,mains_end
 ld (IX+48),A
 jp mains_end
floor6t:
 exx
 ld A,(kndl)
 or A
 jp nz,mains_end
 call cross_ck_a
 jp nc,box_action_end
 ld A,1
 ld (kndl),A
 ld A,6h+1
 call itemprint
 jp mains_end
;***********************floor7*****************************
floor7:
 exx
 ld A,(dammy+2)
 or A
 jp z,mains_end
 ld A,1
 ld (IX+48),A
 jp mains_end
floor7t:
 exx
 ld A,(matk)
 or A
 jp nz,mains_end
 call cross_ck_a
 jp nc,box_action_end
 ld A,2
 ld (matk),A
 ld A,4
 ld (gil_matk_count),A
 ld A,0h+1
 call itemprint
 jp mains_end
 
floor8:
 exx
 call wall_mod
 ld A,B
 cp 1
 jp z,mains_end
 ld A,C
 or A
 jp nz,mains_end
 ld A,(gil_button)
 bit 5,A
 jp z,mains_end
 ld (IX+48),A
 jp mains_end
floor8t
 exx
 ld A,(posion)
 cp 1
 jp z,mains_end
 call cross_ck_a
 jp nc,box_action_end
 ld A,1
 ld (posion),A
 ld A,64
 ld (gil_hp),A
 ld A,2h+1
 call itemprint
 jp mains_end
 
floor9:
 exx
 ld DE,(gil_xy)
 ld A,D
 and 00111111b
 jp nz,mains_end
 ld A,E
 cp 30+7*8
 jp z,floor9l
 cp 30+7*9
 jp nz,mains_end
floor9l:
 ld A,1
 ld (IX+48),A
 jp mains_end
floor9t
 exx
 ld A,(posion)
 cp 2
 jp z,mains_end
 call cross_ck_a
 jp nc,box_action_end
 ld A,2
 ld (posion),A
 ld A,16
 ld (gil_hp),A
 ld A,2h+1
 call itemprint
 jp mains_end
 
floor10:
 exx
 ld A,(dammy+1)
 or A
 jp z,mains_end
 ld A,1
 ld (IX+48),A
 jp mains_end
floor10t:
 exx
 ld A,(gnt)
 or A
 jp nz,mains_end
 call cross_ck_a
 jp nc,box_action_end
 ld A,1
 ld (gnt),A
 ld A,4h+1
 call itemprint
 jp mains_end
 
 
floor11:
 exx
 ld A,(gil_xy+1)
 and 00111111b
 cp 42
 jr nz,floor11l
 ld A,1
 ld (IX+96),A
floor11l:
 ld A,(IX+96)
 or A
 jp z,mains_end
 ld A,(gil_xy+1)
 and 00111111b
 cp 41
 jp nz,mains_end
 ld A,1
 ld (IX+48),A
 jp mains_end
floor11t:
 exx
 ld A,(kndl)
 or A
 jp nz,mains_end
 call cross_ck_a
 jp nc,box_action_end
 ld A,1
 ld (kndl),A
 ld A,6h+1
 call itemprint
 jp mains_end

floor12:
 exx
 ld A,(dammy+3)
 or A
 jp z,mains_end
 ld (IX+48),A
 jp mains_end
floor12t:
 exx
 ld A,(armor)
 or A
 jp nz,mains_end
 call cross_ck_a
 jp nc,box_action_end
 ld A,1
 ld (armor),A
 ld A,5h+1
 call itemprint
 jp mains_end
 
 
floor13:
 exx
 push HL
 ld HL,obj_hp
 ld A,(HL)
 or A
 jp nz,floor13l
 inc HL
 ld A,(HL)
 or A
 jp nz,floor13l
 inc HL
 ld A,(HL)
 or A
 jp nz,floor13l
 inc HL
 ld A,(HL)
 or A
 jp nz,floor13l
 inc HL
 ld A,(HL)
 or A
 jp nz,floor13l
 inc HL
 ld A,(HL)
 or A
 jp nz,floor13l
 inc HL
 ld A,(HL)
 or A
 jp nz,floor13l
 pop HL
 ld A,1
 ld (dammy+5),A
 ld (IX+48),A
 jp mains_end
floor13l:
 pop HL
 jp mains_end
floor13t:
 exx
 ld A,(dammy+4)
 or A
 jp z,mains_end
 ld A,(shield)
 or A
 jp nz,mains_end
 call cross_ck_a
 jp nc,box_action_end
 ld A,1
 ld (shield),A
 ld A,7h+1
 call itemprint
 jp mains_end
 
floor14:
 exx
 jp mains_end
floor14t:
 exx
 jp mains_end
 
floor15:
 exx
 push HL
 ld HL,dammy+6
 call xy_ck
 pop HL
 jp nz,mains_end
 ld A,(gil_st2)
 and 01111111b
 jp z,mains_end
 ld A,1
 ld (IX+48),A
 jp mains_end
floor15t:
 exx
 ld A,(nec)
 or A
 jp nz,mains_end
 call cross_ck_a
 jp nc,box_action_end
 ld A,1
 ld (nec),A
 ld A,8h+1
 call itemprint
 jp mains_end
 
floor16:
 exx
 ld A,(gil_xy)
 cp x0
 jr nz,floor16l1
 set 0,(IX+96)
floor16l1
 ld A,(gil_xy)
 cp 135
 jr nz,floor16l2
 set 1,(IX+96)
floor16l2:
 ld A,(IX+96)
 cp 3
 jp nz,mains_end
 ld (IX+48),A
 jp mains_end
floor16t:
 exx
 ld A,(kndl)
 cp 2
 jp z,mains_end
 call cross_ck_a
 jp nc,box_action_end
 ld A,2
 ld (kndl),A
 ld A,6h+1
 call itemprint
 jp mains_end

floor17:
 exx
 ld A,(dammy+8)
 cp 5
 jp c,mains_end
f17test:
 ld A,1
 ld (IX+48),A
 jp mains_end
floor17t
 exx
 ld A,(posion)
 cp 3
 jp z,mains_end
 call cross_ck_a
 jp nc,box_action_end
 ld A,3
 ld (posion),A
 ld A,2h+1
 call itemprint
 jp mains_end
 
floor18:
 exx
 ld A,(gil_xy)
 cp X0
 jr z,floor18_e
 cp 135
 jr z,floor18_e
 ld A,(gil_xy+1)
 and 00111111b
 jr z,floor18_e
 cp 42
 jr z,floor18_e

 inc (IX+96)
 ld A,(IX+96)
 or A
 jp nz,mains_end
 ld A,1
 ld (IX+48),A
 jp mains_end 
floor18_e:
 xor A
 ld (IX+96),A
 jp mains_end
floor18t
 exx
 ld A,(sword)
 cp 2
 jp z,mains_end
 ld A,(posion)
 cp 3
 jp nz,box_action_end
 call cross_ck_a
 jp nc,box_action_end
 ld A,2
 ld (sword),A
 xor A
 ld (posion),A
 ld DE,070eh
 call grp_del
 ld A,3h+1
 call itemprint
 jp mains_end
 
floor19:
 exx
 jp mains_end
floor19t:
 exx
 jp mains_end

floor20:
 exx
 push HL
 ld HL,obj_hp
 ld A,(HL)
 or A
 jp z,floor20e
 inc HL
 ld A,(HL)
 or A
 jp z,floor20e
 inc HL
 ld A,(HL)
 or A
 jp z,floor20e
 inc HL
 ld A,(HL)
 or A
 jp z,floor20e
 inc HL
 ld A,(HL)
 or A
 jp z,floor20e
 inc HL
 ld A,(HL)
 or A
 jp z,floor20e
 inc HL
 ld A,(HL)
 or A
 jp z,floor20e
 inc HL
 ld A,(HL)
 or A
 jp z,floor20e
 inc HL
 pop HL
 ld A,(key)
 or A
 jp z,mains_end
 ld A,1
 ld (IX+48),A
 jp mains_end 
floor20e:
 pop HL
 jp mains_end
floor20t
 exx
 ld A,(posion)
 cp 1
 jp z,mains_end
 call cross_ck_a
 jp nc,box_action_end
 ld A,1
 ld (posion),A
 ld A,64
 ld (gil_hp),A
 ld A,2h+1
 call itemprint
 jp mains_end


floor21:
floor21t:
floor22:
floor22t:
floor23:
floor23t:
 exx
 jp mains_end
 
floor24:
 exx
 push HL
 ld HL,pgil_xy
 call xy_ck
 pop HL
 jp nz,mains_end
 ld A,(gil_st2)
 bit 7,A
 jp z,mains_end
 ld (IX+48),A
 jp mains_end
floor24t:
 exx
 ld A,(brns)
 or A
 jp nz,mains_end
 call cross_ck_a
 jp nc,box_action_end
 ld A,1
 ld (brns),A
 ld A,0ah+1
 call itemprint
 jp mains_end
floor25:
floor25t:
 exx
 jp mains_end
 
 
floor26:
 exx
; jp f26t
 push HL
 ld B,0
 ld HL,obj_hp
 ld A,(HL)
 or A
 jp nz,floor26a
 inc B
floor26a:
 inc HL
 ld A,(HL)
 or A
 jp nz,floor26b
 inc B
floor26b:
 inc HL
 ld A,(HL)
 or A
 jp nz,floor26c
 inc B
floor26c:
 pop HL
 ld A,B
 cp 1
 jp c,mains_end
 jp z,floor26d
 cp 3
 jp c,floor26d
 jp mains_end
floor26d:
 ld A,(key)
 or A
 jp z,mains_end
f26t:
 ld A,1
 ld (IX+48),A
 jp mains_end
floor26t
 exx
 ld A,(gnt)
 cp 2
 jp z,mains_end
 cp 3
 jp z,mains_end
 call cross_ck_a
 jp nc,box_action_end
 ld A,(brns)
 or A
 jr nz,floor26tt
floor26ti:
 ld A,3
 ld (gnt),A
 jr floor26tl
floor26tt: 
 ld A,2
 ld (gnt),A
floor26tl:
 xor A
 ld (brns),A
 ld DE,1c07h
 call grp_del
 ld A,4h+1
 call itemprint
 jp mains_end
 
floor27:
 exx
 ld A,(obj_hp)
 or A
 jp nz,mains_end
 ld A,1
 ld (IX+48),A
 jp mains_end
floor27t
 exx
 ld A,(nec)
 cp 1
 jp nz,mains_end
 cp 2
 jp z,mains_end
 call cross_ck_a
 jp nc,box_action_end
 ld A,2
 ld (nec),A
 ld A,8h+1
 call itemprint
 jp mains_end
 
floor28:
floor28t:
 exx
 jp mains_end
 
floor29:
 exx
 ld A,(dammy+2)
 or A
 jp z,mains_end
 ld A,1
 ld (IX+48),A
 jp mains_end
floor29t:
 exx
 ld A,(matk)
 or A
 jp nz,mains_end
 call cross_ck_a
 jp nc,box_action_end
 ld A,3
 ld (matk),A
 ld A,255
 ld (gil_matk_count),A
 ld A,0h+1
 call itemprint
 jp mains_end
 
floor30:
 exx

 ld DE,(gil_xy)
 ld A,D
 and 00000111b
 cp 7
 jp nz,mains_end
 ld A,E
 cp 30+7*13
 jp z,floor30l
 cp 30+7*2
 jp nz,mains_end
floor30l:
 ld A,1
 ld (IX+48),A
 jp mains_end
floor30t
 exx
 ld A,(posion)
 cp 3
 jp z,mains_end
 call cross_ck_a
 jp nc,box_action_end
 ld A,3
 ld (posion),A
 ld A,2h+1
 call itemprint
 jp mains_end

floor31:
floor31t:
 exx
 jp mains_end
 
floor32:
 exx
 ld A,(gil_st2)
 bit 7,A
 jp z,mains_end
 inc (IX+96)
 ld A,(IX+96)
 cp 2
 jp c,mains_end
 ld (IX+48),A
 jp mains_end
floor32t:
 exx
 ld A,(brns)
 or A
 jp nz,mains_end
 call cross_ck_a
 jp nc,box_action_end
 ld A,1
 ld (brns),A
 ld A,0ah+1
 call itemprint
 jp mains_end


floor33:
 exx
 push HL
 ld HL,obj_xy
 call xy_ck
 pop HL
 jp nz,mains_end
 ld A,1
 ld (IX+48),A
 jp mains_end
floor33t:
 exx
 ld A,(shield)
 cp 1
 jp nz,mains_end
 cp 2
 jp z,mains_end
 call cross_ck_a
 jp nc,box_action_end
 ld A,(brns)
 or A
 jr nz,floor33tt
floor33ti:
 ld A,3
 ld (shield),A
 jr floor33tl
floor33tt: 
 ld A,2
 ld (shield),A
floor33tl:
 xor A
 ld (brns),A
 ld DE,1c07h
 call grp_del
 ld A,07h+1
 call itemprint
 jp mains_end
 
floor34:
floor34t:
 exx
 jp mains_end

floor35:
 exx
 push HL
 ld HL,obj_xy
 call xy_ck
 pop HL
 jp nz,mains_end
 ld A,1
 ld (IX+48),A
 jp mains_end
floor35t:
 exx
 ld A,(posion)
 cp 2
 jp z,mains_end
 call cross_ck_a
 jp nc,box_action_end
 ld A,2
 ld (posion),A
 ld A,16
 ld (gil_hp),A
 ld A,02h+1
 call itemprint
 jp mains_end
 
floor36:
 exx
 push HL
 ld HL,obj_xy
 call xy_ck
 pop HL
 jp nz,mains_end
 ld A,1
 ld (IX+48),A
 jp mains_end
floor36t:
 exx
 ld A,(brns)
 or A
 jp nz,mains_end
 call cross_ck_a
 jp nc,box_action_end
 ld A,1
 ld (brns),A
 ld A,0ah+1
 call itemprint
 jp mains_end
 
floor37:
 exx
 ld A,(obj_hp)
 or A
 jp nz,mains_end
 ld A,(obj_hp+1)
 or A
 jp nz,mains_end
 ld A,1
 ld (IX+48),A
 jp mains_end
floor37t
 exx
 ld A,(hlmt)
 or A
 jp nz,mains_end
 call cross_ck_a
 jp nc,box_action_end
 ld A,(brns)
 or A
 jr nz,floor37tt
floor37ti:
 ld A,2
 ld (hlmt),A
 jr floor37tl
floor37tt: 
 ld A,1
 ld (hlmt),A
floor37tl:
 xor A
 ld (brns),A
 ld DE,1c07h
 call grp_del
 ld A,09h+1
 call itemprint
 jp mains_end
 
floor38:
 exx
 ld A,(dammy+1)
 or A
 jp z,mains_end
 ld A,(gil_st2)
 bit 7,A
 jp z,floor38l
 ld (IX+48),A
 jp mains_end
floor38l:
 xor A
 ld (dammy+1),A
 jp mains_end
floor38t
 exx
 ld A,(rod)
 or A
 jp nz,mains_end
 call cross_ck_a
 jp nc,box_action_end
 ld A,1
 ld (rod),A
 ld A,0ch+1
 call itemprint
 jp mains_end
 
floor39:
floor39t
floor40:
floor40t
floor41:
floor41t:
floor42:
floor42t:
 exx
 jp mains_end
 
floor43:
 exx
 ld A,(obj_hp)
 or A
 jp nz,mains_end
 ld A,(obj_hp+1)
 or A
 jp nz,mains_end
 ld A,(obj_hp+2)
 or A
 jp nz,mains_end
 ld A,(obj_hp+3)
 or A
 jp nz,mains_end
 ld A,(obj_hp+4)
 or A
 jp nz,mains_end
 ld A,(obj_hp+5)
 or A
 jp nz,mains_end
 ld A,1
 ld (IX+48),A
 jp mains_end
floor43t:
 exx
 ld A,(posion)
 cp 2
 jp z,mains_end
 call cross_ck_a
 jp nc,box_action_end
 ld A,2
 ld (posion),A
 ld A,16
 ld (gil_hp),A
 ld A,02h+1
 call itemprint
 jp mains_end
 

floor44:
 exx
 ld A,(obj_hp)
 or A
 jp nz,mains_end
 ld A,(obj_hp+1)
 or A
 jp nz,mains_end
 ld A,(obj_hp+2)
 or A
 jp nz,mains_end
 ld A,(obj_hp+3)
 or A
 jp nz,mains_end
 ld A,1
 ld (IX+48),A
 jp mains_end
floor44t:
 exx
 ld A,(brns)
 or A
 jp nz,mains_end
 call cross_ck_a
 jp nc,box_action_end
 ld A,1
 ld (brns),A
 ld A,0ah+1
 call itemprint
 jp mains_end

floor45:
 exx
 ld A,(obj_hp)
 or A
 jp nz,mains_end
 ld A,(obj_hp+1)
 or A
 jp nz,mains_end
 ld A,(obj_hp+2)
 or A
 jp nz,mains_end
 ld A,(obj_hp+3)
 or A
 jp nz,mains_end
 ld A,1
 ld (IX+48),A
 jp mains_end
floor45t:
 exx
 ld A,(posion)
 cp 4
 jp z,mains_end
 call cross_ck_a
 jp nc,box_action_end
 ld A,4
 ld (posion),A
 ld A,02h+1
 call itemprint
 jp mains_end
 

floor46:
 exx
 push HL
 ld H,0
 ld L,30
 ld DE,(gil_xy)
 ld A,D
 and 00111111b
 ld D,A
 push DE
 or A
 sbc HL,DE
 jr nz,floor46a
 set 0,(IX+96)
floor46a:
 ld H,42
 ld L,30
 pop DE
 push DE
 or A
 sbc HL,DE
 jr nz,floor46b
 set 1,(IX+96)
floor46b:
 ld H,42
 ld L,135
 pop DE
 push DE
 or A
 sbc HL,DE
 jr nz,floor46c
 set 2,(IX+96)
floor46c:
 ld H,0
 ld L,135
 pop DE
 or A
 sbc HL,DE
 jr nz,floor46d
 set 3,(IX+96)
floor46d:
 pop HL
 ld A,(IX+96)
 cp 0fh
 jp nz,mains_end
 ld (IX+48),A
 jp mains_end
floor46t:
 exx
 ld A,(nec)
 cp 2
 jp nz,mains_end
 cp 3
 jp z,mains_end
 call cross_ck_a
 jp nc,box_action_end
 ld A,3
 ld (nec),A
 ld A,08h+1
 call itemprint
 jp mains_end

floor47:
 exx
 ld A,(obj_hp)
 or A
 jp nz,mains_end
 ld A,1
 ld (IX+48),A
 jp mains_end
floor47t
 exx
 ld A,(posion)
 cp 3
 jp z,mains_end
 call cross_ck_a
 jp nc,box_action_end
 ld A,3
 ld (posion),A
 ld A,2h+1
 call itemprint
 jp mains_end

floor48:
 exx
 push HL
 ld H,0
 ld L,30
 ld DE,(gil_xy)
 ld A,D
 and 00111111b
 ld D,A
 push DE
 or A
 sbc HL,DE
 jr nz,floor48a
 set 0,(IX+96)
floor48a:
 ld H,42
 ld L,30
 pop DE
 push DE
 or A
 sbc HL,DE
 jr nz,floor48b
 set 1,(IX+96)
floor48b:
 ld H,42
 ld L,135
 pop DE
 push DE
 or A
 sbc HL,DE
 jr nz,floor48c
 set 2,(IX+96)
floor48c:
 ld H,0
 ld L,135
 pop DE
 or A
 sbc HL,DE
 jr nz,floor48d
 set 3,(IX+96)
floor48d:
 pop HL
 ld A,(IX+96)
 cp 0fh
 jp nz,mains_end
 ld (IX+48),A
 jp mains_end
floor48t:
 exx
 ld A,(rod)
 cp 1
 jp nz,mains_end
 cp 2
 jp z,mains_end
 call cross_ck_a
 jp nc,box_action_end
 ld A,2
 ld (rod),A
 ld A,0ch+1
 call itemprint
 jp mains_end

floor49:
 exx
 push HL
 ld HL,obj_hp
 ld A,(HL)
 or A
 jp nz,floor49l
 pop HL
 ld A,1
 ld (dammy+5),A
 ld (IX+48),A
 jp mains_end
floor49l:
 pop HL
 jp mains_end
floor49t:
 exx
 ld A,(dammy+4)
 or A
 jp z,mains_end

 ld A,(posion)
 cp 2
 jp z,mains_end
 ld A,(posion)
 cp 3
 jp nz,box_action_end
 call cross_ck_a
 jp nc,box_action_end
 ld A,2
 ld (posion),A
 ld A,16
 ld (gil_hp),A
 ld A,2h+1
 call itemprint
 jp mains_end

floor50:
 exx
 ld B,0
 ld A,(gil_xy+1)
 and 00111111b
 push AF
 cp B
 jr nz,floor50a
 set 0,(IX+96)
floor50a:
 ld B,42
 pop AF
 cp B
 jr nz,floor50b
 set 1,(IX+96)
floor50b:
 ld B,30
 ld A,(gil_xy)
 push AF
 cp B
 jr nz,floor50c
 set 2,(IX+96)
floor50c:
 ld B,135
 pop AF
 cp B
 jr nz,floor50d
 set 3,(IX+96)
floor50d:
 ld A,(IX+96)
 cp 0fh
 jp nz,mains_end
 ld (IX+48),A
 jp mains_end
floor50t
 exx
 ld A,(posion)
 cp 1
 jp z,mains_end
 call cross_ck_a
 jp nc,box_action_end
 ld A,1
 ld (posion),A
 ld A,64
 ld (gil_hp),A
 ld A,2h+1
 call itemprint
 jp mains_end
 
floor51:
 exx
 ld A,(gil_button)
 and 11000011b
 or A
 jr z,floor51e
 inc (IX+96)
 ld A,(IX+96)
 cp 127
 jp nz,mains_end
 ld (IX+48),A
 jp mains_end
floor51e:
 xor A
 ld (IX+96),A
 jp mains_end
floor51t:
 exx
 ld A,(brns)
 or A
 jp nz,mains_end
 call cross_ck_a
 jp nc,box_action_end
 ld A,1
 ld (brns),A
 ld A,0ah+1
 call itemprint
 jp mains_end

floor52:
 exx
 jr f52t
 ld A,(dammy+9)
 cp 4
 jp c,mains_end
f52t:
 ld A,1
 ld (IX+48),A
 jp mains_end
floor52t:
 exx
 ld A,(armor)
 cp 1
 jp nz,mains_end
 call cross_ck_a
 jp nc,box_action_end
 ld A,(brns)
 or A
 jr nz,floor52tt
floor52ti:
 ld A,3
 ld (armor),A
 jr floor52tl
floor52tt: 
 ld A,2
 ld (armor),A
floor52tl:
 xor A
 ld (brns),A
 ld DE,1c07h
 call grp_del
 ld A,5h+1
 call itemprint
 jp mains_end
floor53:
floor53t:
floor54:
floor54t:
floor55:
floor55t:
floor56:
floor56t:
 exx
 jp mains_end
 
floor57:
 exx
 ld A,(dammy+10)
 or A
 jp z,mains_end
 ld A,(obj_hp)
 or A
 jp nz,mains_end
 ld A,(obj_hp+1)
 or A
 jp nz,mains_end
 ld A,1
 ld (IX+48),A
 jp mains_end
floor57t
 exx
 ld A,(meis)
 or A
 jp nz,mains_end
 call cross_ck_a
 jp nc,box_action_end
 ld A,1
 ld (meis),A
 ld A,0bh+1
 call itemprint
 jp mains_end
 
floor58:
 exx
 push HL
 ld DE,0a34fh
 ld HL,(gil_xy)
 or A
 sbc HL,DE
 ld HL,dammy+11
 jr nz,floor58a
 set 0,(HL)
floor58a:
 bit 0,(HL)
 jp z,floor58e
 
 
 ld DE,874fh
 ld HL,(gil_xy)
 or A
 sbc HL,DE
 ld HL,dammy+11
 jr nz,floor58b
 set 1,(HL)
floor58b:
 bit 1,(HL)
 jp z,floor58e


 ld DE,954fh
 ld HL,(gil_xy)
 or A
 sbc HL,DE
 ld HL,dammy+11
 jr nz,floor58c
 set 2,(HL)
floor58c:
 bit 2,(HL)
 jp z,floor58e
 pop HL
 ld A,1
 ld (IX+48),A
 jp mains_end
floor58e:
 pop HL
 jp mains_end
floor58t
 exx
 ld A,(rod)
 cp 2
 jp nz,mains_end
 ld A,(rod)
 cp 3
 jp z,mains_end
 call cross_ck_a
 jp nc,box_action_end
 ld A,3
 ld (rod),A
 ld A,0ch+1
 call itemprint
 jp mains_end
floor59:
floor59t
floor60:
floor60t
 exx
 jp mains_end





box_action_end:
 ld DE,graph_box
 call Egraph
 jp mains_end


;*************************door actions************************
door_action:
 ld A,(key)
 or A
 jr nz,door_action_1
 jr door_action_end
door_action_1:
 ld DE,graph_door+6
 call Egraph
 call cross_ck_a
 call xy_ck
 jp z,next_floor
 jp mains_end
door_action_end:
 call cross_ck_a
 jr nc,door_action_end2
 ld A,(dammy+5)
 or A
 jr nz,door_action_end2
 ld A,1
 ld (dammy+4),A
door_action_end2:
 ld DE,graph_door
 call Egraph
 jp mains_end

next_floor:
 xor A
 ld (key),A
 call itemprint
 call grp_o
 
 ld DE,0106h
 ld B,11
 ld HL,next_floorms
 call msp
 ld DE,0208h
 ld B,10
 ld HL,next_floorms+11
 call msp
 call tim255
 call kwait
 ld HL,floor
 inc (HL)
 ld A,(HL)
 dec HL
 cp (HL)
 jp c,Stating_before
 ld (HL),A
 jp Stating_before
next_floorms:
 db "FLOOR CLEAR"
 db "NEXT FLOOR"

;*************************gil actions*************************
gil_action:
 push HL


 ld A,(gil_xy)
 ld E,A
 ld A,(gil_xy+1)
 ld D,A
 call grp_del
; call kwait

;*************************key scanf**************************
 call keysc
 ld (gil_button),A
 ex AF,AF'

;************************sword back***************************
 ld A,(gil_st2)
 or A
 jp nz,gil_sword_f2
;***********************sword atack****************************
gil_action_l_b:
 ex AF,AF'
 bit 5,A
 jp nz,gil_sword_f
 call gil_sword_reset

 ld HL,graph_gil_ulf
 ld (gil_action_end-2),HL
;************************urdl move*****************************
gil_action_l:
 ex AF,AF'
 ld A,(boot)
 or A
 jr nz,gil_action_l2
 ld A,(gil_bt)
 xor 0ffh
 ld (gil_bt),A
 jp z,gil_action_end-3
gil_action_l2:
 ex AF,AF'
 bit 0,A
 jr nz,gil_left
 bit 1,A
 jr nz,gil_right
 bit 6,A
 jr nz,gil_down
 bit 7,A
 jr nz,gil_up
;*****************************noting************************
 jp gil_action_end-3
 ;************************move farse*************************
gil_left:
 ld A,(gil_xy+1);y
 and 00111111b
 jp z,gil_left_l
gil_left_s:
 sub 7
 jp c,direction_p
 jr nz,gil_left_s
gil_left_l:
 ld A,11000000b
 ld HL,gil_xy+1
 or (HL)
 ld (HL),A
 dec HL;ld HL,gil_xy
 call wall_ck
 or A;
 jp nz,gil_action_end-3

; ld HL,gil_xy
 dec (HL)
 jp gil_walk

gil_right:
 ld A,(gil_xy+1);y
 and 00111111b
 jp z,gil_right_l
gil_right_s:
 sub 7
 jp c,direction_p
 jr nz,gil_right_s
gil_right_l:
 ld A,00111111b
 ld HL,gil_xy+1
 and (HL)
 ld (HL),A
 set 6,(HL)
 dec HL;ld HL,gil_xy
 call wall_ck
 or A;
 jp nz,gil_action_end-3

; ld HL,gil_xy
 inc (HL)
 jr gil_walk

gil_down:
 ld A,(gil_xy);x
 sub 30
 jp z,gil_down_l
gil_down_s:
 sub 7
 jp c,direction_p
 jr nz,gil_down_s
gil_down_l:
 ld A,00111111b
 ld HL,gil_xy+1
 and (HL)
 ld (HL),A
 set 7,(HL)
 dec HL;ld HL,gil_xy
 call wall_ck
 or A;
 jp nz,gil_action_end-3

; ld HL,gil_xy
 inc HL
 inc (HL)
 jr gil_walk

gil_up:
 ld A,(gil_xy);x
 sub 30
 jp z,gil_up_l
gil_up_s:
 sub 7
 jp c,direction_p
 jr nz,gil_up_s
gil_up_l:
 ld A,00111111b
 ld HL,gil_xy+1
 and (HL)
 ld (HL),A
 dec HL;ld HL,gil_xy
 call wall_ck
 or A;
 jp nz,gil_action_end-3

; ld HL,gil_xy
 inc HL
 dec (HL)
; jr gil_walk


gil_walk:
 ld HL,gil_st1
 ld A,0ffh
 xor (HL)
 ld (HL),A

 ld HL,graph_gil_ulf
gil_action_end:
 ld A,(gil_st1)
 inc A
 ld DE,24
 call xsan
gil_action_end_l:
 ld A,(gil_xy)
 ld E,A
 ld A,(gil_xy+1)
 ld D,A
 call grp_set
 pop HL
 jp mains_end

direction_p:
 ld A,(gil_xy+1)
 and 11000000b
 jp z,gil_up_l
 cp 80h
 jp c,gil_right_l
 jp z,gil_down_l
 jp gil_left

gil_sword_f:;key_action
 ex AF,AF'
 or A
 jp nz,gil_sword_set 
;************************sword atack***************************
 ld A,(gnt)
 cp 1
 jr c,gnt_back_1
 jr z,gnt_back_1
 cp 3
 jr c,gnt_back_2
 xor A
 jr gnt_back_e
gnt_back_2:
 ld A,4
 jr gnt_back_e
gnt_back_1:
 ld A,10;back flame
gnt_back_e:
 ld (gil_st2),A
;***********************matk action****************************
 call matk_action_gil
;*************************************************************
 ld DE,graph_gilsw_ulf;gil_sw
 ld (gil_action_end-2),DE
 ex AF,AF'
 jp gil_action_l
gil_sword_set:
 ld DE,graph_gilsword_ulf;gil_swd
 ld (gil_action_end-2),DE
gil_sword_set_l:
 ex AF,AF'
 jp gil_action_l
gil_sword_reset:
 ex AF,AF'
 ld A,(gil_st2)
 ld B,A
 ex AF,AF'
 bit 7,B
 ret z
 ex AF,AF'
 pop HL
;************************sword back***************************
 ld A,(gnt)
 cp 1
 jr c,gnt_backb_1
 jr z,gnt_backb_1
 cp 3
 jr c,gnt_backb_2
 xor A
 jr gnt_backb_e
gnt_backb_2:
 ld A,4
 jr gnt_backb_e
gnt_backb_1:
 ld A,10;back flame
gnt_backb_e:
 or 10000000b
 ld (gil_st2),A
 
 ex AF,AF'
 jp gil_action_l
gil_sword_f2:;auto_action
 cp 80h
 jp z,gil_action_l_b
 and 10000000b
 jp nz,gil_sword_f_decB;A=1nnnnnnnb
gil_sword_f_decA:;A=0nnnnnnnb
 ld HL,gil_st2
 ld A,(HL)
 dec A
 ld (HL),A
 ld DE,graph_gilsw_ulf;gil_sw
 ld (gil_action_end-2),DE
 jp nz,gil_action_l_r
 set 7,(HL)
 jp gil_action_l_r
gil_sword_f_decB:;A=1nnnnnnnb
 ld HL,gil_st2
 ld A,(HL)
 dec A
 ld (HL),A
 and 01111111b
 ld DE,graph_gilsw_ulf;gil_sw
 ld (gil_action_end-2),DE
 jp nz,gil_action_l_r
 res 7,(HL)
gil_action_l_r:
 ex AF,AF'
 jp gil_action_l

gil_zapping:
gil_killing:
 call grp_o
 ld HL,killingm
 ld DE,0
 ld B,11
 call msp
 call 48381
 jp stating_rec



killingm:
 db "been killed"


mains_end:
; ld A,(IX+48)
; ld (0f0h),A
; ld (0f2h),IX
 ld A,(count+1)
 dec A
 ld (count+1),A
 inc HL
 inc HL
 inc IX
 inc IY
 exx
 call keysc
 bit 2,A
 jp nz,retp
 exx
 jp mains


retP:
 ld SP,0
 ret







;*********************************************************
TIMBTL:
 LD A,50
 JR TIMER
TIM30:
 LD A,37
 JR TIMER
TIM255:
 LD A,255
TIMER:
 LD BC,0
 INC BC;LOOP
 DB 0,0,0,0,0,0
 XOR B
 RET Z
 JR TIMER+3
RAND:;Aﾆｶｴｽ
 PUSH HL
 push DE
 LD HL,0
 LD D,H
 LD E,L
 ADD HL,HL
 ADD HL,HL
 ADD HL,DE
 LD DE,5D47H
 ADD HL,DE
 LD (RAND+3),HL
 LD A,H
 pop DE
 POP HL
 RET
RAND4:
; ld A,R
; rra
; rra
; rra
; and 11000000b
; ret
 CALL RAND
 AND 11000000b
 RET
XSAN:
 OR A
 RET Z
XSANL:
 ADD HL,DE
 DEC A
 JR NZ,XSANL
 RET
NMEMRY:
 DB 0,0,0,0,0
ASCN:;HL=数値(2byte)→DEのｱﾄﾞﾚｽ
 LD DE,NMEMRY
 LD BC,10000
 CALL WARIS
 LD BC,1000
 CALL WARIS
 LD BC,100
 CALL WARIS
 LD BC,10
 CALL WARIS
 LD A,L
 LD (DE),A
 LD B,5
 LD DE,NMEMRY
ASCL:
 LD A,(DE)
 CP 0
 JR Z,ASCL2
 JR ASC2
ASCL2:
 INC DE
 DJNZ ASCL
 LD B,1
 LD DE,NMEMRY+4
ASC2:
 LD A,(DE)
 LD C,30H
 ADD A,C
 LD (DE),A
 INC DE
 DJNZ ASC2
 RET
WARIS:
 XOR A
;WARI1:
 SBC HL,BC
 JR C,WARI2
 INC A
 JR WARIS+1
WARI2:
 ADD HL,BC
 LD (DE),A
 INC DE;
 RET
cls:
 push AF
 push DE
 push HL
 push BC
 ld A,0
 ld HL,grapu_area
 ld DE,grapu_area+1
 ld (HL),A
 ld BC,144*6-1
 ldir
 call grp_o
 pop BC
 pop HL
 pop DE
 pop AF
 ret

bls:
 push AF
 push DE
 push HL
 push BC
 LD HL,grapu_area
 LD (HL),0FFH
 LD DE,grapu_area+1
 LD BC,863
 LDIR
 CALL grp_o
 EXX
 pop BC
 pop HL
 pop DE
 pop AF
 RET
grp_o:
 ld A,6
 ld DE,0
 ld HL,grapu_area;+144*3
grp_o_l:
 push DE
 push AF
 ld B,144
 call grp
 inc HL
 pop AF
 pop DE
 inc D
 dec A
 jr nz,grp_o_l
 ret

grp_open:
 ld C,6
grp_open_l
 push BC
 push DE
 call grp
 pop DE
 inc D
 inc HL
 pop BC
 dec C
 jr nz,grp_open_l
 ret

keysc:
 di
 xor A
 out (11h),A
 ld A,08h
 out (11h),A
 call 8aadh
 in A,(10h)
 and 0e0h
 ld B,A
 xor A
 out (11h),A
 ld A,10h
 out (11h),A
 call 8aadh
 in A,(10h)
 and 0fh
 or B
 ei
 ret



charReput:;HL=obj_xy++
charReput_x:
 ld A,(HL);x
 ld C,A
 sub 30
 jp z,charReput_y
charReput_x_lp:
 sub 7
 jp z,charReput_y
 jr nc,charReput_x_lp
 cp 0fch+1;cy=-4~-6 left
 jr c,charReput_x_1
 neg;(right+)
 jr charReput_x_2
charReput_x_1:
 add A,7
 neg;(left-)
charReput_x_2:
 add A,C
 ld (HL),A

charReput_y:
 inc HL
 ld A,(HL)
 dec HL
 ld C,A
 and 00111111b
 ret z
charReput_y_lp:
 sub 7
 ret z
 jr nc,charReput_y_lp
 cp 0fch+1;cy=-4~-6 up
 jr c,charReput_y_1
 neg;(down+)
 jr charReput_y_2
charReput_y_1:
 add A,7
 neg;(up-)
charReput_y_2:
 add A,C
 inc HL
 ld (HL),A
 dec HL
 ret 


cross_ck_s:;HL=obj_xy+
 ld E,(HL)
 inc HL
 ld D,(HL)
 dec HL
 ld A,(gil_xy+1)
 and 11000000b
 jp z,cross_ck_s_up
 cp 80h
 jp c,cross_ck_s_right
 jp z,cross_ck_s_down
cross_ck_s_left:
 ld A,(gil_xy+1)
 and 3fh
 sub D;x-x1
 cp 3
 jr c,cross_ck_s_left_2
 cpl
 inc A
 cp 3
 ret nc
cross_ck_s_left_2:
 ld A,(gil_xy)
 sub E
 cp 6;when (a-d)>0 is that empty at left.
 ret c
 cpl
 inc A
 cp 3
 jp c,gil_killing
 ret
cross_ck_s_up:
 ld A,(gil_xy)
 sub E;x-x1
 cp 3
 jr c,cross_ck_s_up_2
 cpl
 inc A
 cp 3
 ret nc
cross_ck_s_up_2:
 ld A,(gil_xy+1)
 and 3fh
 sub D
 cp 3;when (a-d)>0 is that empty at up.
 ret c
 cpl
 inc A
 cp 3
 jp c,gil_killing
 ret
cross_ck_s_right:
 ld A,(gil_xy+1)
 and 3fh
 sub D;x-x1
 cp 3
 jr c,cross_ck_s_right_2
 cpl
 inc A
 cp 3
 ret ;c or nc
cross_ck_s_right_2:
 ld A,(gil_xy)
 sub E
 cp 3;when (a-d)<0 is that empty at right.
 jp c,gil_killing
 cpl
 inc A
 cp 6
 ret ;c or nc
cross_ck_s_down:
 ld A,(gil_xy)
 sub E;x-x1
 cp 3
 jr c,cross_ck_s_down_2
 cpl
 inc A
 cp 3
 ret nc
cross_ck_s_down_2:
 ld A,(gil_xy+1)
 and 3fh
 sub D
 cp 3;when (a-d)<0 is that empty at down.
 jp c,gil_killing
 ret c
 cpl
 inc A
 cp 6
 ret


cross_ck_a:;HL=obj_xy+
 ld E,(HL);x
 inc HL
 ld A,(HL)
 dec HL
 and 3fh
 ld D,A;y
; ld HL,(gil_xy)
 ld A,(gil_xy)
 sub E;x-x1
 cp 3
 jr c,cross_ck_al
 cpl
 inc A
 cp 3
 ret nc
cross_ck_al:
 ld A,(gil_xy+1)
 and 3fh
 sub D
 cp 3
 ret c
 cpl
 inc A
 cp 3
 ret ;nc or cy
;cy is crosses.

cha_kill:;HL=obj_xy++,IX=obj_hp
 push HL
 ld E,(HL)
 inc HL
 ld D,(HL)
 call grp_del
 ld HL,dammy
 ld A,(HL)
 inc A
 ld (HL),A
 ld HL,dammy+13
 inc (HL)
 pop HL
 xor A
 ld (IX),A
 ret


wall_ck:
 push HL
 call wall_cks
 pop HL
 ret

wall_cks:;HL,obj_xy+;non zero=don't pass, zero=pass and A=0, cy=not block
 push HL
;HL=(y,x)
 ld E,(HL);x
 inc HL
 ld D,(HL);y
 dec HL
 ex DE,HL
 ld A,00111111b
 and H
 ld BC,0
 jr z,wall_ck_lc
wall_ck_lb:
 inc B
 sub 7
 jp c,wall_ck_end
 jr nz,wall_ck_lb
wall_ck_lc:
 ld A,L
 sub 30
 jr z,wall_ck_le
wall_ck_ld:
 inc C
 sub 7
 jp c,wall_ck_end
 jr nz,wall_ck_ld
wall_ck_le:
 ld A,H
 and 11000000b
 jp z,wall_ck_lu
 cp 80h
 jp c,wall_ck_lr
 jp z,wall_ck_ldd

wall_ck_ll:
 ld HL,map_memry_left-17
;x+C
 ld E,C
 ld D,0
 add HL,DE
;y+17*B
 ld DE,17
 inc B
wall_ck_ll_2:
 add HL,DE
 djnz wall_ck_ll_2
; or A
; sbc HL,DE
 ld (block_pointaP+1),HL
 ld A,(HL)
 and t;t(80h) or f(0)
 pop HL

; ld A,"l"
; ld DE,0
; call 0be62h
; pop HL

 ret


wall_ck_ldd:
 ld HL,map_memry_top-16
;x+C
 ld E,C
 ld D,0
 add HL,DE
;y+16*B
 ld DE,16
 inc B
wall_ck_ld2:
 add HL,DE
 djnz wall_ck_ld2
; sub HL,DE
 ld (block_pointaP+1),HL
 ld A,(HL)
 and t;t(80h) or f(0)
 pop HL

; ld A,"d"
; ld DE,0
; call 0be62h
; pop HL

 ret


wall_ck_lr:
 ld HL,map_memry_left-17
;x+C
 ld E,C
 ld D,0
 add HL,DE
 inc HL
;y+17*B
 ld DE,17
 inc B
wall_ck_lr_2:
 add HL,DE
 djnz wall_ck_lr_2
; or A
; sbc HL,DE
 ld (block_pointaP+1),HL
 ld A,(HL)
 and t;t(80h) or f(0)
 pop HL

; ld A,"r"
; ld DE,0
; call 0be62h
; pop HL

 ret




wall_ck_lu:
 ld HL,map_memry_top-16-16
;x+C
 ld E,C
 ld D,0
 add HL,DE
;y+16*B
 ld DE,16
 inc B
wall_ck_lu2:
 add HL,DE
 djnz wall_ck_lu2
; or A
; sbc HL,DE
 ld (block_pointaP+1),HL
 ld A,(HL)
 and t;t(80h) or f(0)
 pop HL

; ld A,"u"
; ld DE,0
; call 0be62h
; pop HL

 ret
wall_ck_end:
 pop HL
 xor A
 ret


;******************************wall mod block**************************
;********************wall mod****HL=obj_xy************************
wall_mod:
 ld BC,0
 ld A,(HL) 
 ld E,A
 inc HL
 ld A,(HL)
 and 00111111b
 ld D,A
 dec HL
 
 ld A,E
 sub 30
 jr z,wall_mod_l2
wall_mod_l1:
 sub 7
 jr z,wall_mod_l2
 jr nc,wall_mod_l1
 ld C,A

wall_mod_l2
 ld A,D
 or A
 jr z,wall_mod_l4
wall_mod_l3:
 sub 7
 jr z,wall_mod_l4
 jr nc,wall_mod_l3
 ld B,A
wall_mod_l4
; ld A,E
; ld (0f0h),A
; ld A,D
; ld (0f1h),A
; ld A,C
; ld (0f4h),A
; ld A,B
; ld (0f5h),A
 ret
 
 
 
;*************************************matk action******************************

matk_action_gil:

 ld HL,gil_xy
 call wall_ck
 ret z

 ld HL,gil_matk_count
 ld E,(HL)
 inc E
 dec E
 ret z
 dec E
 ld (HL),E
 push AF
 call z,gil_matk_break 
 pop AF

 ld HL,gil_xy
matk_action:;HL=obj address+ let push pop
 ex AF,AF'
 ld (matk_action_gil_ret+1),A
 ld (matk_action_HLP+1),HL
 
 
 call wall_ck
 jp c,matk_action_gil_ret
 jp z,matk_action_gil_ret
block_pointaP:
 ld HL,overwrite;block address
 ld A,(dammy+9)
 inc A
 ld (dammy+9),A
 ld C,(HL)
 inc C
 jp z,gil_matk_break 
 ld (HL),0
 
; call bls

matk_action_HLP:
 ld HL,overwrite
 ld (matk_action_gil_ret+3),HL

 ld E,(HL)
 inc HL
 ld D,(HL)
 ld A,D
 and 11000000b
 jr z,matk_action_u
 cp 80h
 jr c,matk_action_r
 jr z,matk_action_d
matk_action_l:
 dec E
 call grp_del
 jr matk_action_gil_ret
matk_action_d:
 inc D
 call grp_del
 jr matk_action_gil_ret
matk_action_r:
 inc E
 call grp_del
 jr matk_action_gil_ret
matk_action_u:
 dec D
 call grp_del
 jr matk_action_gil_ret

gil_matk_break:
 ld A,(IX-48)
 cp 8fh
 jr nz,matk_action_gil_ret
 call matklost
matk_action_gil_ret:
 ld A,overwrite
 ld HL,overwrite
 ex AF,AF'
 ret
 
 

matklost:
 xor A
 ld (gil_matk_count),A
 ld (matk),A
 xor A
 ld (matk),A
 ld DE,0700h
 call grp_del
 ld A,1
 ld (dammy+2),A
 ret


Map_make:
 call cls
 ld HL,Map_data
 ld A,(floor)
 dec A
 ld DE,96+105
 call xsan
 ld DE,map_memry_top
 ld BC,96
 ldir
 ld DE,map_memry_left
 ld A,7
 inc DE
map_make_l:
 push AF
 ld BC,15
 ldir
 inc DE
 inc DE
 pop AF
 dec A
 jr nz,map_make_l
 ld DE,061eh
 ld IX,map_memry_top
 ld IY,map_memry_left

map_make_l_l:
 ld A,(IX)
 and t
 jr z,map_make_Xe
 push DE
 ld HL,graph_wall+0
 call grp_set
 pop DE
map_make_Xe:
 inc IX

 ld A,(IY)
 and t
 jr z,map_make_Ye
 push DE
 ld HL,graph_wall+6
 dec D
 dec D
 dec D
 dec D
 dec D
 dec D
 dec E
 call grp_set
 pop DE
map_make_Ye:
 inc IY

 ld A,7
 add A,E
 ld E,A
 cp 142
 jp nz,map_make_l_l
 
 ld A,7
 add A,D
 ld D,A
 cp 55
 jr z,map_make_end
 ld E,1eh
 inc IY
 jp map_make_l_l
map_make_end:
;**********************left right wall***********************
 ld c,2
 ld A,27
 ld (Stating_before_mkwall1+1),A
Stating_before_mkwall2
 ld D,0
 ld B,6
Stating_before_mkwall1:
 ld E,overwrite
 push BC
 push DE
 ld HL,wall_grp
 ld B,3
 call grp_set+2
 pop DE
 pop BC
 ld A,8
 add A,D
 ld D,A
 djnz Stating_before_mkwall1
 ld A,141
 ld (Stating_before_mkwall1+1),A
 dec C
 jr nz,Stating_before_mkwall2

;**************************wall dot set***********************

 ld c,15
 ld A,36
 ld (Stating_before_mkwall11+1),A
Stating_before_mkwall21
 ld D,6
 ld B,6
Stating_before_mkwall11:
 ld E,overwrite
 push BC
 push DE
 ld HL,pole_grp
 ld B,1
 call grp_set+2
 pop DE
 pop BC
 ld A,7
 add A,D
 ld D,A
 djnz Stating_before_mkwall11
 ld A,(Stating_before_mkwall11+1)
 add A,7
 ld (Stating_before_mkwall11+1),A
 dec C
 jr nz,Stating_before_mkwall21
 ret




 db 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh;16
map_memry_top:;1(ture or false)0000000(loop count,7fh=Outer wall)b
 ds 16
 ds 16
 ds 16
 ds 16
 ds 16
 ds 16
 db 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh;16
 db 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh;16



map_memry_left:;1(ture or false)0000000(loop count,7fh=Outer wall)b
 db 0ffh
 ds 15
 db 0ffh
 db 0ffh
 ds 15
 db 0ffh
 db 0ffh
 ds 15
 db 0ffh
 db 0ffh
 ds 15
 db 0ffh
 db 0ffh
 ds 15
 db 0ffh
 db 0ffh
 ds 15
 db 0ffh
 db 0ffh
 ds 15
 db 0ffh
 db 0ffh
 
 ds 15
 db 0ffh
graph_wall:
 db 1,1,1,1,1,1
 db 3fh,0,0,0,0,0



grp_set:;HL_data,DE_(y,x),B_databit
 ld B,6
;

 ld A,D
 and 11000000b
 jr z,grp_set_0
 cp 80h
 jr c,grp_set_1
 jr z,grp_set_2
;left
 ld A,18
 add A,L
 ld L,A
 jr nc,grp_set_0
 inc H
 jr grp_set_0
;dowm
grp_set_2:
 ld A,12
 add A,L
 ld L,A
 jr nc,grp_set_0
 inc H
 jr grp_set_0
;right
grp_set_1:
 ld A,6
 add A,L
 ld L,A
 jr nc,grp_set_0
 inc H

;up,non direction
grp_set_0:
 ld A,E
 ld (grp_set_or1+1),A
 ld A,D
 and 3fh
 ld D,0
grp_set_set1:
 inc D
 sub 8
 jr nc,grp_set_set1
 dec D
 add A,8
grp_set_set2:
 ld (grp_set_shiftd_bit+1),A
 ld C,A
 ld A,8
 sub C
 ld (grp_set_shiftu_bit+1),A

grp_set_shiftd:
 ld A,D;line number
 push HL;HL
 ld HL,grapu_area
 ld DE,144
 call xsan;y+
grp_set_or1:
 ld E,overwrite
 ld D,0
 add HL,DE;x+
 ex DE,HL
 pop HL;data
 push HL;HL
 push BC;BC
grp_set_shiftd_bit:
 ld C,overwrite;shift bit count
 ld A,(HL)
 ex AF,AF'
 ld A,C
 or A
 jr z,grp_set_shiftd_bit_2
 ex AF,AF'
grp_set_shiftd_bit_l:
 sla A
 dec C
 jr nz,grp_set_shiftd_bit_l
 ex AF,AF'
grp_set_shiftd_bit_2:
 ex AF,AF'
 ld C,A
 ld A,(DE)
grp_set_change1:
 or C
 ld (DE),A
grp_set_shiftd_l:
 inc HL
 inc DE
 djnz grp_set_shiftd_bit

; dec DE

 ex DE,HL
 ld DE,144
 add HL,DE


 pop BC;HL
 ld A,L
 sub B
 jr nc,grp_set_shiftu_bit_b
 dec H
grp_set_shiftu_bit_b:
 ld L,A
 ex DE,HL

 pop HL;data2
grp_set_shiftu_bit:
 ld C,overwrite;shift bit count
 ld A,(HL)
grp_set_shiftu_bit_l
 srl A
 dec C
 jr nz,grp_set_shiftu_bit_l
 ld C,A
 ld A,(DE)
grp_set_change2:
 or C
 ld (DE),A
grp_set_shiftu_l:
 inc HL
 inc DE
 djnz grp_set_shiftu_bit

; call grp_o;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 ret









grp_del:;HL_data,DE_(y,x),B_databit
 ld HL,del_graph
 ld B,6
 ld A,E
 ld (grp_set_or1d+1),A
 ld A,D
 and 3fh
 ld D,0
grp_set_set1d:
 inc D
 sub 8
 jr nc,grp_set_set1d
 dec D
 add A,8
grp_set_set2d:
 ld (grp_set_shiftd_bitd+1),A
 ld C,A
 ld A,8
 sub C
 ld (grp_set_shiftu_bitd+1),A

grp_set_shiftdd:
 ld A,D;line number
 push HL;HL
 ld HL,grapu_area
 ld DE,144
 call xsan;y+
grp_set_or1d:
 ld E,overwrite
 ld D,0
 add HL,DE;x+
 ex DE,HL
 pop HL;data
 push HL;HL
 push BC;BC
grp_set_shiftd_bitd:
 ld C,overwrite;shift bit count
 ld A,(HL)
 ex AF,AF'
 ld A,C
 or A
 jr z,grp_set_shiftd_bit_2d
 ex AF,AF'
grp_set_shiftd_bit_ld:
 scf
 rla
 dec C
 jr nz,grp_set_shiftd_bit_ld
 ex AF,AF'
grp_set_shiftd_bit_2d:
 ex AF,AF'
 ld C,A
 ld A,(DE)
grp_set_change1d:
 and C
 ld (DE),A
grp_set_shiftd_ld:
 inc HL
 inc DE
 djnz grp_set_shiftd_bitd

; dec DE

 ex DE,HL
 ld DE,144
 add HL,DE


 pop BC;HL
 ld A,L
 sub B
 jr nc,grp_set_shiftu_bit_bd
 dec H
grp_set_shiftu_bit_bd:
 ld L,A
 ex DE,HL

 pop HL;data2
grp_set_shiftu_bitd:
 ld C,overwrite;shift bit count
 ld A,(HL)
grp_set_shiftu_bit_ld
 scf
 rra
 dec C
 jr nz,grp_set_shiftu_bit_ld
 ld C,A
 ld A,(DE)
grp_set_change2d:
 and C
 ld (DE),A
grp_set_shiftu_ld:
 inc HL
 inc DE
 djnz grp_set_shiftu_bitd
 ret

del_graph:
 db 0c0h,0c0h,0c0h,0c0h,0c0h,0c0h


; ds 144
; ds 144

 ds 144
grapu_area:
 ds 144*6
 ds 144
 
; ds 144
; ds 144
;********************************Graphics**********************************
graph_title:
 db 00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,80h,60h,80h,00,00,0C0h,30h,0Ch,08h,30h,0C0h,0C0h,30h,08h,10h,0E0h,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00
 db 00,00,00,00,00,00,00,00,00,80h,0C0h,00,00,80h,60h,10h,18h,06h,01h,00h,01h,0Eh,03h,00,00,00,00,00,00,01,00,00,00,03,0Ch,30h,40h,080h,00,80h,0E0h,00,00,00,00,00,00,00,00,00
 db 00,00,00,00,00,00,0C0h,30h,0Eh,01h,4Fh,66h,0F1h,0E0h,0F0h,58h,58h,40h,20h,80h,0E0h,0F8h,80h,0F0h,0C0h,0E0h,0F0h,0D8h,68h,0A9h,0C3h,42h,82h,86h,84h,0Ch,18h,79h,0F6h,0E1h,0C1h,86h,38h,0C0h,00,00,00,00,00,00
 db 00,80h,40h,20h,18h,06h,01h,00,00,00,00,0Fh,3Fh,7Fh,0FEh,0F8h,0F8h,0F0h,0FEh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,7Eh,7Eh,7Dh,7Dh,78h,7Dh,3Fh,1Fh,0Fh,00,00,03h,0Ch,70h,80h,00,00
 db 00,0FFh,00,00,00,00,00,00,00,0F8h,08,08,0F0h,00,0FCh,02Eh,06Fh,0D7h,07,7Fh,80h,00,0F8h,00,0F0h,50h,4Ch,4Eh,0FFh,07,0F7h,0Fh,4Eh,4Ch,0D4h,00,0F0h,50h,48h,48h,0F8h,00,00,00,00,00,00,0Fh,30h,0C0h
 db 78h,47h,40h,40h,40h,40h,44h,44h,44h,45h,45h,45h,44h,44h,45h,44h,44h,45h,44h,44h,45h,45h,45h,44h,45h,44h,44h,44h,45h,44h,44h,45h,45h,45h,45h,44h,45h,44h,44h,44h,45h,44h,44h,44h,40h,40h,40h,40h,40h,7Fh

;***********************gil graph***************************

graph_gil_ulf:
 db 00,0Ch,3Fh,1Fh,0Ch,00
graph_gil_rlf:
 db 00,00,3Fh,3Fh,0Ch,00
graph_gil_dlf:
 db 00,0Ch,1Fh,37h,0Ch,00
graph_gil_llf:
 db 00,0Ch,3Fh,3Fh,00,00

graph_gil_urf:
 db 00,0Ch,1Fh,3Fh,0Ch,00
graph_gil_rrf:
 db 00,20h,1Fh,1Fh,2Ch,00
graph_gil_drf:
 db 00,0Ch,3Fh,17h,0Ch,00
graph_gil_lrf:
 db 00,2Ch,1Fh,1Fh,20h,00

graph_gilsw_ulf:
 db 00,0Ch,3Fh,1Fh,0Ch,08
 db 08h,0Ch,3Fh,3Fh,0Ch,00
 db 08,0Ch,1Fh,37h,0Ch,00
 db 00,0Ch,3Fh,3Fh,0Ch,08
;graph_gilsw_urf:
 db 00,0Ch,1Fh,3Fh,0Ch,08
 db 08,2Ch,1Fh,1Fh,2Ch,00
 db 08,0Ch,3Fh,17h,0Ch,00
 db 00,2Ch,1Fh,1Fh,2Ch,08

graph_gilsword_ulf:
 db 1Eh,0Ch,3Fh,1Fh,04h,07h
 db 00,0Eh,3Fh,3Fh,08,08
 db 38h,04h,1Fh,3Fh,0Ch,1Eh
 db 08,08,3Fh,3Fh,0Eh,00
;graph_gilsword_ulf:
 db 1Eh,0Ch,1Fh,3Fh,04,07
 db 00,2Eh,1Fh,1Fh,28h,08
 db 38h,04h,3Fh,1Fh,0Ch,1Eh
 db 08,28h,1Fh,1Fh,2Eh,00

;********************enemy graph*************************

graph_sraimd:
 db 00,18h,1Ch,1Ch,18h,00
graph_sraimu:
 db 00,18h,1Ch,1Ch,18h,00
graph_sraimd1:
 db 00,0Ch,1Ah,1Eh,0Ch,00
graph_sraimu2:
 db 00,0Ch,1Ah,1Eh,0Ch,00

magic:
 db 03,2Eh,3Fh,3Fh,2Eh,03
magicr:
 db 00,20h,3Fh,3Fh,2Eh,18h
magic3:
 db 18h,2Eh,3Fh,3Fh,2Eh,18h
magic4:
 db 18h,2Eh,3Fh,3Fh,20h,00
 
graph_goast:
 db 03,0Eh,1Fh,1Fh,0Eh,03
 db 10h,18h,1Eh,1Fh,0Fh,1Ah
 db 18h,0Eh,1Fh,1Fh,0Eh,18h
 db 1Ah,0Fh,1Fh,1Eh,18h,10h
 
graph_spell:
 db 00,00,18h,18h,00,00
 db 00,00,18h,18h,00,00
 db 00,00,18h,18h,00,00
 db 00,00,18h,18h,00,00
 

graph_n_knightu:;r foot
 db 00,0Ch,1Fh,3Fh,04,07
graph_n_knightr:
 db 00,20h,1Fh,1Fh,28h,08
graph_n_knightd:
 db 38h,04h,3Fh,1Fh,0Ch,00
graph_n_knightl:
 db 08,28h,1Fh,1Fh,20h,00
 
;graph_n_knightu:;l foot
 db 00,0Ch,3Fh,1Fh,04h,07h
;graph_n_knightr:
 db 00,00,3Fh,3Fh,08h,08
;graph_n_knightd:
 db 38h,04h,1Fh,3Fh,0Ch,00
;graph_n_knightl:
 db 08,08,3Fh,3Fh,00,00

graph_quox_ulf:
 db 06,3Eh,3Fh,1Fh,1Eh,06
 db 0Eh,3Dh,3Ch,3Ch,3Ah,0Eh
 db 06,1Eh,1Bh,37h,3Eh,06
 db 0Eh,3Ah,3Ch,3Ch,3Dh,0Eh
 
 db 06,1Eh,1Fh,3Fh,3Eh,06
 db 2Eh,3Dh,1Ch,1Ch,3Ah,2Eh
 db 06,3Eh,3Bh,17h,1Eh,06h
 db 2Eh,3Ah,1Ch,1Ch,3Dh,2Eh

graph_druaga_ulf:
 db 08,2Dh,1Eh,1Eh,0Dh,08
 db 24h,1Ch,1Eh,1Bh,1Ch,2Ch
 db 08,0Dh,1Ah,16h,2Dh,08
 db 2Ch,1Ch,1Bh,1Eh,1Ch,24h
 
 db 08,0Dh,1Eh,1Eh,2Dh,08
 db 04,3Ch,1Eh,1Bh,3Ch,0Ch
 db 08,2Dh,1Ah,16h,0Dh,08h
 db 0Ch,3Ch,1Bh,1Eh,3Ch,04

graph_ishitar
 db 8,36h,2dh,2dh,36h,8
graph_kai
 db 0,0eh,3bh,3bh,0eh,0
 db 0,0eh,3bh,3bh,0eh,0
 db 0,0eh,3bh,3bh,0eh,0
graph_3rod:
 db 00,20h,3Dh,3Dh,20h,00
 db 00,20h,3Dh,3Dh,20h,00
 db 00,20h,3Dh,3Dh,20h,00
 db 00,20h,3Dh,3Dh,20h,00


graph_brack:
 db 3fh,3fh,3fh,3fh,3fh,3fh
 db 3fh,3fh,3fh,3fh,3fh,3fh
 db 3fh,3fh,3fh,3fh,3fh,3fh
 db 3fh,3fh,3fh,3fh,3fh,3fh

;******************item graph*******************************

graph_key:
 db 20h,28h,3Ah,0Dh,02,00
graph_door:
 db 3Eh,29h,29h,3Dh,29h,3Eh
 db 3Eh,3Fh,3Fh,3Fh,3Fh,3Eh
graph_box:
 db 1Ch,16h,1Ah,16h,1Eh,0Eh
graph_matk:
 db 3Dh,0Eh,07h,0Bh,11h,21h
graph_boot:
 db 20h,30h,3Eh,3Eh,14h,0Ah
graph_po:
 db 30h,28h,27h,27h,28h,30h
graph_sword:
 db 03,07h,2Eh,3Ch,18h,2Ch
graph_gnt:
 db 05,06,07,0Eh,1Ah,3Ch
graph_armor:
 db 01,0Fh,3Ah,2Eh,3Ah,0Fh
graph_kndl:
 db 00,20h,20h,3Ah,20h,20h
graph_shield:
 db 1Fh,33h,27h,2Dh,39h,1Fh
graph_nec:
 db 0Ch,32h,31h,11h,0Bh,04h
graph_hlmt:
 db 1Dh,26h,32h,32h,26h,1Dh
graph_brns:
 db 30h,28h,1Ch,32h,2Ah,3Ch
graph_meis:
 db 0Dh,0Ah,0Dh,1Fh,38h,30h
graph_rod
 db 03h,03h,04h,08h,10h,20h




dammy:
;1:sraim count
;2:spell count
 db 0,0,0,0,0,0
 db 0,0,0,0,0,0
 db 0,0,0,0,0,0
 db 0,0,0,0,0,0
;************************************Data**************************************
obj_1:
;1
 db 1,1,1,1,1,1,1,1,83h,84h,85h,8fh,0
 db 1,1,1,1,1,2,2,2,83h,84h,85h,8fh,0
 db 21h,21h,1,1,1,1,83h,84h,85h,8fh,0
 db 2,2,2,2,2,2,11h,83h,84h,85h,8fh,0
 db 1,1,1,1,11h,11h,11h,11h,11h,83h,84h,85h,8fh,0
 db 11h,11h,11h,22h,22h,83h,84h,85h,8fh,0
 db 3,3,3,21h,21h,21h,83h,84h,85h,8fh,0
 db 2,2,2,2,2,11h,11h,11h,11h,83h,84h,85h,8fh,0
 db 13h,11h,11h,11h,45h,83h,84h,85h,8fh,0
 db 3,3,3,3,12h,12h,83h,84h,85h,8fh,0
;11
 db 1,1,1,11h,11h,11h,11h,11h,83h,84h,85h,8fh,0
 db 2,2,13h,13h,45h,83h,84h,85h,8fh,0
 db 11h,11h,4,4,4,4,4,83h,84h,85h,8fh,0
 db 3,3,3,3,13h,46h,83h,84h,85h,8fh,0
 db 21h,22h,22h,4,4,41h,83h,84h,85h,8fh,0
 db 11h,11h,11h,11h,11h,23h,83h,84h,85h,8fh,0
 db 4,4,13h,13h,45h,45h,83h,84h,85h,8fh,0
 db 2,2,2,11h,11h,11h,46h,83h,84h,85h,8fh,0
 db 3,3,13h,13h,13h,41h,83h,84h,85h,8fh,0
 db 13h,13h,13h,46h,22h,22h,22h,22h,83h,84h,85h,8fh,0
;21
 db 46h,23h,23h,11h,11h,11h,83h,84h,85h,8fh,0
 db 1,1,1,1,1,11h,11h,41h,83h,84h,85h,8fh,0
 db 13h,13h,13h,4,4,4,4,83h,84h,85h,8fh,0
 db 11h,11h,11h,11h,45h,45h,83h,84h,85h,8fh,0
 db 3,3,3,3,13h,22h,83h,84h,85h,8fh,0
 db 13h,13h,13h,13h,24h,41h,83h,84h,85h,8fh,0
 db 21h,21h,21h,23h,23h,83h,84h,85h,8fh,0
 db 5,5,5,46h,22h,83h,84h,85h,8fh,0
 db 2,2,2,2,2,2,46h,46h,83h,84h,85h,8fh,0
 db 11h,11h,22h,22h,24h,24h,41h,83h,84h,85h,8fh,0
;31
 db 4,4,4,13h,13h,13h,13h,83h,84h,85h,8fh,0
 db 5,5,5,5,12h,12h,41h,83h,84h,85h,8fh,0
 db 42h,3,3,11h,45h,46h,83h,84h,85h,8fh,0
 db 13h,23h,23h,83h,84h,85h,8fh,0
 db 22h,5,5,13h,13h,23h,23h,83h,84h,85h,8fh,0
 db 24h,11h,11h,11h,11h,42h,83h,84h,85h,8fh,0
 db 46h,46h,24h,24h,24h,24h,24h,83h,84h,85h,8fh,0
 db 13h,13h,13h,42h,6,6,6,6,6,6,83h,84h,85h,8fh,0
 db 4,4,4,4,11h,11h,26h,26h,6,6,83h,84h,85h,8fh,0
 db 11h,11h,24h,24h,24h,24h,83h,84h,85h,8fh,0
;41
 db 13h,13h,13h,13h,41h,5,5,5,83h,84h,85h,8fh,0
 db 46h,46h,42h,24h,24h,24h,24h,24h,24h,83h,84h,85h,8fh,0
 db 1,2,3,4,5,6,83h,84h,85h,8fh,0
 db 11h,11h,13h,11h,25h,25h,83h,84h,85h,8fh,0
 db 21h,22h,23h,24h,83h,84h,85h,86h,8fh,0
 db 6,6,46h,46h,23h,23h,43h,83h,84h,85h,8fh,0
 db 24h,21h,21h,21h,83h,84h,85h,8fh,0
 db 5,5,5,5,5,46h,46h,41h,83h,84h,85h,8fh,0
 db 13h,13h,13h,24h,24h,24h,24h,24h,24h,83h,84h,85h,8fh,0
 db 4,4,4,11h,11h,24h,24h,43h,83h,84h,85h,8fh,0
;51
 db 3,3,11h,11h,21h,22h,23h,83h,84h,85h,8fh,0
 db 5,5,13h,13h,13h,45h,42h,43h,83h,84h,85h,8fh,0
 db 26h,26h,24h,24h,23h,83h,84h,85h,8fh,0
 db 6h,21h,21h,21h,,83h,84h,85h,8fh,0
 db 13h,13h,13h,13h,13h,13h,26h,26h,26h,83h,84h,85h,8fh,0
 db 13h,26h,26h,26h,26h,26h,26h,83h,84h,85h,8fh,0
 db 24h,87h,83h,84h,85h,8fh,0
 db 26h,41h,24h,24h,24h,83h,84h,85h,8fh,0
 db 27h,14h,14h,14h,14h,44h,81h,84h,85h,8fh,0
 db 8ah,8bh,8ch,8dh,8eh,8fh,0
 

Map_data:;96+105=201byte
;1 
 db f,f,t,t,t,f,f,f,f,f,f,t,f,t,f,f
 db f,f,f,t,f,t,f,t,f,t,t,f,t,t,f,t
 db t,f,t,t,f,f,t,f,f,f,f,f,t,f,f,t
 db f,f,t,t,t,t,f,t,f,t,f,f,f,t,f,f
 db f,f,t,t,t,t,f,t,t,f,f,t,f,t,f,t
 db t,f,t,f,f,t,f,f,t,t,f,t,t,t,f,t

 db t,f,f,f,f,f,t,f,t,t,f,f,f,f,t
 db f,t,f,f,t,t,f,t,f,f,f,t,f,t,f
 db t,t,f,t,t,f,f,t,t,t,t,f,t,t,f
 db t,t,f,f,f,t,t,t,f,f,t,t,f,t,f
 db t,f,f,f,t,f,t,f,t,t,t,t,t,f,t
 db f,f,t,f,f,f,f,f,f,t,f,f,t,f,f
 db f,t,f,t,f,t,t,f,f,f,f,f,t,f,f
;2
 db f,t,t,t,f,t,t,t,f,t,t,t,t,t,f,f
 db f,f,t,f,f,f,f,f,t,f,f,t,t,t,t,t
 db f,f,t,f,t,t,f,f,t,f,t,t,f,f,f,t
 db f,f,f,t,f,f,t,t,f,t,t,t,t,f,t,f
 db t,t,f,t,t,t,f,t,t,t,f,f,f,f,f,f
 db f,t,t,t,t,f,t,f,t,t,t,f,t,t,f,f
 
 db f,f,f,t,f,f,f,t,f,f,f,f,f,f,f
 db t,f,f,f,t,t,t,f,t,f,f,f,f,t,t
 db f,t,f,t,f,f,t,t,f,t,t,f,t,t,f
 db t,t,t,t,f,f,f,f,f,f,f,f,f,f,f
 db t,f,f,t,t,f,t,f,t,f,f,t,f,f,t
 db f,f,t,f,f,f,t,t,f,f,t,t,t,t,t
 db f,f,f,f,t,f,f,f,f,f,f,f,t,f,t
;3
 db t,t,f,t,f,t,t,f,f,t,t,t,t,f,f,t
 db f,f,f,t,f,f,t,f,t,f,f,t,t,t,f,t
 db f,t,f,f,f,t,f,t,f,f,t,f,t,t,f,t
 db t,f,f,t,f,t,f,f,t,t,f,f,t,f,f,f
 db t,t,f,t,t,t,f,t,f,f,f,f,f,f,f,f
 db f,f,f,t,f,f,t,t,t,f,t,f,t,t,f,f
 
 db f,f,f,f,t,f,f,f,f,f,f,t,f,f,f
 db t,f,t,f,f,f,f,t,t,t,t,f,f,t,f
 db t,t,f,t,t,t,t,f,t,t,f,f,t,f,f
 db f,t,t,t,f,f,t,f,t,f,t,f,t,t,t
 db f,f,t,f,f,t,t,t,f,f,t,t,f,f,t
 db t,f,t,f,f,t,f,f,t,t,f,f,t,t,f
 db f,t,f,f,t,t,f,f,f,f,t,f,f,t,t
;4
 db n,n,m,n,n,m,n,m,m,n,m,n,m,n,m,n
 db n,n,m,m,n,n,n,n,m,m,m,m,m,n,n,n
 db n,n,m,n,m,m,m,m,m,m,n,n,n,m,n,n
 db n,m,n,m,n,m,n,m,m,m,n,n,n,m,m,n
 db n,m,m,n,n,m,n,n,n,m,m,n,m,m,n,n
 db n,m,m,m,n,n,m,n,m,m,n,m,m,m,n,m
 
 db n,n,m,n,m,n,n,m,n,n,m,n,n,n,n
 db m,n,m,m,n,n,n,n,n,n,n,n,m,m,n
 db m,n,m,n,m,m,m,n,n,m,m,m,n,m,m
 db m,m,m,n,n,m,m,n,n,n,m,m,m,n,m
 db n,n,n,n,m,n,n,m,n,n,n,n,n,m,n
 db n,m,n,m,m,n,m,m,m,n,m,n,n,m,m
 db n,n,n,m,n,m,n,n,m,n,n,n,n,n,n
;5
 db n,n,m,n,m,m,n,n,m,m,n,n,m,m,n,n
 db n,m,n,n,m,m,n,n,n,m,m,n,n,n,m,n
 db n,n,n,m,n,m,n,m,n,n,m,m,n,m,m,m
 db n,n,n,n,m,m,n,m,n,m,n,m,n,m,n,m
 db m,n,n,m,m,n,n,m,n,m,n,m,n,n,m,n
 db m,n,m,n,m,n,n,n,m,n,n,n,n,m,m,m
 
 db n,n,n,n,n,m,m,m,n,n,m,m,n,n,n
 db m,m,m,n,n,n,n,n,n,n,n,m,n,m,m
 db m,m,m,m,n,m,m,m,m,n,m,m,m,n,n
 db m,m,m,n,m,n,n,m,n,m,n,n,m,n,n
 db n,n,n,m,n,n,n,m,n,n,m,n,m,n,n
 db n,m,m,m,n,m,m,m,m,m,m,m,n,m,n
 db n,n,n,m,n,m,m,n,n,n,m,n,n,n,n
;6
 db m,n,n,n,m,n,n,n,m,m,m,n,m,n,n,n
 db n,n,m,n,n,m,n,m,m,m,m,m,n,m,n,n
 db n,m,n,n,n,m,m,m,m,n,n,n,m,n,m,n
 db n,m,n,m,m,n,n,n,m,n,m,m,n,n,m,n
 db n,m,m,m,m,n,m,n,m,m,m,n,m,m,m,n,
 db m,m,n,n,m,n,m,n,n,n,n,m,m,m,n,n
 
 db n,m,m,n,m,n,m,n,n,n,n,n,n,m,n
 db n,m,n,m,n,m,n,m,n,n,n,m,m,n,m
 db m,n,m,m,m,n,m,n,n,m,n,n,m,m,m
 db n,m,m,n,n,n,m,m,n,m,m,n,m,n,n
 db m,n,n,m,n,m,m,n,n,n,m,n,n,m,n
 db n,n,n,n,n,n,n,m,n,m,n,n,n,m,n
 db n,n,m,n,m,m,n,m,m,n,n,n,n,m,m
;7
 db n,m,n,n,n,m,m,n,m,n,m,n,m,n,m,n
 db n,m,n,m,m,m,m,n,m,m,m,n,n,n,n,m
 db n,m,n,n,m,m,m,m,m,n,m,m,n,n,n,n
 db m,n,m,m,n,m,n,m,n,m,m,m,m,m,m,n
 db n,m,m,n,n,n,n,m,m,n,m,n,m,n,n,n
 db m,n,n,m,n,m,m,m,n,m,m,m,n,m,m,n
 
 db n,m,m,m,n,n,n,n,m,n,n,n,n,n,n
 db n,n,m,n,n,m,n,n,n,n,m,m,m,m,m
 db n,m,n,n,n,n,n,m,n,n,n,m,n,n,n
 db n,m,m,n,m,n,n,n,n,n,m,n,m,m,m
 db m,n,n,m,n,m,n,m,n,n,m,m,n,n,n
 db n,m,m,m,m,m,m,n,m,n,n,m,n,m,m
 db n,n,n,n,n,n,m,n,n,n,n,n,n,n,m
;8
 db n,n,m,n,m,n,m,n,n,n,m,n,m,m,m,n
 db n,n,m,m,n,m,m,n,m,m,m,n,n,m,n,n
 db n,m,n,m,n,m,n,m,n,n,n,m,n,m,n,n
 db n,n,m,m,m,n,m,n,n,m,m,m,m,n,n,m
 db n,m,n,m,m,m,n,n,m,n,n,n,n,n,n,n
 db n,n,n,m,m,m,n,m,m,n,n,m,n,n,n,n
 
 db m,n,n,n,n,n,n,m,n,m,n,n,n,n,n
 db m,n,m,n,m,n,m,n,m,n,n,m,m,n,m
 db m,m,n,m,n,m,m,m,m,m,n,m,n,n,m
 db n,n,m,n,n,n,m,n,n,n,m,n,m,m,m
 db m,m,n,n,n,m,n,m,n,m,n,m,n,m,m
 db n,m,n,n,n,m,m,n,m,n,m,m,m,m,m
 db m,n,n,n,n,m,n,n,m,m,n,n,m,n,n
;9
 db n,n,m,n,m,m,m,n,m,n,m,m,n,m,m,n
 db m,n,m,m,m,n,m,n,m,m,m,m,m,n,m,n
 db n,m,m,m,m,m,m,n,n,m,m,n,m,n,m,n
 db n,m,m,n,n,n,m,m,n,m,m,n,m,m,n,n
 db m,n,m,m,m,n,n,n,m,m,n,n,n,m,n,n
 db m,n,m,n,n,m,n,m,n,m,n,m,m,n,m,n
 
 db n,n,n,n,m,n,n,n,n,n,n,m,n,n,n
 db m,n,m,n,n,m,n,m,n,n,m,n,n,n,m
 db n,n,n,n,m,n,m,n,n,n,m,n,n,n,m
 db m,n,n,m,n,n,n,m,m,n,n,m,n,m,m
 db n,n,n,n,m,n,n,m,n,m,m,n,m,n,n
 db n,n,n,m,m,m,m,n,n,n,m,m,n,m,m
 db n,n,m,n,m,n,m,n,m,n,n,n,n,m,n
;10
 db n,m,m,m,n,m,n,m,n,n,m,n,m,m,m,n
 db n,n,n,m,m,n,n,m,m,m,n,m,n,m,n,n
 db n,n,m,n,m,m,n,m,m,n,m,m,m,m,n,m
 db n,n,n,m,n,m,n,m,n,n,m,m,n,m,m,m
 db m,n,m,m,m,m,m,m,n,m,n,n,m,n,m,m
 db n,m,m,m,m,n,n,m,n,n,m,n,m,n,m,n
 
 db n,m,n,n,n,n,n,m,m,m,n,n,m,n,n
 db m,m,n,n,m,n,n,n,n,n,n,n,m,n,n
 db n,m,n,m,n,m,n,n,m,n,n,m,n,n,m
 db m,m,n,n,n,m,n,m,m,n,m,n,n,m,n
 db m,n,n,m,n,m,m,n,n,n,n,n,n,n,n
 db n,n,n,n,n,n,n,m,m,n,m,n,m,m,n
 db n,n,n,n,m,m,n,m,m,m,n,n,m,n,n
;11
 db m,n,m,n,n,n,m,m,n,n,n,n,m,n,n,m
 db n,n,n,m,m,m,n,m,m,m,n,n,m,n,m,n
 db n,n,m,m,n,m,n,n,m,m,n,n,m,n,n,n
 db n,m,m,n,n,m,n,m,m,n,n,m,m,n,n,m
 db m,n,n,n,n,n,n,m,n,n,m,n,n,m,n,n
 db n,m,m,m,m,n,m,n,n,n,m,n,m,m,n,n
 
 db n,n,n,n,m,n,n,n,m,m,m,n,m,n,n
 db n,m,m,m,n,m,m,n,m,n,m,m,n,m,n
 db m,m,n,n,n,n,m,n,n,n,n,m,n,n,m
 db m,n,m,m,m,n,n,n,m,m,m,n,m,m,m
 db n,n,n,n,m,m,n,m,n,m,n,n,n,m,m
 db n,m,m,m,n,m,m,m,m,n,m,m,n,m,n
 db n,m,n,n,n,n,n,n,m,n,m,n,m,n,m
;12
 db n,n,n,n,m,m,n,n,n,n,m,n,m,n,m,n
 db n,m,m,m,n,m,m,n,n,n,n,n,m,m,m,n
 db n,n,n,m,n,m,m,m,m,n,n,n,n,m,n,n
 db n,m,n,n,m,m,n,n,n,m,n,m,n,m,m,n
 db n,n,n,m,n,m,m,n,m,n,m,n,n,m,n,n
 db n,n,m,n,m,n,m,m,n,n,n,m,n,n,n,m
 
 db n,n,m,n,n,n,m,m,m,n,m,n,n,n,m
 db m,m,n,m,m,n,m,n,n,m,m,m,n,n,n
 db n,n,n,n,m,n,n,m,m,m,n,n,m,n,n
 db m,m,m,m,m,n,m,n,n,n,m,m,m,n,m
 db n,m,n,m,n,n,m,m,m,m,n,m,n,m,m
 db m,m,m,n,n,n,n,m,n,m,m,m,m,n,m
 db m,n,n,n,m,n,n,m,m,n,n,n,n,m,n
;13
 db n,n,n,m,n,n,n,m,m,m,n,m,n,n,n,n
 db m,n,n,n,m,n,m,m,m,m,m,n,m,n,n,m
 db n,m,n,m,m,m,n,m,m,n,m,n,n,m,n,n
 db m,n,m,n,m,m,n,n,m,m,n,m,n,n,m,n
 db m,n,n,n,n,n,n,m,m,m,n,m,m,n,m,n
 db n,m,m,n,m,m,n,n,n,n,m,m,m,m,n,n
 
 db m,m,n,m,n,m,n,n,n,n,n,n,m,n,n
 db n,n,n,n,m,n,m,n,n,n,m,m,n,m,m
 db m,m,m,m,n,m,n,n,m,m,n,m,m,m,m
 db n,n,n,n,m,n,n,n,m,n,m,n,m,m,n
 db n,m,m,n,m,n,m,n,n,m,n,n,n,n,n
 db n,n,m,m,n,m,m,n,m,n,n,n,m,m,n
 db m,n,n,m,n,n,m,m,n,n,n,n,n,m,m
;14
 db n,m,m,m,n,m,m,n,m,m,n,m,m,n,m,m
 db n,m,m,m,m,n,m,m,m,n,m,m,n,m,m,n
 db n,n,n,n,n,n,m,n,n,m,n,m,m,n,n,m
 db m,n,m,n,n,m,m,m,n,n,m,m,m,m,n,m
 db m,n,m,n,n,m,n,n,m,n,m,m,n,n,m,n
 db n,n,n,n,m,m,m,m,m,n,n,n,n,n,n,n
 
 db n,n,n,m,n,n,n,n,n,m,n,n,n,n,n
 db n,n,n,n,n,m,n,n,m,n,n,n,m,n,n
 db m,n,m,n,m,m,n,n,n,m,m,n,m,n,n
 db n,m,m,m,m,n,m,m,n,n,n,m,n,m,n
 db n,n,m,m,m,n,n,n,m,n,m,n,n,n,n
 db n,n,n,m,n,m,m,m,n,n,n,m,m,m,m
 db m,m,m,n,n,n,n,n,n,m,m,m,m,m,n
;15
 db n,m,n,m,m,m,m,m,m,n,m,m,n,m,n,n
 db m,n,m,m,m,m,n,n,m,n,m,m,m,m,n,m
 db n,n,m,m,m,n,m,n,m,n,m,m,m,n,m,n
 db m,n,m,n,n,n,n,n,n,m,n,m,m,n,m,n
 db m,m,n,m,n,m,n,n,m,n,m,m,m,m,n,m
 db n,n,n,m,m,m,m,n,n,m,n,m,n,m,n,n
 
 db n,n,n,n,n,n,n,n,m,n,n,n,n,n,n
 db n,m,n,n,n,m,m,n,n,n,n,m,m,n,m
 db m,n,n,n,n,n,n,n,m,n,n,n,n,m,n
 db n,n,n,m,m,m,n,m,n,m,n,n,m,m,n
 db n,m,n,m,m,m,m,m,m,n,n,n,m,n,m
 db m,n,n,n,n,m,m,m,n,m,n,n,m,n,m
 db n,m,m,n,n,n,n,n,m,n,n,m,n,n,n
;16
 db n,m,m,n,n,m,n,m,m,m,n,n,m,n,n,m
 db n,m,m,n,n,n,m,m,n,n,n,m,n,n,m,n
 db n,n,n,m,n,n,m,n,m,m,m,n,m,n,n,m
 db n,m,m,m,n,n,n,n,n,n,n,n,n,m,m,n
 db n,m,n,m,n,n,n,m,m,n,m,n,n,n,m,n
 db m,m,m,m,n,m,m,n,m,n,n,m,m,m,n,m
 
 db m,n,n,m,m,n,n,n,n,m,m,n,n,n,n
 db n,m,n,m,m,n,n,n,n,n,n,m,n,m,n
 db n,n,n,m,m,n,m,m,m,m,n,m,m,m,n
 db m,m,n,n,m,m,m,n,n,n,m,m,m,m,m
 db n,m,n,m,m,m,m,m,m,m,m,m,m,n,n
 db n,n,m,n,m,m,n,n,n,m,n,n,n,m,m
 db n,n,n,n,n,n,n,n,m,n,n,n,n,n,n
;17
 db n,n,m,m,m,n,n,n,n,n,n,m,m,n,n,n
 db n,m,n,m,n,n,m,n,m,m,m,n,n,n,m,n
 db n,n,m,n,m,m,n,n,n,m,m,m,n,n,m,n
 db m,m,n,m,n,m,n,m,m,m,n,n,m,m,n,m
 db n,n,n,m,m,n,m,m,n,m,n,n,m,m,m,n
 db n,n,m,n,n,m,n,n,m,m,n,m,n,m,n,n
 
 db n,n,m,n,n,n,m,n,m,m,m,n,n,m,m
 db m,m,n,n,n,m,n,m,n,n,n,m,n,m,n
 db n,n,m,m,m,n,m,m,n,n,m,n,m,n,m
 db m,m,n,n,n,n,m,n,m,n,n,m,m,m,n
 db n,m,n,m,n,m,n,n,n,n,m,n,n,n,n
 db m,m,m,n,n,m,m,m,n,m,m,n,n,m,m
 db m,n,n,m,n,n,n,m,n,n,m,n,n,n,m
;18
 db m,n,n,n,m,n,m,m,n,n,n,m,m,n,n,n
 db n,m,n,n,m,m,n,m,m,n,m,n,n,m,n,m
 db m,n,n,n,n,n,m,n,n,m,n,n,m,m,n,n
 db n,n,n,m,m,m,m,n,n,n,m,n,m,n,n,n
 db n,n,m,m,n,m,m,n,n,m,n,n,m,m,n,n
 db m,n,m,m,n,m,m,m,n,n,n,n,m,n,m,n
 
 db n,n,n,m,n,m,n,n,n,n,n,n,n,m,n
 db n,m,m,n,m,n,n,m,m,m,n,m,m,m,m
 db m,m,m,m,m,n,m,m,m,n,m,n,n,m,n
 db n,m,m,n,m,n,n,m,n,n,m,n,m,m,m
 db m,n,n,n,m,n,n,m,m,m,m,n,n,n,m
 db m,n,m,n,n,n,n,m,m,m,n,m,n,m,m
 db n,m,n,n,n,n,n,n,n,m,m,n,m,n,n
;19
 db n,m,n,n,n,m,n,n,m,n,m,m,n,m,n,n
 db m,m,n,n,n,m,n,n,n,m,m,n,n,m,m,n
 db n,n,m,n,m,m,m,n,m,m,m,m,n,m,n,m
 db n,n,n,n,m,m,n,m,n,m,m,n,m,n,m,n
 db m,n,n,n,n,m,n,n,m,n,n,n,m,n,n,n
 db m,n,m,m,n,m,n,n,n,n,n,m,n,m,m,n
 
 db n,m,m,m,n,m,m,m,n,n,n,m,n,n,m
 db n,n,m,n,n,m,n,m,n,n,n,m,m,n,n
 db m,m,n,m,n,m,m,n,n,m,n,n,m,n,n
 db m,m,n,n,n,m,n,n,n,m,n,m,m,n,m
 db n,m,m,m,n,n,n,m,n,m,m,n,m,m,n
 db n,n,m,n,n,m,m,m,m,n,m,n,n,n,m
 db n,n,n,m,m,n,m,m,n,m,m,n,n,m,n
;20
 db n,n,m,n,m,m,m,n,m,m,n,m,n,n,n,n
 db m,n,m,n,m,m,m,n,n,m,m,n,m,n,n,m
 db n,n,n,m,n,n,n,m,n,n,m,m,m,m,n,n
 db m,n,m,n,m,m,m,m,m,n,n,m,n,m,n,m
 db n,m,n,m,n,m,m,m,n,n,n,m,m,n,n,n
 db n,n,n,m,m,n,n,n,n,m,m,n,m,m,m,n
 
 db m,n,n,n,n,n,n,n,n,n,n,n,m,n,n
 db n,n,m,n,m,n,n,n,m,n,m,m,n,m,m
 db m,m,n,m,n,m,m,m,m,n,n,n,m,m,m
 db n,m,m,n,m,n,m,n,m,m,m,n,n,n,n
 db m,n,n,m,n,n,n,n,n,m,m,n,n,m,m
 db n,n,m,n,m,m,n,m,m,m,n,n,n,m,n
 db m,m,n,n,n,n,m,m,n,n,n,m,n,n,n
;21
 db n,n,m,m,n,n,n,m,n,n,n,m,m,m,n,n
 db m,n,n,n,n,m,n,n,m,n,m,m,m,m,m,n
 db n,m,n,n,m,n,n,n,m,m,m,m,n,n,n,m
 db n,n,m,n,m,n,m,m,n,n,n,m,n,m,m,n
 db n,n,n,n,m,m,m,n,n,m,n,m,m,m,n,m
 db n,n,n,m,m,m,m,m,n,m,n,n,n,n,m,m
 
 db m,m,n,n,m,m,n,m,n,m,n,n,n,n,n
 db n,m,n,n,m,n,m,n,m,n,m,n,n,n,m
 db m,n,m,m,n,m,m,m,n,m,n,n,m,n,n
 db m,m,m,n,m,m,n,n,n,m,m,n,m,m,n
 db m,n,m,m,n,n,m,n,m,m,n,n,n,m,n
 db n,m,n,n,n,n,n,m,n,n,m,n,m,n,n
 db m,m,m,n,n,n,n,n,m,n,m,m,n,n,n
;22
 db n,m,m,n,m,n,m,m,n,n,n,m,n,n,n,m
 db n,m,n,n,m,m,n,n,m,n,m,m,m,n,m,m
 db n,m,m,n,m,n,m,n,n,n,n,m,n,n,m,n
 db n,m,n,m,m,n,n,m,n,n,m,m,n,n,m,n
 db n,n,n,n,m,n,m,n,n,m,m,n,m,n,n,m
 db m,n,m,n,n,m,m,n,m,m,m,m,n,n,n,n
 
 db n,n,m,n,n,m,n,n,m,n,n,m,n,m,n
 db n,n,m,m,n,n,m,m,n,m,n,m,m,n,n
 db m,n,n,m,n,n,m,m,n,n,m,n,m,n,n
 db m,n,m,m,n,m,n,m,m,m,n,m,m,n,m
 db n,m,n,n,m,n,n,n,m,n,n,n,n,m,n
 db m,m,m,n,n,m,n,m,n,m,n,m,m,m,m
 db n,m,n,m,m,n,n,n,n,n,n,n,m,m,n
;23
 db m,n,m,n,m,m,n,n,n,n,m,n,n,m,m,n
 db n,n,m,m,n,n,m,n,n,m,n,m,n,n,m,n
 db n,m,n,m,n,n,n,m,n,m,n,m,n,m,n,n
 db m,m,m,n,m,n,m,n,n,m,m,m,n,m,n,n
 db n,m,m,m,n,n,m,n,m,m,n,m,n,m,m,n
 db n,m,m,m,m,m,n,m,n,m,n,m,n,m,m,m
 
 db n,n,n,n,n,n,m,n,n,m,n,m,m,n,n
 db n,n,m,m,m,m,n,m,m,n,m,n,m,m,n
 db m,m,m,n,m,n,m,m,n,m,m,n,n,n,n
 db n,n,m,m,n,m,n,n,m,n,n,m,n,m,m
 db n,n,m,n,n,m,n,m,m,n,n,m,n,m,m
 db n,n,n,n,m,m,n,m,n,n,n,m,m,n,n
 db m,n,n,n,n,n,n,n,m,n,n,n,n,n,n
;24
 db n,n,m,n,m,n,n,n,m,n,m,n,n,m,n,m
 db n,m,m,m,n,m,n,m,n,m,n,m,n,m,n,m
 db n,m,m,n,m,n,n,m,n,n,m,n,n,n,n,n
 db n,m,n,m,n,m,m,m,n,m,n,n,m,n,n,n
 db m,m,m,m,m,n,m,m,m,n,m,n,n,m,m,n
 db n,m,n,m,m,n,n,m,m,n,m,m,n,m,n,n
 
 db n,n,m,n,m,n,n,n,n,n,m,n,m,n,n
 db m,n,n,n,m,m,m,m,m,n,m,m,m,n,n
 db n,n,n,m,n,m,n,n,m,n,m,n,n,m,m
 db m,n,m,m,n,n,n,m,m,m,n,m,m,m,n
 db n,m,n,n,m,n,m,n,n,n,m,n,m,n,m
 db n,n,n,n,n,n,n,n,n,m,n,m,m,n,m
 db n,m,n,n,m,m,n,n,m,n,m,n,n,m,n
;25
 db n,n,n,n,m,n,n,n,m,m,n,m,m,m,n,n
 db n,n,n,m,n,m,n,n,n,n,n,m,n,m,m,m
 db n,n,n,m,m,m,n,m,n,m,n,n,n,n,m,m
 db m,n,m,n,n,n,m,m,n,m,n,m,m,m,n,n
 db n,n,m,m,m,m,n,m,m,m,m,m,m,n,n,n
 db n,m,m,m,n,n,n,n,m,n,m,n,m,n,m,m
 
 db m,n,n,n,m,m,m,n,n,n,n,n,n,n,n
 db m,m,m,m,m,n,n,m,n,m,n,m,n,m,m
 db n,m,n,n,n,m,m,m,m,n,n,n,m,n,n
 db m,m,m,m,m,n,n,m,n,m,m,m,n,m,m
 db n,n,n,n,n,n,m,n,m,n,m,n,n,m,m
 db m,m,n,n,m,m,m,n,m,n,n,n,n,n,n
 db n,n,n,n,m,n,n,n,n,m,n,n,n,n,n
;26
 db m,n,n,m,n,n,m,m,m,n,m,n,m,n,n,n
 db m,n,m,n,m,m,m,n,n,m,m,m,n,n,n,m
 db n,n,n,m,n,n,n,m,n,m,m,n,n,m,n,n
 db n,m,m,m,m,m,n,m,m,m,n,m,n,n,m,m
 db n,m,m,n,n,m,n,m,m,m,n,m,m,n,m,n
 db n,m,n,m,n,n,m,m,n,m,m,m,n,n,n,m
 
 db n,n,m,n,n,n,m,n,n,n,n,n,m,m,m
 db n,m,n,n,m,n,n,m,n,m,n,n,m,m,n
 db n,n,m,n,n,m,m,n,m,n,n,n,n,n,n
 db m,m,m,n,m,m,n,n,m,n,m,m,n,m,m
 db n,n,n,m,m,n,n,n,n,m,m,n,m,n,n
 db n,m,n,m,m,n,m,n,n,n,n,n,m,n,m
 db n,m,n,m,n,n,n,n,n,n,n,m,m,m,n
;27
 db n,m,n,n,n,n,m,m,n,n,n,m,n,m,n,n
 db m,m,m,n,m,m,n,n,n,m,n,n,m,n,n,m
 db n,n,n,n,n,n,n,m,n,m,n,m,n,n,m,n
 db n,n,m,m,n,m,n,m,n,n,m,n,n,m,n,n
 db n,n,m,n,n,n,m,n,m,m,n,m,m,m,m,n
 db n,n,n,m,n,m,n,n,n,n,n,m,n,n,n,n
 
 db n,m,n,m,n,m,n,n,n,n,n,n,n,n,n
 db n,n,m,m,m,n,n,m,m,m,m,n,m,m,m
 db n,n,m,m,m,m,m,n,n,m,m,m,n,m,n
 db m,m,n,n,n,m,m,n,n,m,m,m,m,n,m
 db m,n,n,m,m,n,m,m,m,n,n,n,n,m,m
 db m,m,m,m,m,m,n,m,m,n,m,n,m,n,n
 db m,m,n,n,n,n,m,n,n,m,n,n,n,m,m
;28
 db n,n,m,n,n,n,m,n,m,n,n,m,m,m,n,n
 db n,n,n,n,n,n,m,m,m,n,m,n,n,n,n,m
 db n,n,n,m,m,m,n,n,m,n,m,m,n,m,m,m
 db n,m,m,n,n,n,m,m,m,n,m,n,n,m,n,n
 db n,m,m,n,m,n,n,n,m,n,m,n,n,n,n,n
 db n,m,m,m,n,m,n,n,n,m,m,n,n,n,n,m
 
 db m,n,m,m,m,n,m,n,n,n,n,m,n,n,n
 db n,m,n,n,m,m,n,m,n,m,m,m,n,n,m
 db m,m,m,m,n,n,m,n,m,m,n,n,m,m,n
 db m,n,m,m,n,m,n,m,n,n,m,m,n,n,m
 db n,n,n,n,m,n,m,n,n,n,n,n,m,m,n
 db n,m,n,m,m,m,n,m,m,m,n,m,m,n,m
 db m,n,n,n,n,n,m,n,n,n,m,m,m,m,n
;29
 db n,n,m,m,m,m,n,n,m,n,n,n,m,n,m,n
 db n,m,n,n,m,m,m,m,n,m,n,m,n,n,m,n
 db m,n,m,n,m,n,m,n,m,n,n,n,n,n,m,n
 db m,n,n,m,n,n,m,m,m,n,m,n,m,m,n,n
 db n,n,n,m,m,m,m,m,n,m,m,n,m,n,m,n
 db n,n,n,m,n,m,n,n,m,m,m,n,n,n,m,m
 
 db n,n,n,n,m,n,n,n,m,n,n,n,n,n,m
 db m,m,n,m,n,n,m,n,m,m,m,m,m,n,m
 db n,m,m,m,n,n,m,n,n,m,m,n,m,n,m
 db n,n,m,n,n,n,n,n,m,n,n,m,m,m,n
 db n,m,n,n,m,m,n,n,n,n,m,n,n,n,m
 db m,m,m,n,n,m,m,m,n,n,m,m,m,m,n
 db m,m,n,m,n,n,n,n,n,n,n,m,n,n,n
;30
 db m,n,n,n,m,n,m,m,m,n,n,m,n,m,m,m
 db n,n,n,n,m,m,m,n,m,n,m,m,m,n,m,m
 db n,m,n,m,m,n,m,m,n,m,n,m,n,m,m,m
 db m,n,n,n,n,m,m,n,n,n,m,n,m,n,n,m
 db m,n,n,n,m,m,n,m,m,n,n,n,n,m,m,n
 db n,m,m,m,m,m,m,n,m,m,n,n,m,m,m,n
 
 db n,m,m,n,n,n,n,m,n,n,m,n,n,n,n
 db n,n,n,n,m,n,n,n,n,m,n,n,n,n,n
 db m,m,m,n,n,n,m,m,m,n,m,n,n,n,n
 db m,n,m,m,n,m,n,n,m,m,m,n,n,m,n
 db n,m,m,m,m,n,n,m,n,m,n,n,m,m,n
 db n,m,n,m,n,n,m,n,n,n,m,m,n,m,n
 db n,n,n,n,n,m,n,n,n,m,m,n,n,n,n
;31
 db m,m,n,n,n,n,n,n,m,n,n,n,m,n,m,m
 db m,n,n,m,m,n,m,n,m,n,n,n,n,m,m,n
 db m,n,n,n,n,m,m,n,n,m,m,n,n,n,m,m
 db m,n,m,n,m,m,m,n,n,n,n,n,m,m,m,n
 db n,n,n,n,m,m,m,m,m,m,n,n,m,n,n,n
 db n,m,n,m,n,m,n,n,n,m,n,m,n,m,m,n
 
 db n,n,n,m,n,m,n,n,m,m,m,n,n,n,n
 db n,m,m,m,m,n,m,n,n,n,m,m,m,n,n
 db n,m,m,m,n,m,n,m,m,m,m,n,n,n,m
 db n,n,m,m,n,n,m,n,n,m,m,m,m,n,n
 db n,m,n,n,m,n,n,m,m,n,m,n,m,m,n
 db m,n,m,m,n,n,m,n,n,n,n,n,m,n,m
 db n,m,n,n,n,m,n,m,n,m,m,n,n,n,m
;32
 db n,n,m,n,n,n,m,n,m,m,m,n,n,n,n,n
 db n,m,m,m,m,m,n,n,m,n,n,m,m,m,n,n
 db n,n,m,n,n,n,n,m,m,n,m,n,n,n,n,n
 db m,n,m,n,m,m,n,m,m,m,m,n,n,m,n,n
 db n,m,n,m,n,n,m,n,n,m,n,m,n,n,n,n
 db n,n,m,n,n,m,n,n,n,n,m,n,m,n,m,m
 
 db n,n,m,n,n,n,n,n,n,n,m,n,n,n,n
 db m,n,n,m,m,m,n,m,n,n,n,m,m,m,m
 db m,n,n,n,m,m,m,n,n,m,m,m,m,m,m
 db m,n,m,m,n,m,m,n,n,n,n,n,m,n,m
 db n,m,n,m,n,n,n,n,m,n,n,m,m,n,m
 db m,n,n,m,m,m,m,m,m,m,m,m,m,m,m
 db m,n,m,n,n,m,n,m,n,n,n,m,n,n,n
;33
 db n,n,m,m,n,n,m,n,n,m,n,m,n,m,n,n
 db n,n,m,n,n,n,n,n,m,m,m,m,n,n,n,m
 db n,n,m,n,n,m,m,n,m,m,n,n,m,n,m,n
 db n,m,m,m,m,m,n,m,m,n,m,m,n,m,n,m
 db n,m,m,n,n,m,m,m,m,n,n,m,n,n,m,n
 db m,n,n,m,m,m,n,n,m,m,n,n,n,n,n,n
 
 db m,m,n,n,m,n,n,n,n,m,n,n,n,m,n
 db m,n,n,m,n,m,m,m,n,n,m,n,n,m,m
 db m,n,m,n,m,m,n,n,n,n,m,m,m,m,n
 db n,n,m,m,n,m,n,m,n,m,m,n,m,n,n
 db m,n,n,m,n,m,n,n,m,n,n,m,m,m,n
 db n,m,n,n,n,n,n,n,m,m,n,m,m,n,m
 db n,m,m,n,n,n,m,n,n,n,m,n,n,m,n
;34
 db n,m,m,n,m,m,m,m,n,m,m,m,n,n,n,n
 db n,n,n,m,n,m,m,m,n,m,n,n,m,m,m,n
 db n,n,n,m,m,n,m,m,n,n,m,n,m,n,n,n
 db n,n,m,m,m,n,m,n,m,n,m,m,n,n,n,m
 db n,m,n,n,n,m,n,m,n,m,m,n,n,m,n,n
 db m,m,m,n,m,n,m,n,n,n,m,n,n,m,m,n
 
 db n,m,n,n,n,n,n,n,n,n,n,m,n,n,n
 db n,n,n,n,n,n,m,n,n,n,m,n,m,m,m
 db m,m,n,m,n,m,n,n,n,m,n,n,n,m,n
 db m,m,n,m,n,m,n,n,m,n,m,m,m,m,m
 db m,m,m,m,m,m,n,m,m,n,n,m,m,m,m
 db m,n,n,n,n,n,m,m,n,n,n,n,n,m,n
 db n,n,n,m,n,n,m,n,m,n,m,m,m,n,n
;35
 db m,n,m,n,n,m,n,n,m,n,m,n,n,m,m,n
 db m,n,n,n,m,n,n,n,m,m,n,n,m,m,n,n
 db n,m,m,n,n,m,n,n,m,m,m,n,n,m,n,n
 db n,n,n,m,m,n,m,m,m,n,n,m,m,n,n,m
 db m,n,m,n,n,n,n,n,m,n,m,n,n,m,n,n
 db n,m,n,m,m,m,n,n,m,n,m,m,m,n,m,n
 
 db n,n,n,m,n,m,m,n,m,n,n,n,n,m,n
 db n,n,m,n,m,n,m,m,n,m,n,m,m,n,n
 db n,m,m,m,n,m,n,n,n,n,m,m,n,m,m
 db m,m,m,m,n,m,m,m,n,m,m,n,m,n,m
 db n,n,m,m,n,n,m,n,n,m,n,m,n,m,m
 db n,n,n,n,m,m,n,n,m,n,n,n,m,n,n
 db n,m,n,n,m,n,m,m,n,m,n,n,n,m,n
;36
 db n,m,n,m,m,n,m,m,n,m,m,m,m,m,m,n
 db n,m,m,m,n,m,m,n,n,n,m,n,m,m,n,n
 db n,n,m,n,n,n,n,m,m,n,m,n,m,m,n,m
 db m,m,m,m,m,n,m,m,m,n,m,n,n,m,m,m
 db n,n,n,n,n,n,m,n,n,n,n,m,n,n,n,n
 db n,n,m,n,n,n,n,m,n,m,n,n,m,n,n,n
 
 db n,n,n,n,m,n,n,n,n,n,n,n,n,n,n
 db m,n,n,m,n,m,n,m,n,n,n,m,n,n,m
 db n,n,m,n,n,n,n,m,m,n,m,n,n,m,m
 db m,n,n,m,m,m,m,n,n,m,n,m,n,n,n
 db m,n,m,m,n,m,n,n,n,n,m,m,n,m,m
 db n,m,n,n,m,m,m,m,m,m,n,n,m,n,n
 db m,n,m,m,m,n,m,n,m,n,m,n,m,m,m
;37
 db n,n,m,n,m,m,n,n,n,m,m,n,n,n,n,n
 db m,n,m,n,n,n,m,n,m,n,m,m,n,m,m,m
 db n,n,n,n,n,m,n,m,m,m,m,m,n,n,n,n
 db n,n,m,n,m,n,n,n,m,n,m,n,n,m,n,n
 db n,n,m,m,n,n,m,m,n,n,n,m,m,n,m,n
 db m,m,m,n,n,m,n,m,m,n,m,m,n,m,m,n
 
 db n,n,n,m,n,n,n,n,n,n,n,m,n,m,m
 db m,n,m,m,m,m,m,m,n,n,m,m,m,n,n
 db m,m,m,m,m,n,n,n,m,n,n,n,m,n,n
 db m,m,n,m,n,m,n,n,m,n,m,m,n,m,m
 db n,m,n,m,m,n,m,m,n,m,n,n,n,m,m
 db m,n,n,m,m,n,n,m,m,n,m,n,m,m,n
 db n,n,n,n,n,n,n,m,n,n,n,m,n,n,n
;38
 db m,n,n,n,m,n,m,n,n,n,m,n,n,m,n,n
 db n,m,m,n,n,m,n,n,m,n,n,n,n,n,m,m
 db n,n,n,n,m,n,n,m,n,n,m,m,n,n,m,m
 db n,n,n,m,n,n,m,n,n,m,n,n,n,m,m,n
 db m,n,n,n,n,m,n,m,m,n,n,m,m,n,m,m
 db m,m,m,n,m,n,n,n,n,m,n,n,n,n,n,n
 
 db n,n,n,n,n,n,n,n,n,m,n,m,n,n,m
 db n,m,m,m,n,m,m,m,m,n,n,n,m,n,n
 db n,m,m,m,m,n,m,n,m,m,m,m,m,n,n
 db m,m,m,m,n,m,n,m,m,n,n,m,m,n,m
 db m,n,n,m,m,m,m,m,m,m,m,m,n,n,n
 db n,m,m,n,n,m,m,n,m,n,m,m,n,n,m
 db n,n,n,n,m,n,n,m,n,n,n,m,m,m,n
;39
 db n,m,n,m,m,m,n,m,n,m,m,n,m,m,n,m
 db m,n,m,m,n,m,n,m,m,m,m,n,m,m,m,n
 db m,n,m,m,m,m,n,m,n,m,m,n,n,m,n,n
 db n,m,m,m,n,n,n,m,n,m,m,n,m,m,n,m
 db m,n,m,n,m,m,m,n,m,m,n,m,m,n,n,n
 db n,n,m,n,m,n,n,m,m,n,m,n,n,m,n,n
 
 db n,n,n,m,n,n,n,n,n,n,m,n,n,n,n
 db n,m,n,n,m,n,m,n,n,m,n,n,n,m,n
 db n,n,n,m,n,m,n,n,n,n,m,n,n,m,m
 db n,m,n,n,m,n,n,m,m,n,n,m,m,n,n
 db n,m,n,n,n,m,n,m,n,m,n,m,n,n,n
 db m,n,n,n,m,m,n,n,n,n,n,m,m,m,m
 db n,m,n,n,n,m,m,n,n,n,m,n,m,n,m
;40
 db n,m,m,n,n,n,m,n,n,n,m,n,n,m,n,m
 db n,m,m,n,n,m,m,m,m,m,m,n,m,n,n,m
 db n,m,m,n,n,n,m,m,n,n,m,n,n,n,n,n
 db n,m,n,n,n,m,m,n,m,n,n,m,m,n,n,m
 db n,n,m,m,n,n,n,m,n,m,m,n,n,m,m,n
 db n,n,m,m,m,n,n,m,m,m,n,m,n,n,n,n
 
 db m,n,n,m,n,n,m,n,m,n,n,m,m,n,n
 db n,n,m,m,m,n,m,m,n,n,m,n,n,n,n
 db n,m,n,m,m,n,n,n,m,n,m,m,m,m,n
 db m,n,n,n,n,n,m,n,n,m,n,m,n,m,m
 db m,m,m,m,n,m,n,m,n,m,n,m,m,m,m
 db n,n,n,n,m,m,m,n,n,n,m,n,m,n,m
 db m,m,n,n,n,m,n,n,n,m,n,n,n,m,n
;41
 db n,n,m,m,n,m,m,n,n,n,n,m,n,n,n,n
 db n,m,n,m,n,m,n,m,n,m,m,m,m,n,m,m
 db m,n,m,n,m,n,m,m,n,n,n,n,m,m,n,n
 db n,n,n,m,n,m,m,m,m,n,n,n,n,n,m,n
 db n,m,n,n,n,n,n,m,m,n,m,m,m,n,m,n
 db m,n,m,m,n,n,m,m,n,m,n,m,m,m,n,n
 
 db n,n,n,n,n,n,n,m,n,m,n,m,m,m,m
 db m,m,n,m,n,n,m,m,m,n,n,m,n,n,n
 db n,n,m,n,m,m,n,n,m,n,n,m,n,n,m
 db n,m,n,m,n,m,n,n,n,m,m,m,m,n,n
 db m,m,m,m,m,m,n,n,n,m,m,n,n,n,m
 db n,m,n,m,m,n,m,n,m,m,n,n,m,m,m
 db n,n,n,n,m,n,n,m,n,n,n,n,n,n,n
;42
 db m,n,n,n,m,m,n,n,n,m,n,m,n,n,n,n
 db m,n,m,n,n,m,n,m,n,n,m,n,n,m,n,n
 db n,m,n,n,n,n,n,n,n,m,n,n,m,n,n,m
 db n,m,m,m,n,n,n,m,m,n,n,m,n,n,n,n
 db n,m,n,n,n,m,m,n,n,n,n,n,m,m,n,m
 db m,n,n,m,n,n,m,m,n,m,m,n,m,m,m,n
 
 db n,m,n,m,n,n,n,n,n,n,n,n,n,n,m
 db n,m,m,m,n,n,m,m,m,n,m,m,m,m,m
 db n,n,m,m,m,n,n,m,m,m,n,m,n,m,n
 db n,m,n,n,m,m,m,m,m,n,m,n,m,m,n
 db m,n,n,m,m,m,m,n,m,m,m,m,m,m,m
 db n,m,m,m,m,n,n,m,m,m,n,n,n,n,n
 db n,n,n,m,n,m,n,n,n,n,n,n,n,n,m
;43
 db n,m,n,m,m,n,m,m,m,n,m,m,n,m,m,n
 db n,m,m,m,n,m,n,m,m,m,n,m,m,m,n,n
 db n,n,n,m,m,n,n,m,m,m,m,m,m,n,m,m
 db n,m,n,n,m,m,m,n,m,n,m,m,m,n,m,n
 db n,n,n,n,m,n,n,n,m,n,m,m,n,m,m,n
 db m,n,n,m,m,n,m,m,m,n,m,n,m,m,m,n
 
 db n,n,m,n,n,n,n,n,m,n,n,n,n,n,m
 db n,m,n,m,n,n,n,n,n,n,m,n,n,m,m
 db n,m,n,n,n,m,m,n,n,n,n,n,n,n,n
 db m,m,m,n,n,m,n,m,n,n,n,n,m,m,n
 db n,n,m,n,m,m,n,n,n,n,n,n,m,n,m
 db m,m,m,m,n,m,m,m,n,n,m,n,n,n,m
 db n,m,n,n,m,n,n,n,n,m,n,n,n,n,n
;44
 db n,m,m,n,m,n,m,n,n,m,n,m,m,m,n,n
 db n,n,m,m,n,n,m,m,m,n,m,n,m,m,m,n
 db n,n,m,m,m,m,n,m,n,m,n,m,m,n,m,n
 db n,m,m,m,n,n,m,n,m,m,m,n,n,m,m,n
 db m,n,n,n,m,m,m,m,m,n,m,n,m,m,m,m
 db n,n,m,n,n,m,m,n,m,n,m,n,m,n,m,n
 
 db m,n,n,n,n,n,m,m,m,n,n,m,n,n,m
 db m,n,n,m,n,n,n,n,n,n,n,n,m,n,n
 db n,n,m,n,m,n,n,m,m,n,m,n,n,m,n
 db m,n,n,m,m,n,m,n,n,n,n,m,m,n,m
 db n,n,n,n,m,m,n,n,n,n,m,n,n,n,n
 db n,m,m,n,n,n,m,m,n,n,m,n,n,n,n
 db m,n,m,m,n,n,m,n,n,m,n,m,n,n,m
;45
 db n,m,m,n,n,m,n,n,m,m,m,n,m,n,m,n
 db m,n,n,n,m,m,n,m,n,m,n,m,m,m,n,n
 db n,n,m,n,n,m,n,n,n,m,n,m,m,n,n,m
 db n,m,n,m,m,m,m,m,n,m,m,m,n,m,n,m
 db n,m,m,n,m,n,m,n,m,n,m,m,n,m,m,n
 db n,m,m,m,m,n,n,n,m,m,m,n,m,n,n,n
 
 db n,n,n,n,m,n,n,n,m,n,n,n,n,n,m
 db m,m,m,m,n,n,m,n,n,m,n,m,n,n,m
 db m,n,n,n,m,n,n,m,m,n,m,n,n,n,n
 db n,n,m,m,m,n,m,m,n,n,n,m,m,m,n
 db m,n,n,m,n,m,n,n,n,n,n,m,m,n,n
 db n,n,m,n,m,m,n,m,n,n,m,n,n,n,m
 db n,n,n,n,n,m,m,n,n,n,n,m,n,m,m
;46
 db m,n,n,m,m,m,n,n,m,n,n,n,n,n,n,n
 db m,m,n,m,n,n,n,n,n,n,n,m,n,m,m,n
 db n,m,n,m,m,m,m,n,m,n,n,n,m,m,n,n
 db m,n,n,m,n,n,n,m,m,n,n,m,m,n,m,n
 db m,n,n,m,m,m,n,n,m,m,m,m,m,m,m,n
 db m,m,n,m,m,n,n,n,m,m,n,n,n,m,n,n
 
 db n,n,n,n,n,n,m,n,m,m,n,m,n,m,m
 db n,m,n,m,m,m,m,n,n,m,m,n,m,m,n
 db n,n,n,n,n,m,m,m,m,n,m,n,m,n,m
 db m,m,n,m,m,n,n,m,n,m,m,n,n,n,n
 db n,n,n,n,n,m,n,m,n,m,n,n,m,n,m
 db n,m,n,m,n,m,m,n,n,m,m,m,n,m,m
 db n,n,n,n,n,m,m,m,n,n,n,n,n,n,n
;47
 db m,n,m,m,m,n,m,n,m,n,n,m,n,m,m,n
 db m,n,n,n,m,m,n,n,m,m,m,n,m,n,m,n
 db m,n,n,n,n,m,m,n,m,m,n,m,m,m,m,n
 db m,n,m,n,n,m,n,n,m,m,n,m,m,m,n,m
 db n,m,n,n,m,n,n,m,m,n,m,m,n,m,n,m
 db n,m,m,n,n,n,m,n,m,n,m,m,m,m,n,m
 
 db n,n,m,n,n,n,n,n,m,m,m,n,n,m,n
 db n,m,m,n,n,m,n,n,n,n,n,n,n,n,m
 db n,n,n,m,m,n,m,n,n,m,n,n,m,n,n
 db n,m,m,m,n,m,m,n,m,n,n,n,n,n,m
 db m,n,m,m,n,n,m,m,n,n,n,n,n,m,n
 db n,m,m,n,n,m,n,n,m,m,n,n,n,m,n
 db n,n,n,m,m,n,m,n,m,n,n,n,m,n,n
;48
 db n,n,m,n,m,m,m,n,m,m,m,n,n,n,n,n
 db n,m,n,n,n,m,m,m,n,m,m,m,m,n,n,n
 db n,m,n,n,m,n,m,n,n,n,n,m,n,m,n,m
 db n,m,n,m,n,m,m,m,m,m,n,n,n,m,m,n
 db n,m,m,m,m,n,m,m,m,n,n,n,m,n,m,n
 db m,n,n,n,m,m,n,n,n,m,m,n,m,m,n,m
 
 db n,n,n,n,n,n,n,n,n,n,n,n,m,n,m
 db m,m,m,n,m,n,n,n,m,n,n,m,n,m,m
 db n,n,m,m,m,m,n,m,m,m,m,n,m,m,n
 db n,m,m,m,n,n,n,m,m,n,n,n,n,m,n
 db m,n,n,n,m,n,n,n,n,m,m,m,m,m,n
 db n,m,n,m,n,m,n,m,m,n,m,n,n,n,n
 db n,n,m,n,n,n,m,n,m,n,n,m,n,n,n
;49
 db n,n,n,n,n,n,n,n,m,n,m,n,n,m,n,n
 db n,n,m,m,m,n,n,n,n,m,n,m,n,n,n,m
 db n,n,m,n,m,n,n,m,m,n,m,m,n,n,n,m
 db n,m,n,m,m,n,m,m,m,n,m,n,n,n,n,m
 db n,m,n,n,n,n,n,m,n,n,n,n,m,n,n,m
 db n,n,m,m,n,m,m,n,n,m,m,n,m,n,m,n
 
 db m,n,n,n,m,n,n,n,n,n,n,m,n,m,n
 db m,m,m,m,n,m,m,n,m,m,n,n,m,m,m
 db m,m,n,n,n,m,m,m,m,m,n,m,m,n,n
 db n,m,n,n,m,m,n,m,n,n,m,m,n,m,n
 db m,n,m,m,m,n,n,m,m,n,m,m,m,m,n
 db n,m,m,n,n,m,m,n,n,m,n,m,n,m,m
 db m,m,n,n,n,n,n,m,n,m,n,m,n,n,n
;50
 db n,m,m,m,n,m,m,n,n,n,n,m,m,n,n,m
 db n,m,m,n,n,m,n,n,m,n,n,m,m,m,m,n
 db n,n,n,n,m,m,n,m,n,n,n,m,n,m,m,n
 db n,n,m,n,n,m,n,m,n,m,m,m,n,m,m,n
 db n,n,m,n,m,n,n,m,n,n,m,n,n,m,m,n
 db m,n,n,m,m,n,m,n,m,n,m,n,n,n,n,m
 
 db n,n,n,n,n,n,m,n,m,n,m,n,n,n,n
 db n,n,m,m,m,n,n,m,m,m,n,m,n,m,n
 db n,n,m,m,n,m,m,n,n,m,m,n,n,n,n
 db m,m,n,n,n,n,n,m,m,m,n,m,m,n,n
 db m,m,n,m,m,m,n,m,n,n,n,n,m,n,n
 db m,m,n,n,m,m,m,m,m,n,m,m,m,m,m
 db n,m,n,n,n,n,n,m,n,m,n,m,n,n,n
;51
 db m,m,n,n,m,m,n,n,n,n,m,n,n,n,m,n
 db n,m,m,n,m,n,m,n,m,m,m,n,m,n,n,n
 db n,m,n,m,n,n,m,m,n,n,n,m,n,n,m,n
 db n,n,m,n,m,n,n,m,m,n,m,m,m,n,n,n
 db n,n,n,n,n,m,m,m,m,n,m,m,n,m,n,m
 db n,m,m,n,m,n,m,n,n,n,n,n,n,n,n,m
 
 db n,n,n,n,n,n,m,n,m,n,m,m,m,m,n
 db n,n,m,n,n,m,m,m,n,n,m,n,m,n,n
 db n,m,n,m,m,m,n,n,m,n,n,m,m,m,m
 db m,n,m,n,m,n,n,n,n,m,n,n,n,m,m
 db m,m,m,m,m,m,n,m,n,n,m,n,m,m,n
 db m,n,m,m,n,n,m,m,n,n,m,m,m,m,n
 db n,n,n,m,n,n,n,n,m,m,n,m,n,n,n
;52
 db n,n,n,m,m,m,n,m,n,m,n,n,m,n,m,n
 db n,n,m,m,m,n,m,n,n,n,m,n,m,n,m,m
 db n,n,n,n,m,m,m,m,n,m,n,m,m,n,n,m
 db m,m,m,m,n,n,n,m,m,n,m,n,m,n,m,n
 db n,m,m,m,n,m,m,m,m,m,n,m,n,m,n,n
 db m,n,n,n,m,n,n,m,n,n,m,n,m,m,m,n
 
 db n,n,n,m,n,n,n,n,n,m,m,m,n,n,m
 db m,m,n,n,n,n,m,m,m,n,n,n,n,n,n
 db m,n,m,n,n,m,n,n,m,n,m,n,m,n,n
 db m,m,m,n,n,m,n,m,n,m,n,n,m,m,n
 db n,n,n,n,m,n,n,m,n,n,n,m,m,n,m
 db n,n,m,m,n,n,n,n,n,m,m,n,n,m,m
 db n,m,n,m,n,m,n,m,m,m,n,n,n,n,n
;53
 db n,n,m,n,n,m,m,m,n,m,n,m,n,n,m,n
 db n,m,n,m,m,m,n,n,m,m,m,n,n,n,m,n
 db m,n,n,m,n,m,n,n,m,m,n,m,m,m,n,m
 db n,n,m,m,m,n,m,m,n,n,m,n,m,m,m,n
 db n,m,n,n,m,m,m,n,n,m,m,m,m,n,m,n
 db n,m,n,n,m,m,m,n,m,m,m,n,n,m,n,n
 
 db n,m,n,n,n,m,n,n,n,n,n,m,m,m,n
 db m,n,n,m,n,n,m,n,m,n,n,m,m,n,n
 db n,m,n,n,m,n,n,m,n,n,n,n,m,n,m
 db n,m,n,m,m,n,m,n,m,m,n,n,n,n,m
 db m,n,m,n,n,m,n,n,n,m,n,n,n,m,n
 db n,m,m,n,m,n,n,m,n,n,m,m,n,n,n
 db n,m,m,n,n,n,m,n,n,n,n,m,n,m,m
;54
 db m,n,n,m,n,n,n,n,m,n,m,n,n,n,m,n
 db n,m,m,n,m,n,m,m,n,m,m,n,m,m,n,m
 db m,m,m,n,n,m,n,n,m,n,n,m,n,m,n,n
 db n,n,m,n,m,n,m,n,n,m,m,n,n,m,m,m
 db n,m,n,n,m,m,m,n,n,n,m,m,n,n,n,m
 db n,m,n,m,n,m,m,m,m,n,n,n,m,m,m,n
 
 db n,m,n,n,n,m,n,n,n,n,n,m,n,m,n
 db n,n,m,m,m,n,m,n,m,n,m,n,m,n,n
 db n,m,n,m,n,n,m,n,n,m,m,m,n,m,m
 db m,n,m,m,m,m,m,m,n,n,m,n,n,n,n
 db m,n,n,n,m,n,n,m,m,m,n,m,n,n,n
 db n,m,m,m,n,n,n,m,m,m,n,n,m,m,n
 db n,n,n,n,n,n,n,n,n,m,m,n,n,m,n
;55
 db n,m,n,n,m,m,n,n,n,n,m,n,n,n,m,n
 db n,m,m,m,m,n,m,n,m,m,m,m,m,n,n,n
 db n,n,m,n,m,n,n,n,m,n,n,n,m,m,n,n
 db m,n,n,m,m,m,n,m,m,m,n,n,m,m,n,n
 db n,m,n,n,m,m,m,n,n,n,n,n,m,n,m,n
 db n,n,m,n,n,m,m,n,m,m,n,n,n,n,n,m
 
 db n,m,n,n,n,n,m,n,m,n,m,m,m,m,n
 db n,n,m,n,n,m,m,m,n,n,m,n,n,m,n
 db n,m,n,m,n,m,n,n,m,n,m,n,n,n,m
 db m,m,n,m,n,n,m,n,m,m,m,n,m,n,m
 db m,n,m,n,n,n,m,m,n,m,m,m,n,m,m
 db m,n,m,n,n,n,m,n,m,n,n,n,m,n,n
 db n,n,m,m,n,n,n,n,m,n,m,m,m,m,n
;56
 db n,n,m,n,n,m,n,n,n,m,n,n,n,m,m,n
 db n,m,m,n,m,n,m,n,m,n,m,m,n,m,m,n
 db n,m,n,m,n,m,m,m,n,n,m,n,m,n,n,m
 db n,n,n,n,n,n,n,m,n,m,n,m,n,n,n,m
 db n,m,m,n,m,n,n,m,m,m,n,m,m,m,m,n
 db m,m,n,m,m,n,n,m,m,n,n,n,n,m,n,n
 
 db m,n,m,n,n,n,m,n,n,m,m,n,n,n,m
 db n,m,n,m,m,m,n,m,m,n,n,m,n,n,n
 db n,n,m,n,n,n,m,n,n,n,n,m,n,n,m
 db m,m,m,m,m,m,n,m,m,m,m,m,n,m,n
 db n,m,n,m,m,m,n,n,n,n,m,n,m,m,m
 db n,n,m,n,n,m,m,n,n,m,m,m,n,m,n
 db n,n,n,m,n,n,n,n,n,m,n,n,n,n,m
;57
 db n,m,m,n,n,n,n,m,n,m,n,n,n,m,n,m
 db m,n,m,m,m,n,m,n,m,m,n,m,n,m,m,n
 db n,n,m,n,m,n,n,n,n,n,m,n,m,n,n,m
 db n,m,n,m,n,m,n,m,m,m,n,m,m,n,n,n
 db m,n,n,m,m,m,n,n,n,n,m,m,n,m,m,n
 db n,m,m,m,n,m,n,m,n,n,m,m,n,n,m,n
 
 db n,n,n,n,m,n,n,n,n,n,m,n,m,n,n
 db m,n,m,m,n,m,n,m,n,m,n,m,n,n,n
 db m,n,m,n,n,m,m,m,m,m,m,n,m,m,n
 db n,n,m,m,m,m,n,n,n,m,n,m,n,m,m
 db m,n,n,m,n,n,n,n,m,n,n,m,n,m,m
 db n,m,m,n,n,n,m,m,m,n,n,m,n,n,m
 db n,n,n,n,n,m,n,m,m,n,n,n,m,n,n
;58
 db n,m,n,m,n,n,n,m,n,m,n,n,m,n,m,n
 db m,n,m,n,m,n,m,n,n,m,m,n,n,m,n,n
 db n,m,m,n,n,n,m,n,n,m,n,m,n,m,n,n
 db n,m,m,m,n,m,n,n,m,m,m,n,m,n,m,n
 db n,m,n,n,n,n,m,m,n,m,n,m,m,m,n,n
 db n,n,n,m,m,n,m,m,n,m,m,m,n,n,n,m
 
 db n,m,n,m,n,n,n,n,n,m,n,m,n,n,m
 db n,n,m,m,m,m,m,m,n,m,m,n,n,m,m
 db m,n,n,n,m,n,n,m,n,m,m,m,n,n,n
 db n,n,n,m,n,n,m,m,m,n,n,n,n,m,m
 db m,n,n,m,n,m,m,n,n,m,m,n,m,m,m
 db m,m,m,n,m,n,m,n,n,m,n,n,m,m,n
 db n,m,n,n,m,m,n,n,n,n,n,n,n,n,n
;59
 db m,n,m,m,n,m,m,m,n,m,m,m,n,n,n,n
 db n,n,n,n,n,m,m,m,n,n,m,m,n,m,m,n
 db n,n,m,m,n,m,n,n,n,m,n,m,n,n,m,n
 db n,m,n,m,m,m,n,n,n,n,m,n,n,m,n,n
 db n,n,m,m,m,n,m,n,n,n,m,n,m,n,n,m
 db m,m,n,n,n,m,n,n,m,m,m,n,n,m,n,n
 
 db n,n,m,n,n,n,n,n,n,n,n,m,n,n,n
 db n,m,n,n,n,n,n,m,n,n,n,n,m,m,m
 db m,n,m,m,n,n,m,n,m,n,m,n,m,m,n
 db m,n,n,m,m,n,m,m,m,m,m,m,n,m,m
 db m,n,m,n,n,m,m,m,n,m,n,m,m,m,n
 db m,m,m,n,n,n,n,m,m,m,n,n,n,m,n
 db n,n,n,m,n,m,m,n,n,n,n,m,m,n,m
;60
 db t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,f
 db t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,f
 db t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,f
 db t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,f
 db t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,f
 db t,t,t,t,t,t,t,t,t,t,t,t,t,t,t,f
 
 db f,f,f,f,f,f,f,f,f,f,f,f,f,f,f
 db f,f,f,f,f,f,f,f,f,f,f,f,f,f,f
 db f,f,f,f,f,f,f,f,f,f,f,f,f,f,f
 db f,f,f,f,f,f,f,f,f,f,f,f,f,f,f
 db f,f,f,f,f,f,f,f,f,f,f,f,f,f,f
 db f,f,f,f,f,f,f,f,f,f,f,f,f,f,f
 db f,f,f,f,f,f,f,f,f,f,f,f,f,f,f
 
hp_table1:
 db 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
hp_table2:
 db 1,1,1,1,24,24,24,1,1
hp_table3:
 db 24,48,48,96,96,144,96
hp_table4:
 db 48,80,112,1,8,8,8,96
hp_table5:
 db 180,1,1,1,1,1,1,1,1,1,1,1,1,1,1,10110000b
 
;**********************************Variable**************************************
hi_floor:db 1
floor:db 0
pdoor_xy:dw 0;83h
pkey_xy:dw 0;85h
pgil_xy:dw 0;84h,8fh
obj:ds 48
obj_hp:ds 48
obj_wp:ds 48
obj_st:ds 48
obj_xy:ds 96;(x,y&d)
obj_st2:ds 48
obj_st3:ds 48

gil_button:db 0
gil_hp:db 0
gil_wp:db 0
gil_st1:db 0;00 or ffh:right foot or left foot
gil_st2:db 0;bit 0-6:counter,bit 7:sword set,if bit 7 enable and bit 0-6 > 0 dec (st2)
;
gil_matk:db 0;1:c,2:s,3:g,0:none
gil_matk_count:db 0;matk use count.it is deced when use a matk.
gil_bt:db 0;0ffh is dash enable.
gil_sword:db 0;1:dragon,2:ex
gil_armor:db 0;1 is hyper.
gil_gunt:db 0;1 is hyper.
gil_shield:db 0;1 is hyper.
gil_neck:db 0;1:g,2:r,3:b.

gil_xy:ds 2
gil_dblock:ds 2

Item:
matk:
 db 0
boot:
 db 0
sword:
 db 0:
armor:
 db 0:
gnt:
 db 0:
shield:
 db 0
hlmt:
 db 0
rod:
 db 0
book:
 db 0
kndl:
 db 0
brns:
 db 0
posion:
 db 0
key:
 db 0
nec:
 db 0
meis
 db 0

end