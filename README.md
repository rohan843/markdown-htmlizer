# markdown-htmlizer

This is a tool to convert markdown syntax to HTML. Since there is no single markdown standard, I am
currently following the syantax described [here](https://www.markdownguide.org/basic-syntax/). Later
on, I might expand this to allow the
[extended syntax](https://www.markdownguide.org/extended-syntax/) or
[GFM](https://github.github.com/gfm/).

To run this tool, you will require flex (I used flex version 2.5.4). It may be downloaded from
[here](https://sourceforge.net/projects/gnuwin32/files/flex/2.5.4a-1/flex-2.5.4a-1.exe/download) if
you're on a windows machine. For a debian based system, you may install via apt ad described
[here](https://askubuntu.com/a/164301).

The exact procedure is:

1. Clone this repo on your local machine.
2. In the root folder, run `flex scanner.l` to create the scanner file.
   > This will create the file `lex.yy.c`.
3. Now, create a file called `input.md` with whatever markdown you wish to convert to HTML in the
   same (root) directory.
4. Finally, compile and run `main.c` using a C compiler (I used `gcc`. `Microsoft Visual C++`
   compiler caused an issue with a `_fileno` macro (it seems a `#define _fileno fileno` is required)
   but otherwise it _might_ work fine.)

> Basic workflow:
>
> ```bash
> flex scanner.l
> gcc lex.yy.c
> .\a.exe # On windows
> ./a.out # On linux
> ```

5. Now, the generated `output.html` file will contain the generated HTML.
