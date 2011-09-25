# Maldini #

Maldini is a [Nesta plugin][nestaplug] allowing citations and bibliographies to be automatically generated from [BibTeX][bibtex] files. It is intended to streamline the workflow of those who write content both in [LaTeX][latex] and for the web.  It is also intended to make [Nesta][nesta] the tool of choice for academic websites. For more on the idea behind Maldini, see the Maldini [project homepage][maldiniproject].

## Installation ##

Maldini is presently in pre-release development. The first official release, of version 0.0.1, will occur only when a `gem` is released to [rubygems.org][rubygems.org]. For now, the development version of Maldini may be installed by adding the following line to the Gemfile of your Nesta site:

    gem 'nesta-plugin-maldini', :git => 'git://github.com/etc/nesta-plugin-maldini.git'

For guidelines for working with Nesta plugin sources, see the [Nesta plugin][nestaplug] documentation.

## Usage ##

Maldini provides a syntax modeled on (a very small subset of) the syntax provided by [biblatex][biblatex] (it is basically a wrapper for [bibtex-ruby][bruby], which looks after the hard work of parsing the BibTeX file). The Maldini [project homepage][maldiniproject] is itself an example of how to employ Maldini. The source from which it is generated can be browsed [here][src], and the BibTeX file it employs can be browsed [here][maldinibib]. More detailed information can be found in the Maldini [YARD Documentation][maldiniyard], which is automatically generated every time the Maldini sources are updated.

## ACKNOWLEDGEMENTS ##

- [Graham Ashton][ashton] for the lovely [Nesta][nesta].
- [Sylvester Keil][keil] for the excellent [bibtex-ruby][bruby] and [citeproc-ruby][cruby] packages.
- Philipp Lehman for the indispensable [biblatex][biblatex].

## VERSION HISTORY ##

### 0.0.1 ###

- Initial skeleton release.
- Supported features:
  - Correctly parses LaTeX code in field data
  - Sorts reference list by surname, then first name, then year
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

- Better treatment of cases where a bibliography contains authors with the same last name with multiple publications in a single year. Default behaviour should be to incrementally append a lowercase letter to the `year` field (Name, 2001a; Name, 2001b).
- [Heroku][heroku] deployments do not like bibliographies stored in the Nesta `attachments` directory.

### Milestones ###

#### 0.0.1 ####

- Automate testing with [RSpec][rspec] or something similar.

#### 0.0.2 ####

- Add support for DOI field, formatting as URI *iff* there is no URL field.
- Provide methods for citing page or section numbers, modeled on [biblatex][biblatex] syntax.
- Provide methods for simultaneously citing multiple entries, modeled on [biblatex][biblatex] syntax.

#### 0.1 ####

- Create [BibDesk][bibdesk] template for copying entries as Maldini citations.
- Allow bibliography file to be specified in custom Nesta metadata.
- Generate HTML marked up with identifiers to permit:
  - Customised styling of citations and (especially) reference lists.
  - Hyperlinks to references. 
  - Citation tooltips displaying the complete reference.
- Add support for entry notes, including notes that include [biblatex][biblatex] citations to other entries.

#### 1.0 ####

- Find a way to embed citations directly in Markdown pages, perhaps by totally re-engineering everything to utilise the [citation processing][citepandoc] implemented by [Pandoc][pandoc].
- Allow BibTeX file to be sourced directly from a [GitHub][github] repository, perhaps by accessing it through [libgit2][].
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
[bibdesk]: http://bibdesk.sourceforge.net/
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
[heroku]: http://www.heroku.com/
[keil]: http://sylvester.keil.or.at/
[latex]: http://www.latex-project.org/
[libgit2]: http://libgit2.github.com/
[maldinibib]: https://github.com/etc/bweslake/blob/master/content/attachments/maldini.bib
[maldiniproject]: http://bweslake.org/research/resources/maldini
[maldiniyard]: http://rubydoc.info/github/etc/nesta-plugin-maldini/master/frames
[nestaplug]: http://nestacms.com/docs/plugins
[nesta]: http://nestacms.com
[pandoc]: http://johnmacfarlane.net/pandoc/index.html
[redcarpet]: https://github.com/tanoku/redcarpet
[rspec]: http://rspec.info/
[rubygems.org]: http://rubygems.org
[smarty]: http://daringfireball.net/projects/smartypants/
[src]: https://github.com/etc/bweslake/blob/master/content/pages/research/resources/maldini.haml

