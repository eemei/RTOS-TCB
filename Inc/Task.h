#ifndef	TASK_H
#define	TASK_H

#include <stdint.h>

typedef struct TCB TCB;
struct TCB{
	TCB	*next;
	char *name;
	void (*task)(void);
	uint8_t *stackPointer;
	uint8_t *stackBegin;
	uint32_t stackSize;
	uint32_t execReturnCode;	// LR on interrupt
};

#endif	// TASK_H
