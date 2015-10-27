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

#ifndef _UTF8_H_
#define _UTF8_H_

enum {
	UTF8_SEQ_MIN = 1,
	UTF8_SEQ_MAX = 6,
};

struct code {
	char value;
	int nbits;
};

struct utf8 {
	int total, nbytes;
	struct code codes[UTF8_SEQ_MAX];
};

struct ucs4 {
	int code;
	int nbits;
};

extern struct utf8 utf8;
extern struct ucs4 ucs4;

void utf8_reset(void);
int utf8_more(void);
void make_ucs4(struct ucs4 *, struct utf8 *);

#endif /* _UTF8_H_ */
