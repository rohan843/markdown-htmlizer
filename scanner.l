%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
%}
%%

%%

char *H1(char *text) {
    size_t html_len_bytes = sizeof(char) * (strlen(text) + strlen("<h1></h1>") + 3);
    char *res_html = (char*) malloc(html_len_bytes);
    return snprintf(res_html, html_len_bytes, "<h1>%s</h1>", res_html);
}