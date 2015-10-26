utf8: display.o scan.o
	cc -Wall -g -O0 -o utf8.exe display.o scan.o -ll

display.o: display.c
	cc -Wall -g -O0 -o display.o -c display.c

scan.o: scan.c
	cc -Wall -g -O0 -o scan.o -c scan.c

scan.c: scan.l
	flex -oscan.c scan.l
