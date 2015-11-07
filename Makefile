# utf8

CC=	cc -Wall -g -O0
LEX=	flex

HDRS=	srcs/scan.h srcs/utf8.h
OBJS=	srcs/display.o srcs/main.o srcs/scan.o srcs/utf8.o

srcs/utf8.exe: ${OBJS}
	${CC} -o srcs/utf8.exe ${OBJS} -ll

.for o in ${OBJS}
${o}: ${o:R}.c ${HDRS}
	${CC} -o ${o} -c ${o:R}.c
.endfor

srcs/scan.c: srcs/scan.l ${HDRS}
	${LEX} --prefix=utf8_yy -osrcs/scan.c srcs/scan.l

clean:
	rm -f srcs/*.o srcs/*.exe srcs/scan.c
