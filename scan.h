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
