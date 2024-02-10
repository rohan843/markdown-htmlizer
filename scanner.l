%{
#include <stdio.h>

void insertH1(char *text, int leng);
%}

%option noyywrap

/* 
# Headings

Rules:

1. **Every heading must start at the beginning of some line**, i.e., _right before_ an intended 
heading, there must be a newline ('\n') character (this character is not considered a part of the 
heading syntax; it must _precede_ the heading).
2. **Every heading is terminated by a newline**, i.e., we consider a given text string to be a
heading only if a newline character ('\n') is the text string's last character. (Note: heading
syntaxes might contain a newline character ('\n') themselves. This point merely says that the syntax
requires the _last_ character to be newline too.) While scanning, this newline character is
considered a part of the heading syntax.
3. **The syntax between the 2 newline characters** comes from 
[this link](https://www.markdownguide.org/basic-syntax/#headings).
*/
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