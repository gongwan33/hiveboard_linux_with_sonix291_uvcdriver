/*
 * linux/arch/unicore/lib/io-readsl.S
 *
 * Code specific to PKUnity SoC and UniCore ISA
 * Fragments that appear the same as the files in arm or x86
 *
 * Copyright (C) 2001-2008 GUAN Xue-tao
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 2 as
 * published by the Free Software Foundation.
 */
#include <linux/linkage.h>
#include <asm/assembler.h>

ENTRY(__raw_readsl)
		cmpxor.a	r2, #0	@ do we have to check for the zero len?
		cmoveq	pc, lr
		and.a	ip, r1, #3
		bne	3f

		sub.a	r2, r2, #4
		bfs	2f
1:		ldw	r3, [r0+], #0
		ldw	r4, [r0+], #0
		ldw	r14, [r0+], #0
		ldw	r15, [r0+], #0
		sub.a	r2, r2, #4
		stm.w	(r3, r4, r14, r15), [r1]+
		bns	1b
2:		mov.a	r2, r2 << #31
		bub	201f
		ldw	r3, [r0+], #0
		ldw	r14, [r0+], #0
		stm.w	(r3, r14), [r1]+
201:		beq	202f
		ldw	r3, [r0+], #0
		stw	r3, [r1+], #0
202:
		mov	pc, lr

3:		ldw	r3, [r0]
		cmpsub.a	ip, #2
		mov	ip, r3 get_byte_0
		stb.w	ip, [r1]+, #1
		bsg	6f
		mov	ip, r3 get_byte_1
		stb.w	ip, [r1]+, #1
		beq	5f
		mov	ip, r3 get_byte_2
		stb.w	ip, [r1]+, #1

4:		sub.a	r2, r2, #1
		mov	ip, r3 pull #24
		beq	8f
		ldw	r3, [r0]
		or	ip, ip, r3 push #8
		stw.w	ip, [r1]+, #4
		b	4b

5:		sub.a	r2, r2, #1
		mov	ip, r3 pull #16
		beq	7f
		ldw	r3, [r0]
		or	ip, ip, r3 push #16
		stw.w	ip, [r1]+, #4
		b	5b

6:		sub.a	r2, r2, #1
		mov	ip, r3 pull #8
		beq	201f
		ldw	r3, [r0]
		or	ip, ip, r3 push #24
		stw.w	ip, [r1]+, #4
		b	6b
201:
		mov	r3, ip get_byte_2
		stb	r3, [r1+], #2
7:		mov	r3, ip get_byte_1
		stb	r3, [r1+], #1
8:		mov	r3, ip get_byte_0
		stb	r3, [r1+], #0
		mov	pc, lr
ENDPROC(__raw_readsl)
