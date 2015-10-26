/*
 * Copyright (c) 2015 Masao Uebayashi <uebayasi@tombiinc.com>
 *
 * Permission to use, copy, modify, and distribute this software for any
 * purpose with or without fee is hereby granted, provided that the above
 * copyright notice and this permission notice appear in all copies.
 *
 * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
 * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
 * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
 * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
 * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
 * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 */

%{

static char bytes[6];
static int nbytes;
static int total;

#define	one() do { \
	bytes[nbytes++] = yytext[0]; \
	if (nbytes == total) { \
		return nbytes; \
	} else { \
		BEGIN(MORE); \
	} \
} while (0)
#define	more(t) do { \
	total = (t); \
	one(); \
} while (0)
#define	error() do { \
	return -1; \
} while (0)

%}

%s	MORE

b0xxxxxxx		[\x00-\x7f]
bx0xxxxxx		[\x80-\xbf]
bxx0xxxxx		[\xc2-\xdf]
bxxx0xxxx		[\xe0-\xef]
bxxxx0xxx		[\xf0-\xf7]
bxxxxx0xx		[\xf8-\xfb]
bxxxxxx0x		[\xfc-\xfd]

%%

{b0xxxxxxx}		{ more(1); }
{bxx0xxxxx}		{ more(2); }
{bxxx0xxxx}		{ more(3); }
{bxxxx0xxx}		{ more(4); }
{bxxxxx0xx}		{ more(5); }
{bxxxxxx0x}		{ more(6); }
<MORE>{bx0xxxxxx}	{ one(); }
<MORE>.			{ error(); }
.			{ error(); }

%%

#include <stdio.h>

int
main(int argc, char *argv[])
{
	int i;

	yylex();
	for (i = 0; i < nbytes; i++) {
		printf("%x", (unsigned char)bytes[i]);
	}
	putchar('\n');
	return 0;
}
