; ---------------------------------------------------------------------------
; Subroutine allowing player to jump
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


Sonic_Jump:
		move.b	(v_jpadpress2).w,d0
		andi.b	#btnABC,d0	; is A, B or C pressed?
		beq.w	locret_1348E	; if not, branch
		moveq	#0,d0
		move.b	obAngle(a0),d0
		addi.b	#$80,d0
		bsr.w	sub_14D48
		cmpi.w	#6,d1
		blt.w	locret_1348E
		move.w	#$680,d2
		btst	#6,obStatus(a0)
		beq.s	loc_1341C
		move.w	#$380,d2

loc_1341C:
		moveq	#0,d0
		move.b	obAngle(a0),d0
		subi.b	#$40,d0
		jsr	(CalcSine).l
		muls.w	d2,d1
		asr.l	#8,d1
		add.w	d1,obVelX(a0)	; make Sonic jump
		muls.w	d2,d0
		asr.l	#8,d0
		add.w	d0,obVelY(a0)	; make Sonic jump
		bset	#1,obStatus(a0)
		bclr	#5,obStatus(a0)
		bclr	#3,obStatus(a0) ; prevent broken collision if you jump while standing on a monitor
		addq.l	#4,sp
		move.b	#1,$3C(a0)
		clr.b	$38(a0)
		move.w	#sfx_Jump,d0
		jsr	(PlaySound_Special).l	; play jumping sound
		;move.b	#$F,obHeight(a0)	; standing height
		;move.b	#9,obWidth(a0)	; standing width
		;btst	#2,obStatus(a0) ; is player jumping/is status #2?
		;bne.s	loc_13490 ; if not, branch
		move.b	#$E,obHeight(a0) ; ball height
		move.b	#7,obWidth(a0) ; ball width
		move.b	#id_HammerAttack,obAnim(a0) ; use hammer attack animation
		move.b	#1,(f_hammerobject).w ; set flag for using the hammer
        clr.b	(f_hammerrush).w ; clear hammer rush flag (failsafe)
		bset	#2,obStatus(a0)
		addq.w	#1,obY(a0)

locret_1348E:
		rts	
; ===========================================================================

;loc_13490:
		;bset	#4,obStatus(a0) ; set to bit 4 (jumping after rolling)
		;move.b	#id_HammerAttack,obAnim(a0) ; use hammer when jumping after rolling
		;rts	

; End of function Sonic_Jump