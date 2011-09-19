# Maldini #

Maldini is a [Nesta plugin][nestaplug] allowing citations and bibliographies to be automatically generated from a [BibTeX][bibtex] file. Maldini provides a syntax modeled on (a very small subset of) the syntax provided by [biblatex][biblatex].  Maldini is basically a wrapper for [bibtex-ruby][bruby], which looks after the hard work of parsing the BibTeX file.

Maldini is intended to streamline the workflow of those who write content both in [LaTeX][latex] and for the web.  It is also intended to make [Nesta][nesta] the tool of choice for academic websites.

## Installation ##

*Coming soon*. For now, see the [Nesta plugin][nestaplug] documentation.

## Usage ##

*Coming soon*.

## ACKNOWLEDGEMENTS ##

- [Graham Ashton][ashton] for the lovely [Nesta][nesta].
- [Sylvester Keil][keil] for the excellent [bibtex-ruby][bruby] and [citeproc-ruby][cruby] packages.
- Philipp Lehman for the indispensable [biblatex][biblatex].

## VERSION HISTORY ##

*Note*: Maldini is currently in pre-release development.  The first official release, of version 0.0.1, will occur only when a `gem` is released to [rubygems.org][rubygems.org].

### 0.0.1 ###

- Initial skeleton release.
- `Nesta::Plugin::Maldini::Bibliography` public methods:
  - `open()`
  - `textcite()`
  - `citeauthor()`
  - `parencite()`
  - `fullcite()`
  - `printbibliography()`
- Supported entry types:
  - `article`
  - `book`
  - `inbook`
  - `incollection`
  - `inproceedings`
- Unsupported entry types:
  - `unpublished`
  - `phdthesis`

## TODO ##

- Minor issues are flagged method by method in the source with "TODO".

### Known Issues ###

- Improve handling of various dashes in `pages` field. The best way to do this is probably to defer it to the [Haml][haml] processor, which [should][hamlredcarpet] in any case be using a [SmartyPants][smarty]-enabled processor such as [Redcarpet][redcarpet]. But it doesn't yet.
- Better treatment of cases where a bibliography contains an author with multiple publications in a single year. Default behaviour should be to incrementally append a lowercase letter to the `year` field (Author, 2001a; Author, 2001b).
- Reference list should be sorted alphabetically by default.

### Wishlist ###

- Generate HTML marked up with identifiers to permit customised styling of citations and (especially) reference lists.
- Find a way to embed citations directly in Markdown pages, perhaps by totally re-engineering everything to utilise the [citation processing][citepandoc] implemented by [Pandoc][pandoc].
- Provide methods for citing page or section numbers, modeled on [biblatex][biblatex] syntax.
- Provide methods for simultaneously citing multiple entries.
- Add support for entry notes, including notes that include [biblatex][biblatex] citations to other entries.
- Add support for DOI field, formatting as URI *iff* there is no URL field.
- Automate testing with [RSpec][rspec] or something similar.
- Allow BibTeX file to be sourced directly from a [GitHub][github] repository.
- Implement option to format citations in any format specified in [Citation Style Language][csl], by wrapping [citeproc-ruby][cruby].
- Add support for [Biber][biber].

## AUTHOR ##

Maldini is an existence proof that a total amateur can easily build a useful Nesta plugin.  For comments and suggestions, please contact [the author][brad].

## LICENSE ##

Copyright © 2011 Brad Weslake.

    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to deal
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is
    furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in
    all copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
    THE SOFTWARE.

[ashton]: http://www.zerply.com/profile/grahamashton
[biber]: http://biblatex-biber.sourceforge.net/
[biblatex]: http://ctan.math.utah.edu/ctan/tex-archive/help/Catalogue/entries/biblatex.html
[bibtex]: http://www.ctan.org/pkg/bibtex
[brad]: http://bweslake.org/
[bruby]: http://inukshuk.github.com/bibtex-ruby/
[citepandoc]: http://johnmacfarlane.net/pandoc/README.html#citations
[cruby]: https://github.com/inukshuk/citeproc-ruby
[csl]: http://citationstyles.org/
[github]: http://github.com/
[hamlredcarpet]: https://github.com/nex3/haml/pull/383
[haml]: http://haml-lang.com/
[keil]: http://sylvester.keil.or.at/
[latex]: http://www.latex-project.org/
[nestaplug]: nestacms.com/docs/plugins/
[nesta]: http://nestacms.com/
[pandoc]: http://johnmacfarlane.net/pandoc/index.html
[redcarpet]: https://github.com/tanoku/redcarpet
[rspec]: http://rspec.info/
[smarty]: http://daringfireball.net/projects/smartypants/

[rubygems.org]: rubygems.org
