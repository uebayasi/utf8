# utf8

OBJS=	display.o main.o scan.o utf8.o

utf8.exe: ${OBJS}
	cc -Wall -g -O0 -o utf8.exe ${OBJS} -ll

.for o in ${OBJS}
${o}: ${o:R}.c
	cc -Wall -g -O0 -o ${o} -c ${o:R}.c
.endfor

scan.c: scan.l
	flex -oscan.c scan.l
