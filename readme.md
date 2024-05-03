CS F363 Compiler Construction
Assignment-2
 

Part 3: Compilation Steps // Semantic Analysis

To check Semantic Errors

flex lexer.l
yacc -d parser.y
cc lex.yy.c y.tab.c symbol.c -ll
./a.out input.txt

To print Abstract Syntax Tree// AST build

cd syntaxtree_part3
flex lexer.l
yacc -d parser.y
cc lex.yy.c y.tab.c ast.c -ll
./a.out input.txt

Part 4: Compilation Steps  // Three Address Code Generated 

flex lexer.l
yacc -d parser.y
cc lex.yy.c y.tab.c threeaddcode.c -ll
./a.out input.txt

Part 5:                   //   Give output of the code and Symbol Table
flex lexer.l
yacc -d parser.y
cc lex.yy.c y.tab.c ast.c -ll
./a.out input.txt

