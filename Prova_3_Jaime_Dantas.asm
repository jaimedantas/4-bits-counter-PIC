;-----------------------------------------------------------------------------------;
;	Contador de 4 bits usando 4 leds no porto B com intervado de 0.5s na contagem	;
;	Autor: Jaime Cristalino Jales Dantas - UFRN - Engenharia de Computacao			;
;	Disciplina: Arquitetura de Computadores											;
;	Data: 9 dezembro de 2015														;
;	Descricao do programa: Esse programa faz a contagem de 0 ate 9 usando 4 leds 	;
;							no porto B com intervado de 0.5s na contagem.			;
;	CLOCK: 1 kHz																	;
;	MCU: PIC16F84A																	;
;	Copilado usando o MATLAB v8.92													;
;-----------------------------------------------------------------------------------;

 list p = pic16f84a							; microcontrolador ultilizado PIC16F84A

; --- Arquivos incluidos no projeto ---
 #include <p16f84a.inc>						; inclui o aquivo do PIC16F84A

 			TMR0 		EQU 	1 			; timer
 			STATUS		EQU 	3 			; registrador de status
 			PORTA		EQU 	5 			; Porto A
 			PORTB		EQU		6 			; Porto B
 			TRISA		EQU		85H 		; registrador de entrada A
 			TRISB		EQU		86H			; registrador de saida B
			OPTION_R	EQU 	81H 		; usado na divisao do clock pelo contador
 			ZEROBIT 	EQU 	2
			COUNT 		EQU 	0CH 		; contador

; -- FUSE Bits --
; Ultilizaremos um cristal externo de 1 kHz, sem watchdog timer, com power up timer, sem protecao do codigo
 __config _XT_OSC & _WDT_OFF & _PWRTE_ON & _CP_OFF

; --- Paginacao de Memoria ---
 #define	bank0		bcf STATUS, RP0		; cria um mnemonico para o banco 0 de memoria
 #define	bank1		bsf STATUS, RP0		; cria um mnemonico para o banco 1 de memoria
 #define	ligaLED1	bsf PORTB,0			; liga porta B0
 #define	desligaLED1	bcf	PORTB,0			; desliga porta B0
 #define	ligaLED2	bsf PORTB,1			; liga porta B1
 #define	desligaLED2	bcf	PORTB,1			; desliga porta B1
 #define	ligaLED3	bsf PORTB,2			; liga porta B2
 #define	desligaLED3	bcf	PORTB,2			; desliga porta B2
 #define	ligaLED4	bsf PORTB,3			; liga porta B3
 #define	desligaLED4	bcf	PORTB,3			; desliga porta B3

; --- Vetor de RESET ---
 			org			H'0000'				;Origem no endereço 0000h de memória
			goto		inicio				;Desvia do vetor de interrupção

; --- Vetor de Interrupcao ---				; as interrupcoes estao desabilitadas
 			org			H'0004'				; todas as interrupções apontam para este endereço
			retfie							; retorna de interrupcao

;--- Programa Principal ---
inicio:
			bank1							;seleciona o banco 1 de memoria
			movlw   	H'00' 				;W = 0000 0000
    		movwf   	TRISA				;TRISA = H'00' (todos os bits sao entrada)

   			movlw   	H'00'				;W = 0000 0000
    		movwf   	TRISB				;TRISB = H'00' (todos os bits sao saida)

    		movlw   	H'06'				;W = 0000 0110
    		;-Calculo do timer-
    		;se setarmos OPTION_R -> 128 ficaremos com 1024/4 = 256 e sabemos que 256/128 = 2, ou seja, quando o timer
			;tiver valor igual a 1 se terá se passado 0.5 segundo
    		movwf   	OPTION_R
    		bank0
    		clrf    	PORTA				; reseta as portas do porto A
    		clrf    	PORTB				; reseta as portas do porto B
    		goto		programa			; vai para a execucao do loop do programa


;--- Laco que sera executado infinitamente em nosso programa ---
programa:
				LOOPA
				;--Numero 0 - binario -> 0000
				clrf    PORTB				;reseta as portas B
				call    delay05 			;delay de 0.5s
    			;--Numero 1 - binario -> 0001
    			ligaLED1					;liga o led 1
    			call    delay05				;delay de 0.5s
    			;--Numero 2 -  binario -> 0010
    			desligaLED1					;desliga o led 1
    			ligaLED2					;liga o led 2
    			call    delay05				;delay de 0.5s
    			;--Numero 3 -  binario -> 0011
    			ligaLED1					;liga o led 2
    			call    delay05				;delay de 0.5s
   	 			;--Numero 4 -  binario -> 0100
    			desligaLED1					;desliga o led 1
    			desligaLED2					;desliga o led 2
    			ligaLED3					;liga o led 3
    			call    delay05				;delay de 0.5s
    			;--Numero 5 -  binario -> 0101
    			ligaLED1					;liga o led 1
    			call    delay05				;delay de 0.5s
    			;--Numero 6 -  binario -> 0110
    			desligaLED1					;desliga o led 1
    			ligaLED2					;liga o led 2
    			call    delay05				;delay de 0.5s
    			;--Numero 7 -  binario -> 0111
    			ligaLED1					;liga o led 1
    			call    delay05				;delay de 0.5s
    			;--Numero 8 -  binario -> 1000
  				desligaLED1					;desliga o led 1
    			desligaLED2					;desliga o led 2
   				desligaLED3					;desliga o led 3
    			ligaLED4					;liga o led 4
    			call    delay05 			;delay de 0.5s
    			;--Numero 9 -  binario -> 1001
    			ligaLED1					;liga o led 1
    			call    delay05				;delay de 0.5s
				goto	LOOPA				;volta para o loop inicial


; --- Esse eh a funcao de delay 0.5 calculada
delay05:
    			clrf    TMR0    			; reseta o timer
    			LOOPB   movf    TMR0,W  	; move o valor contido no timer para o registrador de trabalho W
	    			sublw   .1	    		; timer - 1
	    			btfss   STATUS,ZEROBIT 	; verifica se  timer - 1 eh zero
	    			goto    LOOPB   		; volta pra o loop
	    			retlw   0	    		; retorma para programa

end											;fim do programa
