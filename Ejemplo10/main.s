GPIO_PORTB_BASE EQU 0X40005000

		IMPORT   SysTick_Init
    IMPORT   SysTick_Wait
    IMPORT   SysTick_Wait10ms
    IMPORT   PLL_Init
		IMPORT 	 Int_PF
		

    AREA    |.text|, CODE, READONLY, ALIGN=2
    THUMB
    EXPORT  Start

Start                
	  BL	Int_PF
	  BL  PLL_Init                    ; set system clock to 80 MHz
    BL  SysTick_Init 
	
	  LDR R1, =GPIO_PORTB_BASE
	  MOV R0 , #0X80
	  STR R0, [R1,#0X80] ; ESCRIBIR AL PIN 5


LOOP
	  B LOOP	

;R0 = COMANDO
;R1 = BIT RS (DEFINE SI ES COMANDO O ESCRITURA DE CARACTERES)
  LDC_SEND_COMAND
    PUSH{R4,LR}
    LDR R4, =GPIO_PORTB_BASE
;-----ESCRIBIR AL PIN RS---------	
    LSL R1, #4
    STR R1, [R4, #0X40]; ESCRIBIR AL PIN4 (0-7)
;-----ESCRIBIR BITS MAS SIGNIFICATIVOS DEL COMANDO--	
    MOV R2, R0
    MOV R3, R0
    AND R2, #0XF0
    LSR R2, #4
    STR R2, [R4,#0X3C]; ESCRIBIR A PINES 0-3
;----------FALLING EDGE	ENABLE --------
    MOV R2, #0
    STR R2, [R4, #0X80]; BAJAR EL PIN DE ENABLE
    MOV R0, #1
    BL  SysTick_Wait10ms
    MOV R2, #0X80 
    STR R2, [R4, #0X80]; SUBE EL PIN DE ENABLE
;---ESCRIBIR PARTE MENOS SIGNIFICATIVA COMANDO---
    AND R3,#0X0F
    STR R3, [R4,#0X3C]; ESCRIBIR A PINES 0-3
;----------FALLING EDGE	ENABLE --------
    MOV R2, #0
    STR R2, [R4, #0X80]; BAJAR EL PIN DE ENABLE
    MOV R0, #1
    BL  SysTick_Wait10ms ; delay 5ms
    MOV R2, #0X80 
    STR R2, [R4, #0X80]; SUBE EL PIN DE ENABL	
    POP {R4,LR}


    ALIGN                           ; make sure the end of this section is aligned
    END                             ; end of file
