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

#include "utf8.h"

static void
make_ucs4(void)
{
	int i;

	for (i = 0; i < utf8.nbytes; i++) {
		unsigned char m, v;
		int s;

		m = (1 << utf8.codes[i].nbits) - 1;
		v = utf8.codes[i].value & m;
		s = 32 - ucs4.nbits - utf8.codes[i].nbits;
		ucs4.code |= (int)v << s;
		ucs4.nbits += utf8.codes[i].nbits;
	}
}

void
prepare(void)
{
	make_ucs4();
}
