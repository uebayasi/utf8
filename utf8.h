struct code {
	char value;
	int nbits;
};

struct ucs4 {
	int code;
	int nbits;
};

extern int total, nbytes;
extern struct code codes[6];
extern struct ucs4 ucs4;

void prepare(void);
void display(void);
