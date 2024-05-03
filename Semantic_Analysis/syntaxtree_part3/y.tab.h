/* A Bison parser, made by GNU Bison 3.5.1.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015, 2018-2020 Free Software Foundation,
   Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

/* Undocumented macros, especially those whose name start with YY_,
   are private implementation details.  Do not rely on them.  */

#ifndef YY_YY_Y_TAB_H_INCLUDED
# define YY_YY_Y_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token type.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    PROGRAM = 258,
    INTEGER_KEYWORD = 259,
    REAL_KEYWORD = 260,
    BOOLEAN_KEYWORD = 261,
    CHAR_KEYWORD = 262,
    VAR = 263,
    TO = 264,
    DOWNTO = 265,
    IF = 266,
    ELSE = 267,
    WHILE = 268,
    FOR = 269,
    DO = 270,
    ARRAY = 271,
    AND = 272,
    OR = 273,
    NOT = 274,
    PASCAL_BEGIN = 275,
    END = 276,
    READ = 277,
    WRITE = 278,
    IDENTIFIER = 279,
    STRING_LITERAL = 280,
    INTEGER_LITERAL = 281,
    REAL_LITERAL = 282,
    PLUS = 283,
    MINUS = 284,
    MULT = 285,
    DIV = 286,
    MOD = 287,
    EQUALS = 288,
    NOT_EQUALS = 289,
    LESS_THAN = 290,
    GREATER_THAN = 291,
    LESS_THAN_EQ = 292,
    GREATER_THAN_EQ = 293,
    SEMICOLON = 294,
    COMMA = 295,
    COLON = 296,
    LPAREN = 297,
    RPAREN = 298,
    PERIOD = 299,
    COLON_EQUALS = 300,
    THEN = 301,
    LBRACKET = 302,
    RBRACKET = 303,
    OF = 304,
    DOTDOT = 305
  };
#endif
/* Tokens.  */
#define PROGRAM 258
#define INTEGER_KEYWORD 259
#define REAL_KEYWORD 260
#define BOOLEAN_KEYWORD 261
#define CHAR_KEYWORD 262
#define VAR 263
#define TO 264
#define DOWNTO 265
#define IF 266
#define ELSE 267
#define WHILE 268
#define FOR 269
#define DO 270
#define ARRAY 271
#define AND 272
#define OR 273
#define NOT 274
#define PASCAL_BEGIN 275
#define END 276
#define READ 277
#define WRITE 278
#define IDENTIFIER 279
#define STRING_LITERAL 280
#define INTEGER_LITERAL 281
#define REAL_LITERAL 282
#define PLUS 283
#define MINUS 284
#define MULT 285
#define DIV 286
#define MOD 287
#define EQUALS 288
#define NOT_EQUALS 289
#define LESS_THAN 290
#define GREATER_THAN 291
#define LESS_THAN_EQ 292
#define GREATER_THAN_EQ 293
#define SEMICOLON 294
#define COMMA 295
#define COLON 296
#define LPAREN 297
#define RPAREN 298
#define PERIOD 299
#define COLON_EQUALS 300
#define THEN 301
#define LBRACKET 302
#define RBRACKET 303
#define OF 304
#define DOTDOT 305

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
union YYSTYPE
{
#line 30 "parser.y"

    Node* tree;

#line 161 "y.tab.h"

};
typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_Y_TAB_H_INCLUDED  */
