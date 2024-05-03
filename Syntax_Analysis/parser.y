%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
extern FILE* yyin;
extern int yylineno;
%}


%token PROGRAM INTEGER_KEYWORD REAL_KEYWORD BOOLEAN_KEYWORD CHAR_KEYWORD VAR
%token TO DOWNTO IF ELSE WHILE FOR DO ARRAY AND OR NOT PASCAL_BEGIN END READ WRITE
%token IDENTIFIER STRING_LITERAL 
%token INTEGER_LITERAL
%token REAL_LITERAL
%token PLUS MINUS MULT DIV MOD EQUALS NOT_EQUALS LESS_THAN GREATER_THAN LESS_THAN_EQ GREATER_THAN_EQ
%token SEMICOLON COMMA COLON LPAREN RPAREN PERIOD COLON_EQUALS THEN
%token LBRACKET RBRACKET OF DOTDOT

%type variable_declaration pascal_begin_end_block declaration_list array_type type range statement_list
%type statement  assignment_statement conditional_statement loop_statement read_statement write_statement
%type expression pascal_begin_end_block_cond
%left PLUS MINUS AND OR EQUALS NOT_EQUALS
%left LESS_THAN LESS_THAN_EQ GREATER_THAN GREATER_THAN_EQ
%left MULT DIV MOD
%left LPAREN RPAREN
%right COLON_EQUALS NOT
%%

program:
    PROGRAM IDENTIFIER SEMICOLON variable_declaration pascal_begin_end_block 
    {
        printf("Valid Input\n");
        YYACCEPT;
    }
;
recursive_declaration: declaration_list SEMICOLON | recursive_declaration declaration_list SEMICOLON;
variable_declaration:
    VAR recursive_declaration  
;

identifier_list: IDENTIFIER | identifier_list COMMA IDENTIFIER ;

declaration_list:
    identifier_list COLON type 
;

type:
    INTEGER_KEYWORD 
    | REAL_KEYWORD 
    | BOOLEAN_KEYWORD 
    | CHAR_KEYWORD 
    | array_type
;
type_1:
    INTEGER_KEYWORD 
    | REAL_KEYWORD 
    | BOOLEAN_KEYWORD 
    | CHAR_KEYWORD 
;

array_type:
    ARRAY LBRACKET range RBRACKET OF type_1
;

range:
    INTEGER_LITERAL DOTDOT INTEGER_LITERAL 
;

pascal_begin_end_block:
    PASCAL_BEGIN statement_list END PERIOD
;
pascal_begin_end_block_cond:
    PASCAL_BEGIN statement_list END
;
statement_list:
    statement
    | statement_list statement
;

statement:
    assignment_statement
    | conditional_statement
    | loop_statement
    | read_statement
    | write_statement
;

assignment_statement:
    IDENTIFIER COLON_EQUALS expression SEMICOLON | IDENTIFIER LBRACKET expression RBRACKET COLON_EQUALS expression SEMICOLON
    
;

expression:
    arithematic_expression|conditional_expression
;
arithematic_expression:
    INTEGER_LITERAL 
    | REAL_LITERAL   
    | IDENTIFIER     
    | IDENTIFIER LBRACKET expression RBRACKET 
    | arithematic_expression PLUS arithematic_expression
    | arithematic_expression MINUS arithematic_expression
    | arithematic_expression MULT arithematic_expression
    | arithematic_expression DIV arithematic_expression
    | arithematic_expression MOD arithematic_expression
    | LPAREN arithematic_expression RPAREN
    ;
conditional_expression:
    arithematic_expression EQUALS arithematic_expression
    | arithematic_expression NOT_EQUALS arithematic_expression
    | arithematic_expression LESS_THAN arithematic_expression
    | arithematic_expression GREATER_THAN arithematic_expression
    | arithematic_expression LESS_THAN_EQ arithematic_expression
    | arithematic_expression GREATER_THAN_EQ arithematic_expression | LPAREN conditional_expression RPAREN
    | NOT conditional_expression | conditional_expression AND conditional_expression | conditional_expression OR conditional_expression | IDENTIFIER 
    | IDENTIFIER LBRACKET expression RBRACKET 
;
conditional_statement:
    IF conditional_expression THEN pascal_begin_end_block_cond SEMICOLON
    | IF conditional_expression THEN pascal_begin_end_block_cond ELSE pascal_begin_end_block_cond SEMICOLON
;

loop_statement:
    WHILE conditional_expression DO pascal_begin_end_block_cond SEMICOLON
    | FOR IDENTIFIER COLON_EQUALS arithematic_expression TO arithematic_expression DO pascal_begin_end_block_cond SEMICOLON
    | FOR IDENTIFIER COLON_EQUALS arithematic_expression DOWNTO arithematic_expression DO pascal_begin_end_block_cond SEMICOLON
;
comb: IDENTIFIER | IDENTIFIER LBRACKET arithematic_expression RBRACKET;
read_statement:
    READ LPAREN comb RPAREN SEMICOLON 
;
recursive_parameters: recursive_parameters COMMA comb | comb ; 
write_statement:
    WRITE LPAREN STRING_LITERAL RPAREN SEMICOLON
    | WRITE LPAREN recursive_parameters RPAREN SEMICOLON
;

%%

int main() {
    printf("Starting the parser...\n");
    
    printf("Enter the file name with extension (eg. input.txt)\n");
    char file[100];
    scanf("%s",file);
    yyin=fopen(file,"r");
    yyparse();
    return 0;
}

int yyerror(char *s) {
    fprintf(stderr, "%s\n", s);
    return 0;
}
