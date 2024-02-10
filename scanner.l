%{
#include <stdio.h>
%}
%%

%%

void H1(char *text) {
    fprintf(yyout, "<h1>%s</h1>\n", text);
}