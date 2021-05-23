; Build params: ------------------------------------------------------------------------------
CHEAT set 0
; Constants: ---------------------------------------------------------------------------------
	MD_PLUS_OVERLAY_PORT:			equ $0003F7FA
	MD_PLUS_CMD_PORT:				equ $0003F7FE
	MD_PLUS_RESPONSE_PORT:			equ $0003F7FC

	PAUSE_RESUME_FUNCTION:			equ	$C5C
	PLAY_MUSIC_FUNCTION:			equ	$00065C56
	FADE_OUT_MUSIC_FUNCTION:		equ	$000660DE
	STOP_MUSIC_FUNCTION:			equ $0006621C

	RAM_SND_DRIVER_PAUSE_STATE:		equ	$FFFFF807

; Overrides: ---------------------------------------------------------------------------------
	org PAUSE_RESUME_FUNCTION+$14
	jmp		PAUSE_DETOUR

	org PAUSE_RESUME_FUNCTION+$24
	jmp		RESUME_DETOUR


	org PLAY_MUSIC_FUNCTION
	move.w	D7,D1
	subi.b	#$80,D1
	ori.w	#$1200,D1
	jsr		WRITE_MD_PLUS_FUNCTION
	rts

	org FADE_OUT_MUSIC_FUNCTION
	move.w	#$13BA,D1
	jsr		WRITE_MD_PLUS_FUNCTION
	rts

	org STOP_MUSIC_FUNCTION
	move.w	#$1300,D1
	jsr		WRITE_MD_PLUS_FUNCTION
	rts

; Detours: -----------------------------------------------------------------------------------
	org $7FB50

PAUSE_DETOUR
	move.b	#$1,(RAM_SND_DRIVER_PAUSE_STATE)
	move.w	#$1300,D1
	jsr		WRITE_MD_PLUS_FUNCTION
	rts

RESUME_DETOUR
	move.b	#$80,(RAM_SND_DRIVER_PAUSE_STATE)
	move.w	#$1400,D1
	jsr		WRITE_MD_PLUS_FUNCTION
	rts

; Helper Functions: --------------------------------------------------------------------------

WRITE_MD_PLUS_FUNCTION:
	move.w  #$CD54,(MD_PLUS_OVERLAY_PORT)	; Open interface
	move.w  D1,(MD_PLUS_CMD_PORT)			; Send command to interface
	move.w  #$0000,(MD_PLUS_OVERLAY_PORT)	; Close interface
	rts