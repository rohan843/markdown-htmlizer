#include <stdio.h>
#include "lex.yy.c"
extern FILE *yyout;

int main()
{
    FILE *inputFile = fopen("input.md", "r");
    FILE *outputFile = fopen("output.html", "w");
    yyrestart(inputFile);
    yyout = outputFile;
    yylex();
    fclose(inputFile);
    fclose(outputFile);
    return 0;
}