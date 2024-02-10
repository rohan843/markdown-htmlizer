%{
#include <stdio.h>

void insertH1(char *text, int leng);
%}

%option noyywrap

/* Headings */
H1  ^((\#[[:blank:]]+.*)|(.+\n\={3,}[[:blank:]]*))\n

%%

{H1}    {
    insertH1(yytext, yyleng);
}

%%

/* 
Inserts a given text verbatim within an H1 html tag after removing any markdown related syntax.
(Does NOT escape characters such as '<' or '&').
*/
void insertH1(char *const text, const int leng) {
    if(text[0] == '#') {
        /* 
        Writes a heading of the form
            # Heading 1
        into the document by removing the `#` symbol and any whitespace after it.
        */
        int offset = 1;
        while(offset < leng && (text[offset] == ' ' || text[offset] == '\t')) offset++;
        fprintf(yyout, "<h1>%s</h1>\n", text + offset);
    } else {
        /* 
        Writes a heading of the form
            Heading 1
            =========
        into the document by removing everything including and after the first `\n` (i.e., removes
        all things after the first line).
        */
        int lim = 0;
        while(text[lim] != '\n') lim++;
        text[lim] = '\0';
        fprintf(yyout, "<h1>%s</h1>\n", text);
        text[lim] = '\n';
    }
}