  .syntax unified
  .cpu cortex-m3
  .fpu softvfp
  .thumb

  .global MY_TIM1_UP_IRQHandler
	/*
	Exception frame saved by the NVIC hardware onto stack:
	+------+
	|      | <- SP before interrupt (orig. SP)
	| xPSR |
	|  PC  |
	|  LR  |
	|  R12 |
	|  R3  |
	|  R2  |
	|  R1  |
	|  R0  | <- SP after entering interrupt (orig. SP + 32 bytes)
	+------+

	Registers saved by the software (MY_Timer_Handler):
	+------+
	|  R4  |
	|  R5  |
	|  R6  |
	|  R7  |
	|  R8  |
	|  R9  |
	| R10  |
	| R11  | <- Saved SP (orig. SP + 64 bytes)
	+------+
	*/
  .type MY_TIM1_UP_IRQHandler, %function
  MY_TIM1_UP_IRQHandler:
  // Your task switching code will be started here
  push {R4-R11}			// push R11 --> R4 into stack memory
  ldr  R0, =currTcb
  ldr	R0, [R0]		  // load the address value of curTcb in R0
  str	SP, [R0, #12]
  str	LR, [R0, #24]
  ldr	R0, [R0]		  //thread1 (next)
  ldr	R1, =currTcb
  str 	R0, [R1]
  ldr	SP, [R0, #12]
  ldr	LR, [R0, #24]
  pop	{R4-R11}	    // pop R11 --> R4 from stack memory

  // Your task switching code ends here
  b		TIM1_UP_IRQHandler		// Leave it there

