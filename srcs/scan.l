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
#include <stdio.h>
#include <stdlib.h>
#include "utf8.h"
#include "scan.h"
%}

b0xxxxxxx		[\x00-\x7f]
b10xxxxxx		[\x80-\xbf]
b110xxxxx		[\xc2-\xdf]
b1110xxxx		[\xe0-\xef]
b11110xxx		[\xf0-\xf7]
b111110xx		[\xf8-\xfb]
b1111110x		[\xfc-\xfd]

%state	MORE

%option	nounput
%option	noinput
%{
#ifndef YY_NO_UNPUT
#define YY_NO_UNPUT 1
#endif
#ifndef YY_NO_INPUT
#define YY_NO_INPUT 1
#endif
%}

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

void
initscan(void)
{
	static struct yy_buffer_state yy;
	static char buf[UTF8_SEQ_MAX + 2];

	yy.yy_buf_size = UTF8_SEQ_MAX;
	yy.yy_ch_buf = buf;
	yy.yy_is_our_buffer = 1;
	utf8_yy_init_buffer(&yy, stdin);
	utf8_yy_switch_to_buffer(&yy);
}

void
scan(void)
{
	utf8_yylex();
}

int
utf8_yywrap(void)
{
	return 1;
}
