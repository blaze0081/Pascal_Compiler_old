%{
#include "ast.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
extern FILE* yyin;
extern int yylineno;
symboltable* t;

int n=1;
%}

%token <tree> PROGRAM INTEGER_KEYWORD REAL_KEYWORD BOOLEAN_KEYWORD CHAR_KEYWORD VAR
%token <tree> TO DOWNTO IF ELSE WHILE FOR DO ARRAY AND OR NOT PASCAL_BEGIN END READ WRITE
%token <tree> IDENTIFIER STRING_LITERAL 
%token <tree> INTEGER_LITERAL
%token <tree> REAL_LITERAL
%token <tree> PLUS MINUS MULT DIV MOD EQUALS NOT_EQUALS LESS_THAN GREATER_THAN LESS_THAN_EQ GREATER_THAN_EQ
%token <tree> SEMICOLON COMMA COLON LPAREN RPAREN PERIOD COLON_EQUALS THEN
%token <tree> LBRACKET RBRACKET OF DOTDOT

%type<tree>  variable_declaration declaration_list array_type type range statement_list program
%type <tree> statement  assignment_statement conditional_statement loop_statement read_statement write_statement recursive_declaration
%type<tree>  expression pascal_begin_end_block_cond identifier_list type_1 comb arithematic_expression conditional_expression recursive_parameters
%left PLUS MINUS AND OR EQUALS NOT_EQUALS
%left LESS_THAN LESS_THAN_EQ GREATER_THAN GREATER_THAN_EQ
%left MULT DIV MOD
%left LPAREN RPAREN
%right COLON_EQUALS NOT

%union {
    Node* tree;
}
%%

program:
    PROGRAM IDENTIFIER SEMICOLON variable_declaration pascal_begin_end_block_cond PERIOD
    {
        $$=createNode();
        strcpy($$->name,"Program_");
        strcat($$->name,$1->name);
        addchild($$,$4);
        addchild($$,$5);
        //dfs($$);
        
        solve(t,$$);
        printf("\n");
        printf("Symbol Table\n");
        print_table(t);
        YYACCEPT;
    }
;
recursive_declaration: declaration_list SEMICOLON {
    $$=createNode();
        setname($$,"Variable_Declaration");
        addchild($$,$1);
} | recursive_declaration declaration_list SEMICOLON {
    addchild($1,$2);
    $$=$1;
};
variable_declaration:
    VAR recursive_declaration  {
        $$=$2;
    }
;

identifier_list: IDENTIFIER{
    $$=createNode();
    addchild($$,$1);
} | identifier_list COMMA IDENTIFIER 
{
    addchild($1,$3);
    $$=$1;
} ;

declaration_list:
    identifier_list COLON type {
        setname($1,$3->name);
        $$=$1;
        for(int i=0; i<$$->n; i++)
        addentry(t,$$->children[i]->name,$3->ival);
    }
;

type:
    type_1 {$$=$1;}
    | array_type {$$=$1; $$->ival+=4;}
;
type_1:
    INTEGER_KEYWORD {$$=$1;}
    | REAL_KEYWORD  {$$=$1;}
    | BOOLEAN_KEYWORD {$$=$1;}
    | CHAR_KEYWORD {$$=$1;}
;

array_type:
    ARRAY LBRACKET range RBRACKET OF type_1 {$$=$1; strcat($$->name,"_Array");} 
;

range:
    INTEGER_LITERAL DOTDOT INTEGER_LITERAL 
;

pascal_begin_end_block_cond:
    PASCAL_BEGIN statement_list END {
       $$=$2;
    }
;
statement_list:
    statement {
        $$=createNode();
        setname($$,"STATEMENTS");
        addchild($$,$1);}
    | statement_list statement {
        addchild($1,$2);
        $$=$1;
    }
;

statement:
    assignment_statement {
        $$=$1;
        }
    | conditional_statement {
        $$=$1;
        }
    | loop_statement {
        $$=$1;
        }
    | read_statement {
        $$=$1;
        }
    | write_statement {
        $$=$1;
        }
;

assignment_statement:
    IDENTIFIER COLON_EQUALS expression SEMICOLON {
        $$=createNode();
        setname($$,"Assign");
        addchild($$,$1);
        addchild($$,$3);
    }|  
    IDENTIFIER LBRACKET expression RBRACKET COLON_EQUALS expression SEMICOLON {
        $$=createNode();
        setname($$,"Assign");
        addchild($$,$1);
        addchild($$,$3);
        addchild($$,$6);
    }
;

expression:
    arithematic_expression {
        $$=$1;
    }

    | conditional_expression{ 
        $$=$1;
        }
;
arithematic_expression:
    INTEGER_LITERAL { 
        $$=$1;  
    }
    | REAL_LITERAL  {
       $$=$1;
    } 
    | IDENTIFIER     {  $$=$1;  }
    | IDENTIFIER LBRACKET arithematic_expression RBRACKET {
        $$=createNode();
        setname($$,"Array_Access");
        addchild($$,$1);
        addchild($$,$3);
    }
    | arithematic_expression PLUS arithematic_expression {
        $$=createNode();
        setname($$,"PLUS");
        addchild($$,$1);
        addchild($$,$3);
    }
    | arithematic_expression MINUS arithematic_expression {
        $$=createNode();
        setname($$,"MINUS");
        addchild($$,$1);
        addchild($$,$3);
    }
    | arithematic_expression MULT arithematic_expression {
        $$=createNode();
        setname($$,"MULTIPLY");
        addchild($$,$1);
        addchild($$,$3);
    }
    | arithematic_expression DIV arithematic_expression {
        $$=createNode();
        setname($$,"DIVISION");
        addchild($$,$1);
        addchild($$,$3);
    }
    | arithematic_expression MOD arithematic_expression {
        $$=createNode();
        setname($$,"MODULUS");
        addchild($$,$1);
        addchild($$,$3);
    }
    | LPAREN arithematic_expression RPAREN {
        $$=createNode();
        setname($$,"Expression");
        addchild($$,$1);
        addchild($$,$2);
        addchild($$,$3);
    }
    ;
conditional_expression:
    arithematic_expression EQUALS arithematic_expression {
        $$=createNode();
        setname($$,"EQUALS");
        addchild($$,$1);
        addchild($$,$3);
        
    }
    | arithematic_expression NOT_EQUALS arithematic_expression{
         $$=createNode();
        setname($$,"NOT_EQUALS");
        addchild($$,$1);
        addchild($$,$3);
        
    }
    | arithematic_expression LESS_THAN arithematic_expression{
         $$=createNode();
        setname($$,"LESS_THAN");
        addchild($$,$1);
        addchild($$,$3);
        
    }
    | arithematic_expression GREATER_THAN arithematic_expression{
       $$=createNode();
        setname($$,"GREATER_THAN");
        addchild($$,$1);
        addchild($$,$3);
    }
    | arithematic_expression LESS_THAN_EQ arithematic_expression{
         $$=createNode();
        setname($$,"LESS_THAN_EQUALS");
        addchild($$,$1);
        addchild($$,$3);
    }
    | arithematic_expression GREATER_THAN_EQ arithematic_expression {
         $$=createNode();
        setname($$,"GREATER_THAN_EQUALS");
        addchild($$,$1);
        addchild($$,$3);
       
    }
     | LPAREN conditional_expression RPAREN {
         $$=createNode();
        setname($$,"Expression");
        addchild($$,$1);
        addchild($$,$2);
        addchild($$,$3);
       
     }
    | NOT conditional_expression {
         $$=createNode();
        setname($$,"NOT");
        addchild($$,$2);
        
    }
    | conditional_expression AND conditional_expression {
        $$=createNode();
        setname($$,"AND");
        addchild($$,$1);
        addchild($$,$3);
        
    }
    | conditional_expression OR conditional_expression {
        $$=createNode();
        setname($$,"OR");
        addchild($$,$1);
        addchild($$,$3);
        
    }
    | IDENTIFIER {
        $$=$1;
        
    }
    | IDENTIFIER LBRACKET arithematic_expression RBRACKET {
        $$=createNode();
        setname($$,"Array_Access");
        addchild($$,$1);
        addchild($$,$3);
    }
;
conditional_statement:
    IF conditional_expression THEN pascal_begin_end_block_cond SEMICOLON {
        $$=createNode();
        setname($$,"Branch");
        addchild($$,$2);
        addchild($$,$4);
        
    }
    | IF conditional_expression THEN pascal_begin_end_block_cond ELSE pascal_begin_end_block_cond SEMICOLON {
         $$=createNode();
        setname($$,"Branch");
        addchild($$,$2);
        addchild($$,$4);
        addchild($$,$6);
    }
;

loop_statement:
    WHILE conditional_expression DO pascal_begin_end_block_cond SEMICOLON {
         $$=createNode();
        setname($$,"WHILE");
        addchild($$,$2);
        addchild($$,$4);
    }
    | FOR IDENTIFIER COLON_EQUALS arithematic_expression TO arithematic_expression DO pascal_begin_end_block_cond SEMICOLON {
         $$=createNode();
        setname($$,"FORTO");
        addchild($$,$2);
        addchild($$,$4);
        addchild($$,$6);
        addchild($$,$8);
    }
    | FOR IDENTIFIER COLON_EQUALS arithematic_expression DOWNTO arithematic_expression DO pascal_begin_end_block_cond SEMICOLON {
        $$=createNode();
        setname($$,"FORDOWNTO");
        addchild($$,$2);
        addchild($$,$4);
        addchild($$,$6);
        addchild($$,$8);
    }
;
comb: IDENTIFIER  {
        $$=$1;
    
}| 
    IDENTIFIER LBRACKET arithematic_expression RBRACKET{
        $$=createNode();
        setname($$,"Array_Access");
        addchild($$,$1);
        addchild($$,$3); 
    } ;
read_statement:
    READ LPAREN comb RPAREN SEMICOLON {
        $$=createNode();
        setname($$,"READ");
        addchild($$,$3);
    }
;
recursive_parameters: recursive_parameters COMMA comb {
    addchild($1,$3);
    $$=$1;
}| comb {
    $$=createNode();
        setname($$,"Paramters");
        addchild($$,$1);
} ; 
write_statement:
    WRITE LPAREN STRING_LITERAL RPAREN SEMICOLON {
       $$=createNode();
        setname($$,"Write");
        Node*temp= createNode();
        setname(temp,"STRING_LITERAL");
        addchild(temp,$3);
        addchild($$,temp);
    }
    | WRITE LPAREN recursive_parameters RPAREN SEMICOLON
    { 
        $$=createNode();
        setname($$,"Write");
        addchild($$,$3);
    }
;

%%

int main(int argc, char *argv[]){

    char* filename;

    filename=argv[1];
    yyin=fopen(filename, "r");
    t=calloc(100,sizeof(symboltable));
    t->n=0;
    for(int i=0; i<100; i++)
    t->table[i]=NULL;
    yyparse();

    return 0;

}


int yyerror(char *s) {
    fprintf(stderr, "%s\n", s);
    return 0;
}
