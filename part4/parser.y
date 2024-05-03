%{
#include "threeaddcode.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
extern FILE* yyin;
extern int yylineno;
int n=1;
%}

%token <data> PROGRAM INTEGER_KEYWORD REAL_KEYWORD BOOLEAN_KEYWORD CHAR_KEYWORD VAR
%token <data> TO DOWNTO IF ELSE WHILE FOR DO ARRAY AND OR NOT PASCAL_BEGIN END READ WRITE
%token <data> IDENTIFIER STRING_LITERAL 
%token <data> INTEGER_LITERAL
%token <data> REAL_LITERAL
%token <data> PLUS MINUS MULT DIV MOD EQUALS NOT_EQUALS LESS_THAN GREATER_THAN LESS_THAN_EQ GREATER_THAN_EQ
%token <data> SEMICOLON COMMA COLON LPAREN RPAREN PERIOD COLON_EQUALS THEN
%token <data> LBRACKET RBRACKET OF DOTDOT

%type<data>  variable_declaration declaration_list array_type type range statement_list
%type <data> statement  assignment_statement conditional_statement loop_statement read_statement write_statement
%type<data>  expression pascal_begin_end_block_cond identifier_list type_1 comb arithematic_expression conditional_expression recursive_parameters
%left PLUS MINUS AND OR EQUALS NOT_EQUALS
%left LESS_THAN LESS_THAN_EQ GREATER_THAN GREATER_THAN_EQ
%left MULT DIV MOD
%left LPAREN RPAREN
%right COLON_EQUALS NOT

%union {
    struct data1 data;
}
%%

program:
    PROGRAM IDENTIFIER SEMICOLON variable_declaration pascal_begin_end_block_cond PERIOD
    {
        printf("%s",$5.code);
        YYACCEPT;
    }
;
recursive_declaration: declaration_list SEMICOLON | recursive_declaration declaration_list SEMICOLON;
variable_declaration:
    VAR recursive_declaration  
;

identifier_list: IDENTIFIER | identifier_list COMMA IDENTIFIER  ;

declaration_list:
    identifier_list COLON type 
;

type:
    type_1 
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

pascal_begin_end_block_cond:
    PASCAL_BEGIN statement_list END {$$.code=$2.code;}
;
statement_list:
    statement {$$.code=$1.code;}
    | statement_list statement { handle_rec_st(&$$,$1,$2);}
;

statement:
    assignment_statement {$$.code=$1.code;}
    | conditional_statement {$$.code=$1.code;}
    | loop_statement {$$.code=$1.code;}
    | read_statement {$$.code=$1.code;}
    | write_statement {$$.code=$1.code;}
;

assignment_statement:
    IDENTIFIER COLON_EQUALS expression SEMICOLON {
     assignment_handle(&$$, $1, $3,&n);
    }| 
    IDENTIFIER LBRACKET expression RBRACKET COLON_EQUALS expression SEMICOLON {
            assignment_handlearray(&$$, $1, $3,$6,&n);
    }
    
;

expression:
    arithematic_expression { strcpy($$.str,$1.str); $$.code=$1.code;}|conditional_expression{ strcpy($$.str,$1.str); $$.code=$1.code;}
;
arithematic_expression:
    INTEGER_LITERAL { sprintf($$.str, "%d", $1.ival);  }
    | REAL_LITERAL  { sprintf($$.str, "%f", $1.fval); } 
    | IDENTIFIER     { strcpy($$.str,$1.str);}
    | IDENTIFIER LBRACKET arithematic_expression RBRACKET {array_handle(&$$, $1, $3, &n);}
    | arithematic_expression PLUS arithematic_expression {
        arithematic_comp(&$$, $1, $3, &n,"+");
    }
    | arithematic_expression MINUS arithematic_expression { arithematic_comp(&$$, $1, $3, &n,"-");}
    | arithematic_expression MULT arithematic_expression { arithematic_comp(&$$, $1, $3, &n,"*");}
    | arithematic_expression DIV arithematic_expression { arithematic_comp(&$$, $1, $3, &n,"/");}
    | arithematic_expression MOD arithematic_expression { arithematic_comp(&$$, $1, $3, &n,"%");}
    | LPAREN arithematic_expression RPAREN { strcpy($$.str,$2.str); $$.code=$2.code;}
    ;
conditional_expression:
    arithematic_expression EQUALS arithematic_expression { conditional_handle(&$$,$1,$3,&n,"=");}
    | arithematic_expression NOT_EQUALS arithematic_expression{ conditional_handle(&$$,$1,$3,&n,"not equals");}
    | arithematic_expression LESS_THAN arithematic_expression{conditional_handle(&$$,$1,$3,&n,"<");}
    | arithematic_expression GREATER_THAN arithematic_expression{conditional_handle(&$$,$1,$3,&n,">");}
    | arithematic_expression LESS_THAN_EQ arithematic_expression{conditional_handle(&$$,$1,$3,&n,"<=");}
    | arithematic_expression GREATER_THAN_EQ arithematic_expression {conditional_handle(&$$,$1,$3,&n,">=");}
     | LPAREN conditional_expression RPAREN { strcpy($$.str,$2.str); $$.code=$2.code;}
    | NOT conditional_expression {conditional_handle_not(&$$,$1,&n);}
    | conditional_expression AND conditional_expression {conditional_handle(&$$,$1,$3,&n,"&");}
    | conditional_expression OR conditional_expression {conditional_handle(&$$,$1,$3,&n,"|");}
    | IDENTIFIER {strcpy($$.str,$1.str);} | IDENTIFIER LBRACKET arithematic_expression RBRACKET {array_handle(&$$, $1, $3, &n);}
;
conditional_statement:
    IF conditional_expression THEN pascal_begin_end_block_cond SEMICOLON { conditional_if(&$$,$2,$4);}
    | IF conditional_expression THEN pascal_begin_end_block_cond ELSE pascal_begin_end_block_cond SEMICOLON { conditional_if_else(&$$,$2,$4,$6);}
;

loop_statement:
    WHILE conditional_expression DO pascal_begin_end_block_cond SEMICOLON { while_handler(&$$,$2,$4);}
    | FOR IDENTIFIER COLON_EQUALS arithematic_expression TO arithematic_expression DO pascal_begin_end_block_cond SEMICOLON { for_to(&$$,$2,$4,$6,$8);}
    | FOR IDENTIFIER COLON_EQUALS arithematic_expression DOWNTO arithematic_expression DO pascal_begin_end_block_cond SEMICOLON { for_downto(&$$,$2,$4,$6,$8);}
;
comb: IDENTIFIER  {strcpy($$.str,$1.str);}| 
      IDENTIFIER LBRACKET arithematic_expression RBRACKET{ array_handle(&$$,$1,$3,&n);} ;
read_statement:
    READ LPAREN comb RPAREN SEMICOLON { read_handle(&$$,$3);}
;
recursive_parameters: recursive_parameters COMMA comb {char*str=calloc(20,sizeof(char));sprintf(str,"%s,%s",$1.str,$3.str); strcpy($$.str,str);}| comb { strcpy($$.str,$1.str);} ; 
write_statement:
    WRITE LPAREN STRING_LITERAL RPAREN SEMICOLON { char *result=calloc(200,sizeof(char));
    sprintf(result,"write(%s)\n",$3.str);
    $$.code=result;
    }
    | WRITE LPAREN recursive_parameters RPAREN SEMICOLON
    { 
    char *result=calloc(200,sizeof(char));
    sprintf(result,"write(%s)\n",$3.str);
    $$.code=result;
    }
;

%%

int main(int argc, char *argv[]){

    char* filename;

    filename=argv[1];

    printf("\n");

    yyin=fopen(filename, "r");

    yyparse();

    return 0;

}

int yyerror(char *s) {
    fprintf(stderr, "%s\n", s);
    return 0;
}
