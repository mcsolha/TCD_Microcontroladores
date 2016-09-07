;Nome:  Matheus Coelho Solha
;RA:    141027134
;Email: mcsolha@gmail.com
;Descri��o:

#include <P16F873A.INC>
		CBLOCK	0X20	 	 ;DECLARA��O DAS VARIAVEIS QUE SER�O UTILIZADAS NO C�DIGO
		TIQUES				 ;TIQUES: RESPONS�VEL PELO N�MERO DE INTERRUP��ES POR SEGUNDO
		NUMTIQUES			 ;NUMTIQUES: QUANTIDADE DE VEZES QUE TER� QUE CONTAR UM SEGUNDO
		TIPO				 ;TIPO: VARIAVEL PARA CONTROLAR SE � PARA LIGAR BUZZ OU DEIXAR LED LIGADO 1:BUZZ 2:LED
		ENDC
		ORG		0
		GOTO	INICIO
		ORG		4
		DECFSZ 	TIQUES,1 	 ;DECREMENTA O TIQUES
		GOTO 	VOLTA 		 ;SE N�O FOR 0, SAI DA INTERRUP��O PARA QUE TIQUES SEJA DECREMENTADO NOVAMENTE
		DECFSZ	NUMTIQUES,1	 ;SE FOR 0, DECREMENTA NUMTIQUES
		GOTO	RTIQUES		 ;VAI PARA RTIQUES PARA CONTINUAR A CONTAGEM
		DECFSZ	TIPO		 ;DECREMENTA UM DO TIPO PARA VER SE � BUZZ OU TERMINO DE PRESEN�A
		GOTO	RTIQUES		 ;
LIGABUZ	BSF		PORTB,RB5	 ;LIGA BUZZ
RTIQUES MOVLW 	D'250' 		 ;COLOCA EM W O VALOR 250
		MOVWF 	TIQUES 		 ;ATRIBUI W EM TIQUES
VOLTA	MOVLW 	D'131' 		 ;MOVE PARA W O VALOR 131
		MOVWF 	TMR0 		 ;RESETA O VALOR DE TMR0 PARA 131 PARA MANTER O TEMPO DESEJADO
		BCF 	INTCON,T0IF  ;DA CLEAR NO BIT QUE INDICA INTERRUP��O
		RETFIE
INICIO
							 ;CONFIG TRISB
		BANKSEL TRISB		 ;SELECIONA O BANCO AONDE SE ENCONTRA O REGISTRADOR TRISB E CONFIGURA OS BITS DA SEGUINTE FORMA: RB7 COMO INPUT E RESTO COMO OUTPUT
		MOVLW	b'10000000'
		MOVWF	TRISB		 ;MOVE O BYTE PARA O TRISB
RESTART						 ;PROGRAMA BASE
		BANKSEL	PORTB		 ;SELECIONA O BANCO DE MEM�RIA AONDE SE ENCONTRA O REGISTRADOR PORTB
		BCF		PORTB,RB6	 ;DA CLEAR NO RB6 PARA QUE O LED FIQUE APAGADO
		BCF		PORTB,RB5	 ;DA CLEAR NO RB5 PARA QUE O BUZZER FIQUE DESLIGADO
		MOVLW	D'1'		 ;DEFINE O TIPO COMO SENDO BUZZ
		MOVWF	TIPO
		;espera por presen?a
PROCUR	BTFSC	PORTB,RB7	 ;TESTA O BIT RB7 DO REGISTRADOR PORTB
		GOTO	PROCUR		 ;SE O RB7 ESTIVER EM ALTO(SEM PRESEN�A), VOLTA PARA TESTAR O RB7
		;ap�s achar presen�a
		BSF		PORTB,RB6	 ;SE O RB7 ESTIVER EM BAIXO(COM PRESEN�A), IRA LIGAR O LED DA SAIDA RB6
		;ativa��o do timer para contar 10 segundos
		BANKSEL OPTION_REG	 ;SELECIONA O BANCO AONDE SE ENCONTRA O REGISTRADOR OPTION_REG
		MOVLW	B'00000100'	 ;MOVE 32 PRO PRESCALER
		MOVWF	OPTION_REG	 ;MOVE O BYTE PARA O OPTION_REG
		BANKSEL TMR0		 ;SELECIONA O BANCO AONDE SE ENCONTRA O REGISTRADOR TMR0
		MOVLW 	D'131' 		 ;COLOCA EM W O VALOR 131
		MOVWF 	TMR0 		 ;COLOCA NO TMR0 O VALOR DE W
		MOVLW 	D'250' 		 ;QUANTIDADE DE INTERRUP��ES POR 1 SEGUNDO
		MOVWF 	TIQUES 		 ;ATRIBUI O VALOR ANTERIOR PARA O TIQUES
		MOVLW	D'10'		 ;MOVE PARA W O N�MERO 10
		MOVWF	NUMTIQUES	 ;MOVE PARA NUMTIQUES O NUMERO 10
		BSF 	INTCON,GIE 	 ;ATIVE O CONTROLE INDIVIDUAL DE INTERRUP��ES
		BSF 	INTCON,T0IE  ;ATIVA INTERRUP��O DO TIMER
		BCF 	INTCON,T0IF	 ;CLEAR NO BIT PARA INDICAR QUE N�O OCORREU INTERRUP��O
		;espera falta de presen�a
		BANKSEL	PORTB		 ;SELECIONA O BANCO AONDE SE ENCONTRA O REGISTRADOR PORTB
PROC2	BTFSS	PORTB,RB7	 ;TESTA O BIT RB7 NO REGISTRADOR PORTB
		GOTO	PROC2		 ;SE O RB7 ESTIVER EM BAIXO(COM PRESEN�A), VOLTA PARA TESTAR O RB7
		BCF		PORTB,RB5	 ;DESLIGA BUZZ DEPOIS QUE PERDER PRESEN�A
		BCF 	INTCON,GIE 	 ;DESATIVA O CONTROLE INDIVIDUAL DE INTERRUP��ES
		BCF		INTCON,T0IE	 ;CLEAR NO BIT PARA INDICAR QUE N�O OCORREU INTERRUP��O
		;reconfigura timer
		MOVLW	D'2'
		MOVWF	TIPO
		BANKSEL OPTION_REG	 ;SELECIONA O BANCO AONDE SE ENCONTRA O REGISTRADOR OPTION_REG
		MOVLW	B'00000100'	 ;MOVE 32 PRO PRESCALER
		MOVWF	OPTION_REG	 ;MOVE O BYTE PARA O OPTION_REG
		BANKSEL TMR0		 ;SELECIONA O BANCO AONDE SE ENCONTRA O REGISTRADOR TMR0
		MOVLW 	D'131' 		 ;COLOCA EM W O VALOR 131
		MOVWF 	TMR0 		 ;COLOCA NO TMR0 O VALOR DE W
		MOVLW 	D'250' 		 ;QUANTIDADE DE INTERRUP��ES POR 1 SEGUNDO
		MOVWF 	TIQUES 		 ;ATRIBUI O VALOR ANTERIOR PARA O TIQUES
		MOVLW	D'2'		 ;MOVE PARA W O N�MERO 2
		MOVWF	NUMTIQUES	 ;MOVE PARA NUMTIQUES O NUMERO 10
		BSF 	INTCON,GIE 	 ;ATIVE O CONTROLE INDIVIDUAL DE INTERRUP��ES
		BSF 	INTCON,T0IE  ;ATIVA INTERRUP��O DO TIMER
		BCF 	INTCON,T0IF	 ;CLEAR NO BIT PARA INDICAR QUE N?O OCORREU INTERRUP��O
		;espera acabar o tempo
		BANKSEL	STATUS		 ;SELECIONA O BANCO DO REGISTRADOR STATUS
		BCF		STATUS,Z		 ;CLEAR NO BIT Z PARA FAZER TESTE SE ACABOU 2 SEGUNDOS
DAZERO	MOVF	NUMTIQUES,W 	;MOVE PARA W O CONTEUDO DE NUMTIQUES
		SUBLW	D'0'			 	 ;VERIFICA SE O CONTEUDO DE W É ZERO
		BTFSS	STATUS,Z
		GOTO	DAZERO			 ;SE NÃO FOR ZERO TESTA NOVAMENTE
		;acabou o tempo
		BANKSEL	INTCON		 ;SELECIONAR O BANCO AONDE SE ENCONTRA O REGISTRADOR INTCON
		BCF 	INTCON,GIE 	 ;DESATIVA O CONTROLE INDIVIDUAL DE INTERRUP��ES
		BCF		INTCON,T0IE	 ;CLEAR NO BIT PARA INDICAR QUE N�O OCORREU INTERRUP��O
SAIDA	GOTO	RESTART 	 ;reinicia processo
		END
