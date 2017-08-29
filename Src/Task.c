#include <stdlib.h>
#include "Task.h"

TCB *createThread(char *name, void (*task)(void), uint32_t size){
	if(size < 128){
		size  = 128;
	}

	TCB *tcb = (TCB *)malloc(sizeof(TCB));
	tcb->name = name;
	tcb->task = task;
	tcb->stackSize = size;
	tcb->stackBegin = (uint8_t *)malloc(size);
	tcb->execReturnCode = 0xfffffff9;
	tcb->stackPointer = (uint8_t *)(tcb->stackBegin + size);
	tcb->stackPointer -= 68;
	*(uint32_t *)&tcb->stackPointer[0] = 0x44444444;		//r4
	*(uint32_t *)&tcb->stackPointer[4] = 0x55555555;
	*(uint32_t *)&tcb->stackPointer[8] = 0x66666666;
	*(uint32_t *)&tcb->stackPointer[12] = 0x77777777;
	*(uint32_t *)&tcb->stackPointer[16] = 0x88888888;
	*(uint32_t *)&tcb->stackPointer[20] = 0x99999999;
	*(uint32_t *)&tcb->stackPointer[24] = 0xaaaaaaaa;
	*(uint32_t *)&tcb->stackPointer[28] = 0xbbbbbbbb;	//r11
	*(uint32_t *)&tcb->stackPointer[32] = 0x00000111;	//r0
	*(uint32_t *)&tcb->stackPointer[36] = 0x11111111;
	*(uint32_t *)&tcb->stackPointer[40] = 0x22222222;	//r2
	*(uint32_t *)&tcb->stackPointer[44] = 0x33333333;	//r3
	*(uint32_t *)&tcb->stackPointer[48] = 0x12121212;	//r12
	*(uint32_t *)&tcb->stackPointer[52] = 0xeeeeeeee;	//lr
	*(uint32_t *)&tcb->stackPointer[56] = (uint32_t)task;	//pc
	*(uint32_t *)&tcb->stackPointer[60] = 0x21000000;  //xpsr
	//tcb->next = (void (*)(void))task;
	return tcb;
}

TCB *initKernel(char *mainThreadName){
	TCB *tcb = (TCB *)malloc(sizeof(TCB));
	tcb->name = mainThreadName;
	tcb->stackBegin = NULL;
	tcb->stackSize = 0;
	return tcb;
}
