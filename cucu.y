%{
	#include<stdio.h>
	extern FILE *yyin, *out;
	FILE *parserOut;
	int yylex();
	int yyerror(char* msg);
	void matchedRule(char *lhs, char *rhs);
%}
%union
{
	int integer;
	char *string;
}


%token IF LPAR RPAR ELSE ID EOS WHILE RETURN LBRACE RBRACE INT STR STR_PTR COMMA INT_LIT STR_LIT LSQBRACE RSQBRACE EQUALS


//Operators following the same order of precedence as ANSI C standards.
%left BITWISE_XOR BITWISE_AND BITWISE_OR
%left LOGICAL_OR
%left LOGICAL_AND
%left GREATER_THAN GREATER_THAN_EQUALS
%left LESS_THAN LESS_THAN_EQUALS
%left NOT_EQUALS DOUBLE_EQUALS
%left PLUS MINUS
%left MUL DIV
%left LOGICAL_NOT


%%
program		: program dec								{matchedRule("\n",NULL);}
		| program funcDef 							{matchedRule("\n",NULL);}
		| 									{matchedRule("\n",NULL);}
;

dec		: varDec								{matchedRule("\n",NULL);}
		| funcDec								{matchedRule("\n",NULL);}
;

body		: body stmt								{matchedRule("\n",NULL);}
		| LBRACE body RBRACE							{matchedRule("BODY ENDS\n","\n");}
		| stmt									{matchedRule("\n",NULL);}
;

stmt		: conditional								{matchedRule("\n",NULL);}
		| varDec								{matchedRule("\n",NULL);}
		| assign								{matchedRule("\n",NULL);}
		| loop									{matchedRule("\n",NULL);}
		| funcCall								{matchedRule("\n",NULL);}
		| return								{matchedRule("\n",NULL);}
		| EOS									{matchedRule("\n",NULL);}
;

conditional	: IF LPAR boolean RPAR LBRACE body RBRACE ELSE LBRACE body RBRACE	{matchedRule("IF-ELSE := \n"," ");}
;

varDec		: type ID EOS								{matchedRule("Variable : ",yylval.string);}
		| type ID EQUALS expr EOS						{matchedRule("ASSIGNMENT :=","\n");}
;

assign		: ID EQUALS expr EOS							{matchedRule("ASSIGNMENT :=","\n");}
;

loop		: WHILE LPAR boolean RPAR LBRACE body RBRACE				{matchedRule("LOOP : ",yylval.string);}
;

funcCall	: ID LPAR exprList RPAR EOS						{matchedRule("Function Call\n","\n");}
;

return		: RETURN expr EOS							{matchedRule("\n",NULL);}
		| RETURN EOS								{matchedRule("\n",NULL);}
;

funcDef		: type ID LPAR argList RPAR LBRACE body RBRACE				{matchedRule("FUNCTION DEFINITION\n","\n");}
;

type		: INT									{matchedRule("\n",NULL);}
		| STR									{matchedRule("\n",NULL);}
		| STR_PTR								{matchedRule("\n",NULL);}
;

argList		: argList COMMA arg							{matchedRule("\n",NULL);}
		| arg									{matchedRule("\n",NULL);}
		|									{matchedRule("\n",NULL);}
;

arg		: type ID								{matchedRule("Function Argument : ",yylval.string);}
;

funcDec		: type ID LPAR argList RPAR EOS						{matchedRule("FUNCTION DECLARATION\n","\n");}
;

exprList	: exprList COMMA expr							{matchedRule("\n",NULL);}
		| expr									{matchedRule("\n",NULL);}
		| 									{matchedRule("\n",NULL);}
;

expr		: LPAR expr RPAR							{matchedRule("\n",NULL);}
		| expr BITWISE_XOR expr							{matchedRule("Operator: XOR "," ");}
		| expr BITWISE_AND expr							{matchedRule("Operator: AND "," ");}
		| expr BITWISE_OR expr							{matchedRule("Operator: OR"," ");}
		| expr PLUS expr							{matchedRule("Operator: PLUS"," ");}
		| expr MINUS expr							{matchedRule("Operator: MINUS"," ");}
		| expr MUL expr								{matchedRule("Operator: MUL"," ");}
		| expr DIV expr								{matchedRule("Operator: DIV"," ");}
		| literal								{matchedRule("Literal : ",yylval.string);}
		| ID									{matchedRule("Variable : ",yylval.string);}
;

literal		: INT_LIT								{matchedRule("\n",NULL);}
		| STR_LIT								{matchedRule("\n",NULL);}
;

boolean		: LPAR boolean RPAR							{matchedRule("\n",NULL);}
		| LOGICAL_NOT boolean							{matchedRule("Operator: !"," ");}
		| boolean LOGICAL_AND boolean						{matchedRule("Operator: &&"," ");}
		| boolean LOGICAL_OR boolean						{matchedRule("Operator: ||"," ");}
		| boolean NOT_EQUALS boolean						{matchedRule("Operator: !="," ");}
		| boolean DOUBLE_EQUALS boolean						{matchedRule("Operator: =="," ");}
		| boolean GREATER_THAN_EQUALS boolean					{matchedRule("Operator: >="," ");}
		| boolean GREATER_THAN boolean						{matchedRule("Operator: >"," ");}
		| boolean LESS_THAN_EQUALS boolean					{matchedRule("Operator: <="," ");}
		| boolean LESS_THAN boolean						{matchedRule("Operator: <"," ");}
		| ID									{matchedRule("Variable : ",yylval.string);}
		| INT_LIT								{matchedRule("Literal : \n",yylval.string);}
; 

%%
int main(int argc, char* argv[])
{
	parserOut = fopen("parser.txt","w");
	if (parserOut == NULL)
	{
		printf("parser.txt could not be created.\n");
		return 0;
	}
	out = fopen("lexer.txt","w");
	if (out == NULL)
	{
		printf("lexer.txt could not be created.\n");
		return 0;
	}
	if (argc > 1) yyin = fopen(argv[1],"r");	
	else
	{
		printf("Input File Not Found!\n");
		return 0;
	}
	yyparse();
	return 0;
}

int yyerror(char* msg)
{
	printf("Syntax Error\n");
	return 0;
}

void matchedRule(char *lhs, char *rhs)
{
	if (rhs != NULL) fprintf(parserOut,"%s%s\n",lhs,rhs);
//	else printf("%s : %s\n",lhs,rhs);				// --Used For Debugging
}
