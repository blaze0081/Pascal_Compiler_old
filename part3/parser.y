%{
#include "symbol.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
extern FILE* yyin;
extern int yylineno;
table * symboltable;
%}

%union {
    struct {
        int type;
        int ival;
        float fval;
        char str[100];
    }data;
}
%token <data> PROGRAM INTEGER_KEYWORD REAL_KEYWORD BOOLEAN_KEYWORD CHAR_KEYWORD VAR
%token <data> TO DOWNTO IF ELSE WHILE FOR DO ARRAY AND OR NOT PASCAL_BEGIN END READ WRITE
%token <data> IDENTIFIER STRING_LITERAL 
%token <data> INTEGER_LITERAL
%token <data> REAL_LITERAL
%token <data> PLUS MINUS MULT DIV MOD EQUALS NOT_EQUALS LESS_THAN GREATER_THAN LESS_THAN_EQ GREATER_THAN_EQ
%token <data> SEMICOLON COMMA COLON LPAREN RPAREN PERIOD COLON_EQUALS THEN
%token <data> LBRACKET RBRACKET OF DOTDOT

%type<data>  variable_declaration pascal_begin_end_block declaration_list array_type type range statement_list
%type <data> statement  assignment_statement conditional_statement loop_statement read_statement write_statement
%type <data>  expression pascal_begin_end_block_cond identifier_list type_1 comb arithematic_expression
%left PLUS MINUS AND OR EQUALS NOT_EQUALS
%left LESS_THAN LESS_THAN_EQ GREATER_THAN GREATER_THAN_EQ
%left MULT DIV MOD
%left LPAREN RPAREN
%right COLON_EQUALS NOT
%%

program:
    PROGRAM IDENTIFIER SEMICOLON variable_declaration pascal_begin_end_block 
    {
        YYACCEPT;
    }
;
recursive_declaration: declaration_list SEMICOLON | recursive_declaration declaration_list SEMICOLON;
variable_declaration:
    VAR recursive_declaration  
;

identifier_list: IDENTIFIER {strcpy($$.str,$1.str); strcat($$.str,"$");}| identifier_list COMMA IDENTIFIER {strcat($1.str,$3.str);strcpy($$.str,$1.str);strcat($$.str,"$");} ;

declaration_list:
    identifier_list COLON type {
        for(int i=0; i<strlen($1.str); i++){
            char temp[20];
            int initial=i;
            memset(temp, '\0', sizeof(temp));
            while($1.str[i]!='$'){ 
            *(temp+i-initial)=$1.str[i];
            i++;
            }
            if(!insertEntry(symboltable,temp,$3.type))
            printf("Multiple Declaration of variable %s \n",temp);
                }}
;

type:
    type_1 {$$.type=$1.type;}
    | array_type   {$$.type=$1.type+4;}
;
type_1:
    INTEGER_KEYWORD {$$.type=$1.type;}
    | REAL_KEYWORD  {$$.type=$1.type;}
    | BOOLEAN_KEYWORD {$$.type=$1.type;}
    | CHAR_KEYWORD {$$.type=$1.type;}
;

array_type:
    ARRAY LBRACKET range RBRACKET OF type_1 {$$.type=$6.type; }
;

range:
    INTEGER_LITERAL DOTDOT INTEGER_LITERAL { if($1.ival>$3.ival){printf("Error -Incorrect definition of array , High range limit < low range limit\n");}}
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
    IDENTIFIER COLON_EQUALS expression SEMICOLON { setEntry(symboltable,$1.str); 
    if(($3.type%4)!=(getEntryType(symboltable,$1.str)%4) && $3.type!=-1 && getEntryType(symboltable,$1.str)!=-1 )
    {
        printf("Assignment Type mismatch in %s \n",$1.str);
    }} | 
    IDENTIFIER LBRACKET expression RBRACKET COLON_EQUALS expression SEMICOLON {setEntry(symboltable,$1.str);
    if(($6.type%4)!=(getEntryType(symboltable,$1.str)%4) && $6.type!=-1 && getEntryType(symboltable,$1.str)!=-1 )
    {
        printf("Assignment Type mismatch in %s\n",$1.str);
    }
    if($3.type!=0)
    printf("Invalid Array Index in  %s - Expected Integer \n",$1.str);}
    
;

expression:
    arithematic_expression{$$.type=$1.type;}|conditional_expression {$$.type=3;}
;
arithematic_expression:
    INTEGER_LITERAL {$$.type=$1.type;} 
    | REAL_LITERAL  {$$.type=$1.type;} 
    | IDENTIFIER  {checkSet(symboltable,$1.str); $$.type=getEntryType(symboltable,$1.str);}
    | IDENTIFIER LBRACKET expression RBRACKET {checkSet(symboltable,$1.str); $$.type=getEntryType(symboltable,$1.str);}
    | arithematic_expression PLUS arithematic_expression {if(($1.type%4)==($3.type%4)){
        $$.type=$1.type;
    }else{
        $$.type=-1;
        if($1.type!=-1 && $3.type!=-1)
        printf("Invalid Type Operation: %s\n","+");
    }}
    | arithematic_expression MINUS arithematic_expression {if($1.type==$3.type){
        $$.type=$1.type;
    }else{
        $$.type=-1;
        if($1.type!=-1 && $3.type!=-1)
        printf("Invalid Type Operation: %s\n","-");
    }}
    | arithematic_expression MULT arithematic_expression {if($1.type==$3.type){
        $$.type=$1.type;
    }else{
        $$.type=-1;
        if($1.type!=-1 && $3.type!=-1)
        printf("Invalid Type Operation: %s\n","*");
    }}
    | arithematic_expression DIV arithematic_expression {if($1.type==$3.type){
        $$.type=2;
    }else{
        $$.type=-1;
        if($1.type!=-1 && $3.type!=-1)
        printf("Invalid Type Operation: %s\n","/");
    }}
    | arithematic_expression MOD arithematic_expression {if($1.type==$3.type){
        $$.type=$1.type;
    }else{
        $$.type=-1;
        if($1.type!=-1 && $3.type!=-1)
        printf("Invalid Type Operation: %s\n","%");
    }}
    | LPAREN arithematic_expression RPAREN {$$.type=$2.type;}
    ;
conditional_expression:
    arithematic_expression EQUALS arithematic_expression 
    | arithematic_expression NOT_EQUALS arithematic_expression
    | arithematic_expression LESS_THAN arithematic_expression
    | arithematic_expression GREATER_THAN arithematic_expression
    | arithematic_expression LESS_THAN_EQ arithematic_expression
    | arithematic_expression GREATER_THAN_EQ arithematic_expression | LPAREN conditional_expression RPAREN
    | NOT conditional_expression | conditional_expression AND conditional_expression | conditional_expression OR conditional_expression
    | IDENTIFIER {checkSet(symboltable,$1.str);
        if(getEntryType(symboltable,$1.str)!=3){
        printf("Invalid Type Operation: %s, Not a Boolean\n",$1.str);
    }} | IDENTIFIER LBRACKET expression RBRACKET {
        checkSet(symboltable,$1.str);
        if(getEntryType(symboltable,$1.str)!=7){
        printf("Invalid Type Operation: %s, Not a Boolean\n",$1.str);
    }
    }
;
conditional_statement:
    IF conditional_expression THEN pascal_begin_end_block_cond SEMICOLON
    | IF conditional_expression THEN pascal_begin_end_block_cond ELSE pascal_begin_end_block_cond SEMICOLON
;
loop_in : IDENTIFIER COLON_EQUALS arithematic_expression TO arithematic_expression {setEntry(symboltable,$1.str); if($3.type!=0 || $5.type!=0){printf("Range of a loop must be Integer \n");} if(getEntryType(symboltable,$1.str)!=0){printf("Type Mismatch - %s , Got Integer\n",$1.str);}}|
 IDENTIFIER COLON_EQUALS arithematic_expression DOWNTO arithematic_expression {setEntry(symboltable,$1.str); if($3.type!=0 || $5.type!=0){printf("Invalid Type of Range In loop \n");} if(getEntryType(symboltable,$1.str)!=0){printf("Type Mismatch - %s , Got Integer\n",$1.str);}};
loop_statement:
    WHILE conditional_expression DO pascal_begin_end_block_cond SEMICOLON
    | FOR loop_in DO pascal_begin_end_block_cond SEMICOLON  
;
comb: IDENTIFIER {strcpy($$.str,$1.str);} | 
      IDENTIFIER LBRACKET arithematic_expression RBRACKET {strcpy($$.str,$1.str);};
read_statement:
    READ LPAREN comb RPAREN SEMICOLON {setEntry(symboltable,$3.str); }
;
recursive_parameters: recursive_parameters COMMA comb {checkSet(symboltable,$3.str);} | comb {checkSet(symboltable,$1.str);} ; 
write_statement:
    WRITE LPAREN STRING_LITERAL RPAREN SEMICOLON 
    | WRITE LPAREN recursive_parameters RPAREN SEMICOLON
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
