# Adam Pinarbasi
# Makefile for traceR

CPP     = g++ -g -O0 -Wall -Wextra -std=c++1y
EXECBIN = traceR

CPPSRC  = main.cpp file.cpp analyzer.cpp yylex.cpp yyparse.cpp 
OBJECTS = ${CPPSRC:.cpp=.o} 

FLEX  = flex --header-file=${LEXHDR} --outfile=${LEXCPP}
BISON = bison --defines=${PARSEHDR} --output=${PARSECPP}

FLEXSRC  = lexer.l
BISONSRC = parser.y
LEXHDR   = yylex.h
LEXCPP   = yylex.cpp
PARSEHDR = yyparse.h
PARSECPP = yyparse.cpp
LEXOUT   = yylex.output
PARSEOUT = yyparse.output

all: ${OBJECTS}
	${CPP} -o ${EXECBIN} ${OBJECTS}

%.o : %.cpp ${LEXCPP} ${PARSECPP}
	${CPP} -c $<

${LEXCPP} : ${FLEXSRC}
	${FLEX} ${FLEXSRC} 2>${LEXOUT}
	- grep -v '^  ' ${LEXOUT}

${PARSECPP} ${PARSEHDR} : ${BISONSRC}
	${BISON} ${BISONSRC}

clean:
	rm yylex* yyparse*
	rm *o
	rm traceR

del:
	rm fibb_out.c
	rm stack_out.c
	rm a_test_out.c

test: all
	./traceR tests/fibb.c > fibb_out.c
	./traceR tests/stack.c > stack_out.c
	./traceR tests/a_test.c > a_test_out.c

install: all
	sudo cp traceR /usr/bin/
	make clean
