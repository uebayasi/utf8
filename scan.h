#define	one(n) do { \
	utf8.codes[utf8.nbytes].value = yytext[0]; \
	utf8.codes[utf8.nbytes].nbits = (n); \
	utf8.nbytes++; \
	if (utf8.nbytes == utf8.total) { \
		return utf8.nbytes; \
	} else { \
		BEGIN(MORE); \
	} \
} while (0)
#define	more(t, n) do { \
	utf8.total = (t); \
	one(n); \
} while (0)
#define	error() do { \
	return -1; \
} while (0)
#define	done() do { \
	exit(0); \
} while (0)
