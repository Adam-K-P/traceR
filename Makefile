# Adam Pinarbasi
# Makefile for traceR

CPP     = g++ -g -O0 -Wall -Wextra -std=gnu++11
EXECBIN = traceR

CPPSRC  = main.cpp yylex.cpp yyparse.cpp file.cpp
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
