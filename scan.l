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

static int total, nbytes, code, nbits;
static struct {
	char value;
	int nbits;
} codes[6];

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

%s MORE

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

	for (i = 0; i < nbytes; i++) {
		unsigned char m, v;
		int s;

		m = (1 << codes[i].nbits) - 1;
		v = (unsigned char)(codes[i].value & m);
		s = 32 - nbits - codes[i].nbits;
		code |= (int)v << s;
		nbits += codes[i].nbits;
	}
}

static void
prepare(void)
{
	make_code();
}

static void
display_ascii(char c)
{
	char v = 0;

	switch (c) {
	case 000: v = '0'; break;
	case 007: v = 'a'; break;
	case 010: v = 'b'; break;
	case 011: v = 't'; break;
	case 012: v = 'n'; break;
	case 013: v = 'v'; break;
	case 014: v = 'f'; break;
	case 015: v = 'r'; break;
	case 040: v = 's'; break;
	default: break;
	}
	if (v != 0) {
		putchar('\\');
		putchar(v);
	} else
		putchar(c);
}

static void
display_raw(void)
{
	int i;

	putchar('\'');
	if (nbytes == 1)
		display_ascii(codes[0].value);
	else {
		for (i = 0; i < nbytes; i++)
			putchar((unsigned char)codes[i].value);
	}
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
		total = nbytes = code = nbits = 0;
		yylex();
		prepare();
		display();
	}
	return 0;
}
