%{
#include "ast.h"
#include "y.tab.h"

#define ICONST "iconst"
#define RCONST "rconst"
%}

%%

[ \t]+                    { /* ignore whitespace */ }
\n                        { /* ignore newlines */ }
"//"[^\n]*              { /* ignore single line comments */ }
\"[^"]*\"        { yylval.tree=createNode(); strcpy(yylval.tree->name,yytext);    return STRING_LITERAL; }


[pP][rR][oO][gG][rR][aA][mM] { yylval.tree=createNode(); strcpy(yylval.tree->name,yytext); return PROGRAM; }
[iI][nN][tT][eE][gG][eE][rR] { yylval.tree=createNode(); strcpy(yylval.tree->name,yytext); yylval.tree->ival=0; 
  return INTEGER_KEYWORD; }
[rR][eE][aA][lL]         { yylval.tree=createNode(); strcpy(yylval.tree->name,yytext); yylval.tree->ival=1; return REAL_KEYWORD; }
[bB][oO][oO][lL][eE][aA][nN] { yylval.tree=createNode(); strcpy(yylval.tree->name,yytext); yylval.tree->ival=2; return BOOLEAN_KEYWORD; }
[cC][hH][aA][rR]         {  yylval.tree=createNode(); strcpy(yylval.tree->name,yytext); yylval.tree->ival=3;  return CHAR_KEYWORD; }
[vV][aA][rR]             { yylval.tree=createNode(); strcpy(yylval.tree->name,yytext); return VAR; }
[tT][oO]                 { yylval.tree=createNode(); strcpy(yylval.tree->name,yytext); return TO; }
[dD][oO][wW][nN][tT][oO] { yylval.tree=createNode(); strcpy(yylval.tree->name,yytext); return DOWNTO; }
[iI][fF]                 { yylval.tree=createNode(); strcpy(yylval.tree->name,yytext); return IF; }
[eE][lL][sS][eE]         { yylval.tree=createNode(); strcpy(yylval.tree->name,yytext); return ELSE; }
[wW][hH][iI][lL][eE]     { yylval.tree=createNode(); strcpy(yylval.tree->name,yytext); return WHILE; }
[fF][oO][rR]             { yylval.tree=createNode(); strcpy(yylval.tree->name,yytext); return FOR; }
[dD][oO]                { yylval.tree=createNode(); strcpy(yylval.tree->name,yytext); return DO; }
[aA][rR][rR][aA][yY]     { yylval.tree=createNode(); strcpy(yylval.tree->name,yytext); return ARRAY; }
\[                       { yylval.tree=createNode(); strcpy(yylval.tree->name,yytext); return LBRACKET; }
\]                       { yylval.tree=createNode(); strcpy(yylval.tree->name,yytext); return RBRACKET; }
[oO][fF]                 { yylval.tree=createNode(); strcpy(yylval.tree->name,yytext); return OF; }
\.\.                     { yylval.tree=createNode(); strcpy(yylval.tree->name,yytext); return DOTDOT; }
[aA][nN][dD]             { yylval.tree=createNode(); strcpy(yylval.tree->name,yytext); return AND; }
[oO][rR]                 { yylval.tree=createNode(); strcpy(yylval.tree->name,yytext); return OR; }
[nN][oO][tT]             { yylval.tree=createNode(); strcpy(yylval.tree->name,yytext); return NOT; }
[bB][eE][gG][iI][nN]     { yylval.tree=createNode(); strcpy(yylval.tree->name,yytext); return PASCAL_BEGIN; }
[eE][nN][dD]             { yylval.tree=createNode(); strcpy(yylval.tree->name,yytext); return END; }
[rR][eE][aA][dD]         { yylval.tree=createNode(); strcpy(yylval.tree->name,yytext); return READ; }
[wW][rR][iI][tT][eE]     { yylval.tree=createNode(); strcpy(yylval.tree->name,yytext); return WRITE; }
[tT][hH][eE][nN]         { yylval.tree=createNode(); strcpy(yylval.tree->name,yytext); return THEN; }
:=                        { yylval.tree=createNode(); strcpy(yylval.tree->name,yytext); return COLON_EQUALS; }
\.                        { yylval.tree=createNode(); strcpy(yylval.tree->name,yytext); return PERIOD; }

[a-zA-Z][a-zA-Z0-9_]*     { yylval.tree=createNode(); strcpy(yylval.tree->name,yytext);   return IDENTIFIER;  }

[0-9]+                    { yylval.tree=createNode();Node*t=createNode();  yylval.tree->ival=atoi(yytext); yylval.tree->fval=atoi(yytext); strcpy(yylval.tree->name,"ICONST"); strcpy(t->name,yytext); addchild(yylval.tree,t); return INTEGER_LITERAL; }
[0-9]+"."[0-9]+          { yylval.tree=createNode(); Node*t=createNode(); yylval.tree->fval=atof(yytext); strcpy(yylval.tree->name,"RCONST"); strcpy(t->name,yytext); addchild(yylval.tree,t);   return REAL_LITERAL; }

"+"                       {yylval.tree=createNode(); strcpy(yylval.tree->name,yytext); return PLUS; }
"-"                       {yylval.tree=createNode(); strcpy(yylval.tree->name,yytext); return MINUS; }
"*"                       {yylval.tree=createNode(); strcpy(yylval.tree->name,yytext); return MULT; }
"/"                       {yylval.tree=createNode(); strcpy(yylval.tree->name,yytext); return DIV; }
"%"                       {yylval.tree=createNode(); strcpy(yylval.tree->name,yytext); return MOD; }
"="                       {yylval.tree=createNode(); strcpy(yylval.tree->name,yytext); return EQUALS; }
"<>"                      {yylval.tree=createNode(); strcpy(yylval.tree->name,yytext); return NOT_EQUALS; }
"<"                       {yylval.tree=createNode(); strcpy(yylval.tree->name,yytext); return LESS_THAN; }
">"                       {yylval.tree=createNode(); strcpy(yylval.tree->name,yytext); return GREATER_THAN; }
"<="                      {yylval.tree=createNode(); strcpy(yylval.tree->name,yytext); return LESS_THAN_EQ; }
">="                      {yylval.tree=createNode(); strcpy(yylval.tree->name,yytext); return GREATER_THAN_EQ; }

";"                       {yylval.tree=createNode(); strcpy(yylval.tree->name,yytext); return SEMICOLON; }
","                       {yylval.tree=createNode(); strcpy(yylval.tree->name,yytext); return COMMA; }
":"                       {yylval.tree=createNode(); strcpy(yylval.tree->name,yytext); return COLON; }
"("                       {yylval.tree=createNode(); strcpy(yylval.tree->name,yytext); return LPAREN; }
")"                       {yylval.tree=createNode(); strcpy(yylval.tree->name,yytext); return RPAREN; }

.                         {  /* catchall for any other character */ }

%%

int yywrap() {
  return 1;
}
