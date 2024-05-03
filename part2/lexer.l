%{
#include "y.tab.h"
%}

%%

[ \t]+                    { /* ignore whitespace */ }
\n                        { /* ignore newlines */ }
"//"[^\n]*              { /* ignore single line comments */ }
\"[^"]*\"        { return STRING_LITERAL; }


[pP][rR][oO][gG][rR][aA][mM] {  return PROGRAM; }
[iI][nN][tT][eE][gG][eE][rR] { return INTEGER_KEYWORD; }
[rR][eE][aA][lL]         { return REAL_KEYWORD; }
[bB][oO][oO][lL][eE][aA][nN] { return BOOLEAN_KEYWORD; }
[cC][hH][aA][rR]         { return CHAR_KEYWORD; }
[vV][aA][rR]             { return VAR; }
[tT][oO]                 { return TO; }
[dD][oO][wW][nN][tT][oO] { return DOWNTO; }
[iI][fF]                 { return IF; }
[eE][lL][sS][eE]         { return ELSE; }
[wW][hH][iI][lL][eE]     { return WHILE; }
[fF][oO][rR]             { return FOR; }
[dD][oO]                { return DO; }
[aA][rR][rR][aA][yY]     { return ARRAY; }
\[                       { return LBRACKET; }
\]                       { return RBRACKET; }
[oO][fF]                 { return OF; }
\.\.                     { return DOTDOT; }
[aA][nN][dD]             { return AND; }
[oO][rR]                 { return OR; }
[nN][oO][tT]             { return NOT; }
[bB][eE][gG][iI][nN]     { return PASCAL_BEGIN; }
[eE][nN][dD]             { return END; }
[rR][eE][aA][dD]         { return READ; }
[wW][rR][iI][tT][eE]     { return WRITE; }
[tT][hH][eE][nN]         { return THEN; }
:=                        { return COLON_EQUALS; }
\.                        { return PERIOD; }

[a-zA-Z][a-zA-Z0-9_]*     {  return IDENTIFIER;  }

[0-9]+                    {  return INTEGER_LITERAL; }
[0-9]+"."[0-9]+          {   return REAL_LITERAL; }

"+"                       { return PLUS; }
"-"                       { return MINUS; }
"*"                       { return MULT; }
"/"                       { return DIV; }
"%"                       { return MOD; }
"="                       { return EQUALS; }
"<>"                      { return NOT_EQUALS; }
"<"                       { return LESS_THAN; }
">"                       { return GREATER_THAN; }
"<="                      { return LESS_THAN_EQ; }
">="                      { return GREATER_THAN_EQ; }

";"                       { return SEMICOLON; }
","                       { return COMMA; }
":"                       { return COLON; }
"("                       { return LPAREN; }
")"                       { return RPAREN; }

.                         {  /* catchall for any other character */ }

%%

int yywrap() {
  return 1;
}
