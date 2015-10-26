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

#include <stdlib.h>

static int nbytes;
static int total;
static struct {
	char value;
	char nbits;
} codes[6];
static int code;
static char nbits;

#define	one(n) do { \
	codes[nbytes].value = yytext[0]; \
	codes[nbytes].nbits = (n); \
	nbytes++; \
	if (nbytes == total) { \
		return nbytes; \
	} else { \
		BEGIN(MORE); \
	} \
} while (0)
#define	more(t, n) do { \
	total = (t); \
	one(n); \
} while (0)
#define	error() do { \
	return -1; \
} while (0)
#define	done() do { \
	exit(0); \
} while (0)

%}

%s	MORE

b0xxxxxxx		[\x00-\x7f]
b10xxxxxx		[\x80-\xbf]
b110xxxxx		[\xc2-\xdf]
b1110xxxx		[\xe0-\xef]
b11110xxx		[\xf0-\xf7]
b111110xx		[\xf8-\xfb]
b1111110x		[\xfc-\xfd]

%%

{b0xxxxxxx}		more(1, 7);
{b110xxxxx}		more(2, 5);
{b1110xxxx}		more(3, 4);
{b11110xxx}		more(4, 3);
{b111110xx}		more(5, 2);
{b1111110x}		more(6, 1);
<MORE>{b10xxxxxx}	one(6);
<MORE>.			error();
.			error();
<<EOF>>			done();

%%

#include <stdio.h>

static void
make_code(void)
{
	int i;

	code = 0;
	nbits = 0;
	for (i = 0; i < nbytes; i++) {
		unsigned char v, s;
		int m;

		v = (unsigned char)(codes[i].value & ((1 << codes[i].nbits) - 1));
		s = 32 - nbits - codes[i].nbits;
		m = v << s;
		code |= m;
		nbits += codes[i].nbits;
	}
}

static void
prepare(void)
{
	make_code();
}

static void
display_raw(void)
{
	int i;

	putchar('\'');
	for (i = 0; i < nbytes; i++)
		putchar((unsigned char)codes[i].value);
	putchar('\'');
}

static void
display_code(void)
{
	int i;

	printf("U+");
	for (i = 0; i < 32 && i < nbits; i += 8)
		printf("%02X", (unsigned char)(code >> (32 - i - 8)));
}

static void
display_hex(void)
{
	int i;

	printf("\\x");
	for (i = 0; i < nbytes; i++)
		printf("%02X", (unsigned char)codes[i].value);
}

void
display(void)
{
	display_raw();
	putchar('\t');
	display_code();
	putchar('\t');
	display_hex();
	putchar('\n');
}

int
main(int argc, char *argv[])
{
	while (nbytes != -1) {
		nbytes = total = 0;
		yylex();
		prepare();
		display();
	}
	return 0;
}
