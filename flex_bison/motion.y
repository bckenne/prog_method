%{
#include <stdio.h>
#include <ctype.h>
int yylex(void);
int yyerror(char *s);
int x = 0;
int y = 0;
int moved = 0;
%}
%token ERR
%token U
%token D
%token L
%token R
%token N
%token NUM

%% /*Grammar Rules*/
finaltraj: trajectory {
		printf("\n\n\n***** congratulations *****\n");
		if(y!=0||x!=0||moved==0)
		printf("***** scan/parse for valid motion path successful *****\n\n\n\n");
		else printf("***** valid motion path AND CLOSED PATH *****\n\n\n\n");
	}
	;
trajectory: motion 
	| motion resttraj
	;
resttraj: motion 
	| motion trajectory
	;
motion: single 
	| multiple
	;
single: U {y++; moved=1;}
	| D {y--; moved=1;}
	| R {x++; moved=1;}
	| L {x--; moved=1;}
	| N 
	| ERR {yyerror("syntax error"); YYERROR;}
	;
multiple: U NUM {y+=$2; moved=1;}
	| D NUM {y-=$2; moved=1;}
	| R NUM {x+=$2; moved=1;}
	| L NUM {x-=$2; moved=1;}
	| N NUM
	;
%%