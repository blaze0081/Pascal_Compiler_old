flex lexer.l
yacc -d parser.y
cc y.tab.c lex.yy.c symbol.c -ll