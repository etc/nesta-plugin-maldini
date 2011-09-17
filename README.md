# Maldini #

Maldini is a [Nesta plugin][nestaplug] allowing citations and bibliographies to be automatically generated from a [BibTeX][bibtex] file. Maldini provides a syntax modeled on (a very small subset of) the syntax provided by [biblatex][biblatex].  Maldini is basically a wrapper for the excellent [bibtex-ruby][bruby] package by [Sylvester Keil][keil], which look after the hard work of parsing the BibTeX file.

Maldini is intended to streamline the workflow of those who write content both in [LaTeX][latex] and for the web.  It is also intended to make [Nesta][nesta] the tool of choice for academic websites.

Maldini is an existence proof that a total amateur can easily build a useful Nesta plugin.  For comments and suggestions, please contact [the author][brad].

## Installation ##

## Usage ##

## VERSION HISTORY ##

### 0.0.1 ###

- Initial skeleton release.

## TODO ##

- Allow BibTeX file to be sourced directly from a [GitHub][github] repository.
- Implement option to format citations in any format specified in [Citation Style Language][csl], by wrapping [citeproc-ruby][cruby]
- Add support for [Biber][biber]

## LICENSE ##

The Maldini plugin is distributed under an MIT license, as specified in file LICENSE.

[biber]: http://biblatex-biber.sourceforge.net/
[biblatex]: http://ctan.math.utah.edu/ctan/tex-archive/help/Catalogue/entries/biblatex.html
[bibtex]: http://www.ctan.org/pkg/bibtex
[brad]: http://bweslake.org/
[bruby]: http://inukshuk.github.com/bibtex-ruby/
[cruby]: https://github.com/inukshuk/citeproc-ruby
[csl]: http://citationstyles.org/
[github]: http://github.com/
[keil]: http://sylvester.keil.or.at/
[latex]: http://www.latex-project.org/
[nestaplug]: nestacms.com/docs/plugins/
[nesta]: http://nestacms.com/[1]: http://
