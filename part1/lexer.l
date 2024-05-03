%{
#include <stdio.h>
#include <string.h>
#include <ctype.h>
int line=1;
%}

digit           [0-9]
letter          [a-zA-Z]
identifier      ({letter}|_)(({letter}|{digit}|_)*)
number          ({digit}+)
real            {digit}+"."{digit}+
whitespace      [ \t]
comment         "//"[^\n]*  

program_keyword     [pP][rR][oO][gG][rR][aA][mM]
integer_keyword     [iI][nN][tT][eE][gG][eE][rR]
real_keyword        [rR][eE][aA][lL]
boolean_keyword     [bB][oO][oO][lL][eE][aA][nN]
char_keyword        [cC][hH][aA][rR]
var_keyword         [vV][aA][rR]
to_keyword          [tT][oO]
downto_keyword      [dD][oO][wW][nN][tT][oO]
if_keyword          [iI][fF]
else_keyword        [eE][lL][sS][eE]
while_keyword       [wW][hH][iI][lL][eE]
for_keyword         [fF][oO][rR]
do_keyword          [dD][oO]
array_keyword       [aA][rR][rR][aA][yY]
and_keyword         [aA][nN][dD]
or_keyword          [oO][rR]
not_keyword         [nN][oO][tT]
begin_keyword       [bB][eE][gG][iI][nN]
end_keyword         [eE][nN][dD]
read_keyword        [rR][eE][aA][dD]
write_keyword       [wW][rR][iI][tT][eE]
then_keyword        [tT][hH][eE][nN]

%%
"\n"			{line++;}
{comment}               { /* Skip comments */ line++;}
{whitespace}            /* Skip whitespace */
\"[^"]*\"        { printf("%d          \t%s\t\STRING_LITERAL\n", line, yytext);}
{program_keyword}       { printf("%d          \t%s\t\tKEYWORD\n", line, yytext); }
{real_keyword}          { printf("%d          \t%s\t\tKEYWORD\n", line, yytext); }
{integer_keyword}      { printf("%d          \t%s\t\tKEYWORD\n", line, yytext); }
{boolean_keyword}       { printf("%d          \t%s\t\tKEYWORD\n", line, yytext); }
{char_keyword}         { printf("%d          \t%s\t\tKEYWORD\n", line, yytext); }
{var_keyword}           { printf("%d          \t%s\t\tKEYWORD\n", line, yytext); }
{to_keyword}            { printf("%d          \t%s\t\tKEYWORD\n", line, yytext); }
{downto_keyword}       { printf("%d          \t%s\t\tKEYWORD\n", line, yytext); }
{if_keyword}            { printf("%d          \t%s\t\tKEYWORD\n", line, yytext); }
{else_keyword}          { printf("%d          \t%s\t\tKEYWORD\n", line, yytext); }
{while_keyword}         { printf("%d          \t%s\t\tKEYWORD\n", line, yytext); }
{for_keyword}           { printf("%d          \t%s\t\tKEYWORD\n", line, yytext); }
{do_keyword}           { printf("%d          \t%s\t\tKEYWORD\n", line, yytext); }
\[                     { printf("%d          \t%s\t\PUNCTUATOR\n", line, yytext);}
\]                    { printf("%d          \t%s\t\PUNCTUATOR\n", line, yytext);}
[oO][fF]                { printf("%d          \t%s\t\tKEYWORD\n", line, yytext); }
\.\.                   { printf("%d          \t%s\t\PUNCTUATOR\n", line, yytext);}
{array_keyword}         { printf("%d          \t%s\t\tKEYWORD\n", line, yytext); }
{and_keyword}           { printf("%d          \t%s\t\tKEYWORD\n", line, yytext); }
{or_keyword}            { printf("%d          \t%s\t\tKEYWORD\n", line, yytext); }
{not_keyword}           { printf("%d          \t%s\t\tKEYWORD\n", line, yytext); }
{begin_keyword}         { printf("%d          \t%s\t\tKEYWORD\n", line, yytext); }
{end_keyword}           { printf("%d          \t%s\t\tKEYWORD\n", line, yytext); }
{read_keyword}          { printf("%d          \t%s\t\tKEYWORD\n", line, yytext); }
{write_keyword}         { printf("%d          \t%s\t\tKEYWORD\n", line, yytext); }
{then_keyword}         { printf("%d          \t%s\t\tKEYWORD\n", line, yytext); }
":="			{ printf("%d          \t%s\t\t\OPERATOR\n", line, yytext); }
\.                  { printf("%d          \t%s\t\t\PUNCTUATOR\n", line, yytext);}
{identifier}            { printf("%d        \t%s\t\t\IDENTIFIER\n", line, yytext); }
{number}                { printf("%d          \t%s\t\t\NUMBER\n", line, yytext); }
{real}                { printf("%d          \t%s\t\t\REAL_NUMBER\n", line, yytext); }
"+"                       { printf("%d          \t%s\t\t\OPERATOR\n", line, yytext); }
"-"                       { printf("%d          \t%s\t\t\OPERATOR\n", line, yytext); }
"*"                       { printf("%d          \t%s\t\t\OPERATOR\n", line, yytext); }
"/"                       { printf("%d          \t%s\t\t\OPERATOR\n", line, yytext); }
"%"                       { printf("%d          \t%s\t\t\OPERATOR\n", line, yytext); }
"="                       { printf("%d          \t%s\t\t\OPERATOR\n", line, yytext); }
"<>"                      { printf("%d          \t%s\t\t\OPERATOR\n", line, yytext); }
"<"                       { printf("%d          \t%s\t\t\OPERATOR\n", line, yytext); }
">"                       { printf("%d          \t%s\t\t\OPERATOR\n", line, yytext); }
"<="                      { printf("%d          \t%s\t\t\OPERATOR\n", line, yytext); }
">="                      { printf("%d          \t%s\t\t\OPERATOR\n", line, yytext); }

";"                       { printf("%d          \t%s\t\t\PUNCTUATOR\n", line, yytext); }
","                       { printf("%d          \t%s\t\t\PUNCTUATOR\n", line, yytext); }
":"                       { printf("%d          \t%s\t\t\PUNCTUATOR\n", line, yytext); }
"("                       { printf("%d          \t%s\t\t\PUNCTUATOR\n", line, yytext); }
")"                       { printf("%d          \t%s\t\t\PUNCTUATOR\n", line, yytext); }

.                       { printf("ERROR: Invalid token: %s (line: %d)\n", yytext, line); }
%%

int main() {
    printf("Enter the file name with extension (eg. input.txt)\n");
    char file[100];
    scanf("%s",file);
    yyin=fopen(file,"r");
    printf("line number\t lexeme\t\t token type\n");
    yylex();
    fclose(yyin);
    return 0;
}

