struct code {
	char value;
	int nbits;
};

struct utf8 {
	int total, nbytes;
	struct code codes[6];
};

struct ucs4 {
	int code;
	int nbits;
};

extern struct utf8 utf8;
extern struct ucs4 ucs4;

void prepare(void);
void display(void);
