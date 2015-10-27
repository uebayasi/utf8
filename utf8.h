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

void make_ucs4(struct ucs4 *, struct utf8 *);
