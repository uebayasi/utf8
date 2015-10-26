#include "utf8.h"

static void
make_code(void)
{
	int i;

	for (i = 0; i < nbytes; i++) {
		unsigned char m, v;
		int s;

		m = (1 << codes[i].nbits) - 1;
		v = (unsigned char)(codes[i].value & m);
		s = 32 - nbits - codes[i].nbits;
		code |= (int)v << s;
		nbits += codes[i].nbits;
	}
}

void
prepare(void)
{
	make_code();
}
