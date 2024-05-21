%{
	#include<stdio.h>
	#include<string.h>
	
	// Preprocessor commands to make this portable to other systems.

	// For regular lex and yacc, where y.tab.h is the header file generated.
	# if defined __has_include
	#  if __has_include ("y.tab.h")
	#     include "y.tab.h"
	#     define Y_TAB_H
	#  endif
	# endif
	
	// For flex and bison (on cygwin), where cucu.tab.h is the header file generated.
	# ifndef Y_TAB_H
 	#  if defined __has_include
 	#   if __has_include ("cucu.tab.h")
	#      include "cucu.tab.h"
	#   endif
	#  endif
	# endif
	
	void foundToken(char *tokenText, char *tokenName);
	int yylex();
	FILE *out;
%}

%%
\/\*(.)*\*\/		;
\".*\"			{ yylval.string=strdup(yytext);			foundToken(yytext,"STR_LIT");			return STR_LIT;			}
"int"			{ 						foundToken(yytext,"INT");			return INT;			}
char[ ]*\*		{ 						foundToken(yytext,"STR");			return STR;			}
char[ ]*\*[ ]*\*	{ 						foundToken(yytext,"STR_PTR");			return STR_PTR;			}
"while"			{ yylval.string=strdup(yytext);			foundToken(yytext,"WHILE");			return WHILE;			}
"if"			{ yylval.string=strdup(yytext);			foundToken(yytext,"IF");			return IF;			}
"else"			{ yylval.string=strdup(yytext);			foundToken(yytext,"ELSE");			return ELSE;			}
"return"		{ yylval.string=strdup(yytext);			foundToken(yytext,"RETURN");			return RETURN;			}
";"			{ 						foundToken(yytext,"EOS");			return EOS;			}
"("			{ 						foundToken(yytext,"LPAR");			return LPAR;			}
")"			{ 						foundToken(yytext,"RPAR");			return RPAR;			}
"{"			{ 						foundToken(yytext,"LBRACE");			return LBRACE;			}
"}"			{ 						foundToken(yytext,"RBRACE");			return RBRACE;			}
"["			{ 						foundToken(yytext,"LSQBRACE");			return LSQBRACE;		}
"]"			{ 						foundToken(yytext,"RSQBRACE");			return RSQBRACE;		}
","			{ 						foundToken(yytext,"COMMA");			return COMMA;			}
[0-9]+			{ yylval.string=strdup(yytext);			foundToken(yytext,"INT_LIT");			return INT_LIT;			}
"=="			{ 						foundToken(yytext,"DOUBLE_EQUALS");		return DOUBLE_EQUALS;		}
"!="			{ 						foundToken(yytext,"NOT_EQUALS");		return NOT_EQUALS;		}
">="			{ 						foundToken(yytext,"GREATER_THAN_EQUALS");	return GREATER_THAN_EQUALS;	}
">"			{ 						foundToken(yytext,"GREATER_THAN");		return GREATER_THAN;		}
"<="			{ 						foundToken(yytext,"LESS_THAN_EQUALS");		return LESS_THAN_EQUALS;	}
"<"			{ 						foundToken(yytext,"LESS_THAN");			return LESS_THAN;		}
"!"			{ 						foundToken(yytext,"LOGICAL_NOT");		return LOGICAL_NOT;		}
"&&"			{ 						foundToken(yytext,"LOGICAL_AND");		return LOGICAL_AND;		}
"||"			{ 						foundToken(yytext,"LOGICAL_OR");		return LOGICAL_OR;		}
"^"			{ 						foundToken(yytext,"BITWISE_XOR");		return BITWISE_XOR;		}
"&"			{ 						foundToken(yytext,"BITWISE_AND");		return BITWISE_AND;		}
"|"			{ 						foundToken(yytext,"BITWISE_OR");		return BITWISE_OR;		}
"+"			{ 						foundToken(yytext,"PLUS");			return PLUS;			}
"-"			{ 						foundToken(yytext,"MINUS");			return MINUS;			}
"*"			{ 						foundToken(yytext,"MUL");			return MUL;			}
"/"			{ 						foundToken(yytext,"DIV");			return DIV;			}
"="			{ 						foundToken(yytext,"EQUALS");			return EQUALS;			}
[a-zA-Z_][a-zA-Z0-9_]*	{ yylval.string=strdup(yytext);			foundToken(yytext,"ID");			return ID;			}
[ \t\n]+		;
%%
int yywrap()
{
	return 1;
}

void foundToken(char *tokenText, char *tokenName)
{
	fprintf(out,"%s : %s\n",tokenName,tokenText);
}
