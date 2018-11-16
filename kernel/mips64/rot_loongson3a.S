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
	LD	b1,  0 * SIZE(Y)
	MUL	t2, C, b1
	LD	a1,  0 * SIZE(X)
	MUL	t1, S, b1
	daddiu I, I, -1

	MADD	t1, t1, C, a1
	ST	t1,  0 * SIZE(X)
	NMSUB	t2, t2, S, a1
	ST	t2,  0 * SIZE(Y)

	daddiu	Y, Y, SIZE
	bgtz	I, .L16
	daddiu	X, X, SIZE
	j	.L999
	NOP
	.align 3

.L26:
	LD	b1,  0 * SIZE(Y)
	MUL	t1, S, b1
	LD	a1,  0 * SIZE(X)
	MUL	t2, C, b1
	daddiu	I, I, -1

	MADD	t1, t1, C, a1
	ST	t1,  0 * SIZE(X)
	NMSUB	t2, t2, S, a1
	ST	t2,  0 * SIZE(Y)

	dadd	Y, Y, INCY
	bgtz	I, .L26
	dadd	X, X, INCX
	.align 3

.L999:
	j	$31
	NOP

	EPILOGUE
