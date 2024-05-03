flex lexer.l
yacc -d parser.y
cc y.tab.c lex.yy.c threeaddcode.c -ll