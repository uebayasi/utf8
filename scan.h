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

#ifndef _SCAN_H_
#define _SCAN_H_

#define	save(c, b) do { \
	utf8.codes[utf8.nbytes].value = (c); \
	utf8.codes[utf8.nbytes].nbits = (b); \
	utf8.nbytes++; \
} while (0)
#define	one(b) do { \
	save(yytext[0], b); \
	if (utf8.nbytes == utf8.total) { \
		return utf8.nbytes; \
	} else { \
		BEGIN(MORE); \
	} \
} while (0)
#define	more(t, b) do { \
	utf8.total = (t); \
	one(b); \
} while (0)
#define	error() do { \
	save(*yy_bp, -1); \
	return -1; \
} while (0)
#define	done() do { \
	exit(0); \
} while (0)

void initscan(void);
void scan(void);

#endif /* _SCAN_H_ */
