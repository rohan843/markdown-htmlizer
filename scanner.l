%{
#include <stdio.h>
%}

/* Headings */
H1  ^#\ [^\n]+$

%%

{H1}

%%

void H1(char *text) {
    fprintf(yyout, "<h1>%s</h1>\n", text);
}