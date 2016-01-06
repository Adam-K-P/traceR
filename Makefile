CPP     = g++ -g -O0 -Wall -Wextra -std=gnu++11
EXECBIN = traceR

CPPSRC  = main.cpp
OBJECTS = ${CPPSRC:.cpp=.o}

FLEX  = flex --header-file=${LEXHDR} --outfile=${LEXCPP}
BISON = bison --defines=${PARSEHDR} --output=${PARSECPP}

FLEXSRC  = lexer.l
BISONSRC = parser.
LEXHDR   = yylex.h
LEXCPP   = yylex.cpp
PARSEHDR = yyparse.h
PARSECPP = yyparse.cpp
LEXOUT   = yylex.output
PARSEOUT = yyparse.output

all: ${OBJECTS}
	${CPP} -o ${EXECBIN} ${OBJECTS}

%.o : %.cpp ${LEXCPP}
	${CPP} -c $<

${LEXCPP} : ${FLEXSRC}
	${FLEX} ${FLEXSRC} 2>${LEXOUT}
	- grep -v '^  ' ${LEXOUT}

clean:
	rm yylex*
	rm *o
	rm traceR
