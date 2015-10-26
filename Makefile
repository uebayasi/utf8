utf8: scan.c
	cc -Wall -g -O0 -o utf8.exe scan.c -ll

scan.c: scan.l
	flex -oscan.c scan.l
