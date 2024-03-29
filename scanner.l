%{
#include <stdio.h>

void insertH1(char *const text, int leng);
void insertH2(char *const text, int leng);
void insertH(char *const text, const int leng, const int heading_level);
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
H2  ^((\#{2}[[:blank:]]+.*)|(.+\n\-{3,}[[:blank:]]*))\n
H3  ^(\#{3}[[:blank:]]+.*)\n
H4  ^(\#{4}[[:blank:]]+.*)\n
H5  ^(\#{5}[[:blank:]]+.*)\n
H6  ^(\#{6}[[:blank:]]+.*)\n

%%

{H1}    {
    insertH(yytext, yyleng, 1);
}

{H2}    {
    insertH(yytext, yyleng, 2);
}

{H3}    {
    insertH(yytext, yyleng, 3);
}

{H4}    {
    insertH(yytext, yyleng, 4);
}

{H5}    {
    insertH(yytext, yyleng, 5);
}

{H6}    {
    insertH(yytext, yyleng, 6);
}

%%

/* 
Inserts a given text verbatim within an H<heading_level> html tag after removing any markdown
related syntax.
(Does NOT escape characters such as '<' or '&').
*/
void insertH(char *const text, const int leng, const int heading_level) {
    switch(heading_level) {
        case 1: 
            insertH1(text, leng);
            break;
        case 2: 
            insertH2(text, leng);
            break;
        case 3:
        case 4:
        case 5:
        case 6:
            ;
            int offset = heading_level;
            while(offset < leng && (text[offset] == ' ' || text[offset] == '\t')) offset++;
            fprintf(yyout, "<h%d>%s</h%d>\n", heading_level, text + offset, heading_level);
            break;
    }
}

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

/* 
Inserts a given text verbatim within an H2 html tag after removing any markdown related syntax.
(Does NOT escape characters such as '<' or '&').
*/
void insertH2(char *const text, const int leng) {
    if(text[0] == '#') {
        /* 
        Writes a heading of the form
            ## Heading 2
        into the document by removing the `##` symbols and any whitespace after them.
        */
        int offset = 2;
        while(offset < leng && (text[offset] == ' ' || text[offset] == '\t')) offset++;
        fprintf(yyout, "<h2>%s</h2>\n", text + offset);
    } else {
        /* 
        Writes a heading of the form
            Heading 2
            ---------
        into the document by removing everything including and after the first `\n` (i.e., removes
        all things after the first line).
        */
        int lim = 0;
        while(text[lim] != '\n') lim++;
        text[lim] = '\0';
        fprintf(yyout, "<h2>%s</h2>\n", text);
        text[lim] = '\n';
    }
}
