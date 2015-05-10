/*
 * File:	crt0.s
 * Purpose:	Lowest level routines for Kinetis.
 *
 * Notes:	
 *
 */


//         AREA   Crt0, CODE, READONLY      ; name this block of code
  .section .text

  .globl  _start
_start: 
  //LDR     r0,=0                   // Initialize the GPRs
	//LDR     r1,=0
	//LDR     r2,=0
	//LDR     r3,=0
	//LDR     r4,=0
	//LDR     r5,=0
	//LDR     r6,=0
	//LDR     r7,=0

	//CPSIE   i                       // Unmask interrupts
  BL      main                   //   call the C code
  BX      lr

