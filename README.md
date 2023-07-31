# Latex template

# Some latex things:

I have a bunch of weird stuff with my latex setup, mainly involving tikz.

- Tikz figures should occur in a `tikzarray` environment. Usage:

  ```latex
  \begin{tikzarray}[options (scale=1 etc)]{filename for figure}
        tikz code
  \end{tikzarray}
  ```

- You should enable `-shell-escape` when running pdflatex.

  - This externalizes the Tikz building and generates pdfs in the `figures` directory.
  - If a given figure exists, it isn't rebuilt. You can rebuild by deleting the pdf, prepending the file name with `:`, or changing the environment to `tikzarrayrm`

  ```latex
  \begin{tikzarray}[options (scale=1 etc)]{:filename for figure}
        tikz code
  \end{tikzarray}
  ```

  or

  ```latex
  \begin{tikzarrayrm}[options (scale=1 etc)]{filename for figure}
        tikz code
  \end{tikzarrayrm}
  ```

  - To remake all figures, you can delete all the pdfs, or setting `remakeall` at the top of the main file:

    ```
    \setboolean{remakeall}{true}
    ```

- All sections are included in the `sections` directory, and have

  ```latex
  % This line sets the project root file.
  % !TEX root = ../MainFileName.tex
  % !TeX spellcheck = en_US
  ```

  at the top, where `MainFileName`=`main`