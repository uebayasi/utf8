struct code {
	char value;
	int nbits;
};

extern int total, nbytes, code, nbits;
extern struct code codes[6];

void prepare(void);
void display(void);
