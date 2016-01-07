#include "motion.tab.c"
#include "lex.yy.c"
#include "yyerror.c"
int main(){
	printf("\nMotion Trajectory Checker (Scanner/Parser)\nCPSC/ECE 3520 Spring 2015\n");
	yyparse();
	return 1;
}
