;Nome:  Matheus Coelho Solha
;RA:    141027134
;Email: mcsolha@gmail.com
;Descri��o:

#include <P16F873A.INC>
		CBLOCK	0X20
		TIQUES
		NUMTIQUES
		SACO
		ENDC
		ORG		0
		GOTO	INICIO
		ORG		4
		RETFIE
INICIO
		MOVLW	d'10'
		MOVWF	SACO
		MOVLW	d'250'
		MOVWF	NUMTIQUES
		MOVLW	d'250'
		MOVWF	TIQUES
		BANKSEL TRISB
		MOVLW	b'10000000'
		MOVWF	TRISB
		BANKSEL	PORTB
		BSF		PORTB,RB7
RESTART	BCF		PORTB,RB6
PROCUR	BTFSC	PORTB,RB7
		GOTO	PROCUR
		BSF		PORTB,RB6
PROC2	BTFSS	PORTB,RB7
		GOTO	PROC2
		GOTO	RESTART
		END
