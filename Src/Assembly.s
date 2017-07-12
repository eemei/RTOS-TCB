  .syntax unified
  .cpu cortex-m3
  .fpu softvfp
  .thumb

  .global add2Integers
  .global add4Integers
  .global add5Integers
  .global add6Integers
  .global assemblyMain
  .global MY_TIM1_UP_IRQHandler

  .section .text
  .type add2Integers, %function
add2Integers:
  add	R0, R1
  bx	LR

  .type add4Integers, %function
add4Integers:
  add	R0, R1
  add	R2, R3
  add	R0, R2
  bx	LR

  .type add5Integers, %function
add5Integers:
  add	R0, R1
  add	R2, R3
  add	R0, R2
  ldr	R1, [sp]
  add R0, R1
  bx	LR

   .type add6Integers, %function
add6Integers:
  add	R0, R1
  add	R2, R3
  add	R0, R2
  ldr	R1, [sp]
  ldr	R2, [sp, #4]
  add R1, R2
  add R0, R1
  bx	LR

  .type assemblyMain, %function
assemblyMain:
  push 	{LR}

  // Try to subtract 30-26
  mov	R0, #30
  mov	R1, #26
  bl	sub2Integers
  // View R0 (R0 should be 4)
/*
  // Try to subtract 178 - 56 - 23 - 6 - 3
  mov	R0, #3
  push	{R0}
  mov	R0, #178
  mov	R1, #56
  mov	R2, #23
  mov	R3, #6
  bl	sub5Integers
  pop	{R3}
  // View R0 (R0 should be 90)

  // Try to subtract 178 - 56 - 23 - 6 - 3 - 14
  mov	R0, #3
  mov	R1, #14
  push	{R0, R1}
  mov	R0, #178
  mov	R1, #56
  mov	R2, #23
  mov	R3, #6
  bl	sub6Integers
  ldr	R1, =mySignal
  str	R0, [R1]
  pop	{R1, R2}
  // View R0 (R0 should be 76)

  push	{R0-R3, R12}
  ldr	R0, =0x11111111
  ldr	R1, =0x22222222
  ldr	R2, =0x33333333
  ldr	R3, =0x44444444
  ldr	R12, =0xcccccccc
  ldr	LR, =0xeeeeeeee
here:
  mov	R0, R0
//  b		here
  pop	{R0-R3, R12}

  ldr	R0, =0x12345678
*/

  pop	{LR}
  bx	LR



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
/*
/*  ldr	R0, =currTcb 	// Get the memory address value of currTcb
  ldr	R1, =0x0badface
  ldr	R0, [R0]		// load the address value of curTcb in R0
  str	R1, [R0, #20]	// store 0x0badface to memory location [R0(address value of currTcb) + offset(20)] -> StackSize*/



  push {R4-R11}			// push R11 --> R4 into stack memory
  ldr  R0, =currTcb
  ldr	R0, [R0]		// load the address value of curTcb in R0
  ldr	R0, [R0]		//thread1 (next)
  ldr	SP, [R0, #12]	// stackpOINTER
  						// (SP) register is used to indicate the location of the last item put item put onto the stack.
 // str	LR, [R0, #24]	// store LR(Link Register) in execReturnCode
  						// used to hold the return address for a function call.
  pop	{R4-R11}	// pop R11 --> R4 from stack memory
  // Your task switching code ends here
  b		TIM1_UP_IRQHandler		// Leave it there

