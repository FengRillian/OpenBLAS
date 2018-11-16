/*********************************************************************/
/* Copyright 2009, 2010 The University of Texas at Austin.           */
/* All rights reserved.                                              */
/*                                                                   */
/* Redistribution and use in source and binary forms, with or        */
/* without modification, are permitted provided that the following   */
/* conditions are met:                                               */
/*                                                                   */
/*   1. Redistributions of source code must retain the above         */
/*      copyright notice, this list of conditions and the following  */
/*      disclaimer.                                                  */
/*                                                                   */
/*   2. Redistributions in binary form must reproduce the above      */
/*      copyright notice, this list of conditions and the following  */
/*      disclaimer in the documentation and/or other materials       */
/*      provided with the distribution.                              */
/*                                                                   */
/*    THIS  SOFTWARE IS PROVIDED  BY THE  UNIVERSITY OF  TEXAS AT    */
/*    AUSTIN  ``AS IS''  AND ANY  EXPRESS OR  IMPLIED WARRANTIES,    */
/*    INCLUDING, BUT  NOT LIMITED  TO, THE IMPLIED  WARRANTIES OF    */
/*    MERCHANTABILITY  AND FITNESS FOR  A PARTICULAR  PURPOSE ARE    */
/*    DISCLAIMED.  IN  NO EVENT SHALL THE UNIVERSITY  OF TEXAS AT    */
/*    AUSTIN OR CONTRIBUTORS BE  LIABLE FOR ANY DIRECT, INDIRECT,    */
/*    INCIDENTAL,  SPECIAL, EXEMPLARY,  OR  CONSEQUENTIAL DAMAGES    */
/*    (INCLUDING, BUT  NOT LIMITED TO,  PROCUREMENT OF SUBSTITUTE    */
/*    GOODS  OR  SERVICES; LOSS  OF  USE,  DATA,  OR PROFITS;  OR    */
/*    BUSINESS INTERRUPTION) HOWEVER CAUSED  AND ON ANY THEORY OF    */
/*    LIABILITY, WHETHER  IN CONTRACT, STRICT  LIABILITY, OR TORT    */
/*    (INCLUDING NEGLIGENCE OR OTHERWISE)  ARISING IN ANY WAY OUT    */
/*    OF  THE  USE OF  THIS  SOFTWARE,  EVEN  IF ADVISED  OF  THE    */
/*    POSSIBILITY OF SUCH DAMAGE.                                    */
/*                                                                   */
/* The views and conclusions contained in the software and           */
/* documentation are those of the authors and should not be          */
/* interpreted as representing official policies, either expressed   */
/* or implied, of The University of Texas at Austin.                 */
/*********************************************************************/

#define ASSEMBLER
#include "common.h"

#define N	$4
#define	X	$5
#define INCX	$6
#define Y	$7
#define INCY	$8

#define XX	$9
#define YY	$10

#define C	$f17
#define S	$f18

#define I	$2
#define TEMP	$3

#define a1	$f4
#define a2	$f5
#define a3	$f6
#define a4	$f7

#define b1	$f8
#define b2	$f9
#define b3	$f10
#define b4	$f11

#define t1	$f0
#define t2	$f1
#define t3	$f2
#define t4	$f3

	PROLOGUE

	dsll	INCX, INCX, BASE_SHIFT
	li	TEMP, SIZE

	blez	N, .L999
	dsll	INCY, INCY, BASE_SHIFT

	bne	INCX, TEMP, .L26
	move	I, N

	bne	INCY, TEMP, .L26
	NOP

.L16:
	LD	a1,  0 * SIZE(X)
	LD	b1,  0 * SIZE(Y)

	MUL	t1, S, b1
	MUL	t2, C, b1

	MADD	t1, t1, C, a1
	NMSUB	t2, t2, S, a1

	ST	t1,  0 * SIZE(X)
	ST	t2,  0 * SIZE(Y)

	daddiu I, I, -1

	daddiu	X, X, SIZE
	daddiu	Y, Y, SIZE

	bgtz	I, .L16
	NOP
	j	.L999
	NOP
	.align 3

.L26:
	LD	a1,  0 * SIZE(X)
	LD	b1,  0 * SIZE(Y)

	MUL	t1, S, b1
	MUL	t2, C, b1

	MADD	t1, t1, C, a1
	daddiu	I, I, -1
	NMSUB	t2, t2, S, a1

	ST	t1,  0 * SIZE(X)
	ST	t2,  0 * SIZE(Y)

	dadd	X, X, INCX
	bgtz	I, .L26
	dadd	Y, Y, INCY
	.align 3

.L999:
	j	$31
	NOP

	EPILOGUE
