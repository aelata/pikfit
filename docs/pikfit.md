# pikfit

<style>code { white-space: pre-wrap !important; } </style>

With `pikfit`, you can easily embed figures written in the pic language into a Markdown document. You can use [pikchr](https://pikchr.org) or [dpic](https://www.ece.uwaterloo.ca/~aplevich/dpic) as a pic engine and optionally [m4](https://www.gnu.org/software/m4) as a macro processor. Embedding the figures uses the [code chunk](https://shd101wyy.github.io/markdown-preview-enhanced/#/code-chunk) feature of [Markdown Preview Enhanced (MPE)](https://shd101wyy.github.io/markdown-preview-enhanced), an extension for [Visual Studio Code (VS Code)](https://code.visualstudio.com). `pikfit` is a bash script that wraps `pikchr` or `dpic` output in a `<figure>` tag. You can also use [gnuplot](http://www.gnuplot.info) as a wrapped command.

```tcl {cmd=env args=[pikfit -H 8lh --caption "Flow diagram of pikfit" --dothide] output=html .hide}
arrow " md" ljust down 1.5cm; A: box "MPE" "(VS Code)";
move right from A.e; B: box "pikfit" "(bash)" fill lightyellow;
move right from B.e; C: box "pikchr" "dpic";
move up 0.75cm from B.n; D: box height 0.6cm "m4"
arrow from A.s down " html" ljust;
#
arrow right from 1/2 <A.e, A.ne> "pic" "m4";
arrow right from 1/2 <B.e, B.ne> "pic" above;
arrow left from 1/2 <C.w, C.sw> "svg" below;
arrow left from 1/2 <B.w, B.sw> "html" below;
arrow up 0.75cm from 1/2 <B.nw, B.n> "m4 " rjust;
arrow down 0.75cm from 1/2 <D.s, D.se> " pic" ljust;
```

## Requirements

`pikfit` works on Windows, macOS, and Linux. You need an environment where you can:

* run bash scripts using the `env` command

    On Windows, you can run the scripts in the [Git for Windows](https://gitforwindows.org) ([MSYS2](https://www.msys2.org)) environment. The Windows command search path (`Path`) must include the directory where `env.exe` is located, such as `C:\opt\PortableGit\usr\bin`.

* run the code chunks of MPE in VS Code

    In the VS Code settings, `Markdown-preview-enhanced: Enable Script Execution` must be selected; it is not selected by default.

* run the `pikchr` or `dpic` command

    On Windows, you can copy `pikchr.exe` from [the binary package of pikchr](https://packages.msys2.org/base/mingw-w64-pikchr) to `/usr/bin` in the Git for Windows environment. You can copy `dpic.exe` from [here](https://ece.uwaterloo.ca/~aplevich/dpic/Windows).
    On macOS, you may have to build `pikchr` from source. You can install `dpic` with [Homebrew](https://formulae.brew.sh/formula/dpic).

* run the `m4` command if you use macros

    On Windows, you can copy `m4.exe` from [the binary package of m4](https://packages.msys2.org/base/m4) to `/usr/bin` in the Git for Windows environment or from [here](https://ece.uwaterloo.ca/~aplevich/dpic/Windows).

## Installation

Copy the `pikfit` file to an installation directory and give execute permission to it. For example, if the installation directory is `$HOME/bin`, run the following on the command line.

```console
$ cp pikfit ~/bin
$ chmod +x ~/bin/pikfit
```

The installation directory, such as `$HOME/bin` or `/usr/local/bin`, must be included in the shell command search path (`PATH`). On Windows, you must add the installation directory, such as `%USERPROFILE%\bin` or `C:\opt\PortableGit\usr\local\bin`, to the Windows command search path (`Path`). The value of `Path` will then be included in the shell command search path (`PATH`).

## Usage

Open a Markdown document in VS Code. Write and run MPE code chunks calling `pikfit`.

### Writing a code chunk

In the options of a code chunk:

* Set the syntax highlighting language to `tcl` (which has relatively similar syntax to the pic language) as needed
* Set `cmd` to `env`
* Set `args` to `pikfit` and its options
* Set `output` to `html`

In the following example, the option `-H 3lh` for `pikfit` is added to `args` to set the figure height to three times the line height.

````markdown
```tcl {cmd=env args=[pikfit -H 3lh] output=html}
line; box "Hello!"; arrow; # pic code here
```
````

### Running the code chunk

Preview the document with `Open Preview to the Side` in VS Code. Run the code chunk with `Run Code Chunk` ( <kbd>▶︎</kbd> button) or `Run All Code Chunks` ( <kbd>ALL</kbd> button).

## Examples

### Width and height

By default, `pikfit` draws figures at full width with `pikchr` and at original size with `dpic`. Specifying `-W`*`WIDTH`* or `-H`*`HEIGHT`* changes the figure size. You can use CSS (Cascading Style Sheets) units, such as `%`, `em`, and `lh`, for the width and height values.

```tcl {cmd=env args=[pikfit -W 10em -H 5lh] output=html}
# {cmd=env args=[pikfit -W 10em -H 5lh] output=html}
line; box "Hello!"; arrow;
```

Extra spaces around the figure may be added to keep its aspect ratio if you specify both the width and height.

### Alignment

If a figure is narrower than the full width, you can align the figure with the `-A`*`ALIGN`* option, such as `-A R` to align right. You can use `L` for left, `C` for center, and `R` for right.

```tcl {cmd=env args=[pikfit -H 3lh -A L] output=html}
# {cmd=env args=[pikfit -H 3lh -A L] output=html}
line; box "Hello!"; arrow;
```

### Caption

You can set a caption to a figure with `--caption`*`TEXT`*. Specifying `--caption-wrap` wraps caption text to fit the figure width, which must be specified with `-W`*`WIDTH`*. The `--caption-align`*`ALIGN`* and `--caption-text-align`*`ALIGN`* options allow you to align the caption and its text. Specifying `--caption-top` puts the caption above the figure.

```tcl {cmd=env args=[pikfit -W 16em -A R --caption "Simple example" --caption-wrap --caption-align C] output=html}
# {cmd=env args=[pikfit -W 16em -A R --caption "Simple example" --caption-wrap --caption-align C] output=html}
line; box "Hello!"; arrow;
```

### dpic

You can use `dpic` as a pic engine with `--dpic`. The code below uses [Circuit_macros](https://ece.uwaterloo.ca/~aplevich/Circuit_macros/). Specifying `--m4-args`*`ARGS`* preprocesses the code with the specified `m4` arguments and `--enclose` adds `.PS` and `.PE` before and after the code.

```tcl {cmd=env args=[pikfit -H 5lh --dpic --m4-args "-I /Library/TeX/Documentation/texmf-dist-doc/latex/circuit-macros svg.m4 pgf.m4" --enclose] output=html}
# {cmd=env args=[pikfit -H 5lh --dpic --m4-args "-I /Library/TeX/Documentation/texmf-dist-doc/latex/circuit-macros svg.m4 pgf.m4" --enclose] output=html}
svg_font(style="font-family:Times;font-style:italic;")
cct_init; elen = 0.75;
V: battery(up_ elen,2); llabel(,"V`'svg_sub(0)","+"); corner;
lswitch(right_ elen); corner;
lamp(down_ elen,,shaded "yellow"); corner;
line to V.s; corner;
move left 0.3 from V.w # manually expand bbox to the left for text V_0
```

### gnuplot

You can use `gnuplot` as a wrapped command with `--gnuplot`. Specifying `--term-opts`*`OPTS`* sets the terminal options of `gnuplot`.

```tcl {cmd=env args=[pikfit -H 10lh --gnuplot --term-opts='font "Times" fontscale 2'] output=html}
# {cmd=env args=[pikfit -H 10lh --gnuplot --term-opts='font "Times" fontscale 2'] output=html}
unset key
set tic out nomirror
plot sin(x)
```

### File importing

You can include and execute a file written in the pic language with `@import` of MPE.

```markdown
@import "fig.pikchr" {as=tcl cmd=env args=[pikfit] output=html}
```

## Options

`-o PREFIX`
: Set the output directory/file (without extension) to *`PREFIX`*. This option saves output to an SVG file when `-A N` is used, or to an HTML file otherwise.

`-A {L|C|R|N}`
: Set the horizontal alignment of a figure. You can use the following values: `L` Left, `C` Center, `R` Right, and `N` No alignment. The default value is `C`.

`-C CLASS`
: Set the class name of a figure to *`CLASS`*. The default value is `pikfit`.

`-H HEIGHT`
: Set the height of a figure to *`HEIGHT`*. The value `0` means `auto` for `pikchr` and the original height for `dpic`. The default value is `0`.

`-K`
: Keep intermediate files.

`-S STYLE`
: Add style to svg tag.

`-W WIDTH`
: Set the width of a figure to *`WIDTH`*. The value `0` means the full width for `pikchr` and the original width for `dpic`. The default value is `0`.

`--alt TEXT`
: Set the alternative text of a figure to *`TEXT`*. The value `-` means caption text. The default value is `-`.

`--caption CAPTION`
: Set the caption of a figure to *`CAPTION`*. The default value is an empty string (no caption).

`--caption-alignment {L|C|R|-}`
: Set caption alignment. You can use the following values: `L` Left, `C` Center, `R` Right, and `-` figure alignment. The default value is `-`.

`--caption-text-alignment {L|C|R|-}`
: Set caption text alignment. You can use the following values: `L` Left, `C` Center, `R` Right, and `-` caption alignment. The default value is `-`.

`--caption-top`
: Put a caption on the top of a figure.

`--caption-wrap`
: Wrap caption text.

`--cmd PATH`
: Use `pikchr` or `dpic` located in *`PATH`* for a specific version.

`--dothide`
: Define the hide class (`.hide`), which is used to avoid [the MPE issue of the code chunk hide option](https://github.com/shd101wyy/vscode-markdown-preview-enhanced/issues/1893).

`--m4`
: Preprocess code with `m4`.

`--m4-args ARGS`
: Set arguments for `m4` to *`ARGS`*. This option implies `--m4`.

`--pikchr`
: Use `pikchr` as a pic engine (default). This option resets the previous setting by `--cmd`.

`-M MARGIN`
: Add a margin *`MARGIN`* to a `pikchr` figure.

`--dpic`
: Use `dpic` as a pic engine. This option resets the previous setting by `--cmd`.

`--enclose`
: Add `.PS` and `.PE` before and after the code of `dpic`.

`--gnuplot`
: Use `gnuplot` in place of a pic engine. This option resets the previous setting by `--cmd`.

`--term-opts OPTS`
: Set terminal options for SVG output of `gnuplot`.

`--`
: Option-end delimiter. Arguments after `--` are passed to the wrapped command.

Additionally, the following options are available if specified as the first argument: `-h`, `--help` (show usage and exit), `-v`, `--version` (show version information and exit), and `-n`, `--dry-run` (do nothing and exit).

Other options are passed to the wrapped command. For this behavior, short options cannot be combined (use `-K -A R` instead of `-KA R`, for example). Also, a short option and its argument must be separated by spaces (use `-A R` instead of `-AR`, for example).

## Environment variables

You can set the environment variables below in the initialization file of your login shell, such as `~/.bash_profile`. On Windows, you must set the variables in the Windows environment variables.

`PIKFIT_OPTS`
: Set default options for `pikfit`.

`PIKFIT_ERR_BG_COL`
: Set the background color of the standard error (error messages from `pikchr` or `dpic`).

`PIKFIT_M4`
: Set arguments for `m4`.

## Copyright and license

(c) 2026 aelata

This software is licensed under the MIT No attribution (MIT-0) License. However, this License does not apply to any files with the .html or .js extension.
[https://opensource.org/license/mit-0](https://opensource.org/license/mit-0)

---
