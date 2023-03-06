VALGRIND_FLAGS=--leak-check=full --track-origins=yes --show-reachable=yes --error-exitcode=2 --show-leak-kinds=all --trace-children=yes
CFLAGS =-g -std=c99 -Wall -Wconversion -Wtype-limits -pedantic -Werror -O2
CC = gcc

all: clean valgrind

ejemplo: ejemplo.c src/*
	$(CC) $(CFLAGS) src/*.c ejemplo.c -o ejemplo 2>&1
	
pruebas_alumno: src/*.c pruebas_alumno.c
	$(CC) $(CFLAGS) src/*.c pruebas_alumno.c -o pruebas_alumno

valgrind: pruebas_alumno
	valgrind $(VALGRIND_FLAGS) ./pruebas_alumno 2>&1

clean:
	rm -f ejemplo 2>&1
	
