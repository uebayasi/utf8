# utf8

HDRS=	scan.h utf8.h
OBJS=	display.o main.o scan.o utf8.o

utf8.exe: ${OBJS}
	cc -Wall -g -O0 -o utf8.exe ${OBJS} -ll

.for o in ${OBJS}
${o}: ${o:R}.c ${HDRS}
	cc -Wall -g -O0 -o ${o} -c ${o:R}.c
.endfor

scan.c: scan.l ${HDRS}
	flex -oscan.c scan.l
