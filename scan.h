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
