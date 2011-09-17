require 'bibtex'

module Nesta
  module Plugin
    module Maldini
      module Helpers
        # Define helper methods.
      end # module Helpers

      class Bibliography

        # INITIALIZATION
        def initialize(file = nil)
          # USAGE:  Nesta::Plugin::Maldini::Bibliography.new('file')
          #         'file' is optional

          # Initialise instance variables
          @thebibliography = nil
          @theentry = nil

          # Open file, if such there be
          if (file != nil)
            self.open(file)
          end # if (file != nil)
        end # def initialize

        # FILES
        # TODO:
        # - Set default file to '/attachments/bibliography.bib'
        # - Allow file to be opened as an argument to Bibliography.new()

        def open(file)
          # USAGE: open('file')
          # 'file' is ordinarily a URI specifying the address of a .bib file formatted as BibTeX
          
          # TODO: Something smart if file cannot be opened.
          @thebibliography = BibTeX.open(file)
        end # def open

        # CITATIONS
        # The syntax is modeled on biblatex
        # See: http://goo.gl/UYoCY
        # TODO:
        # - Add starred versions, eg. textcite*(citekey), which suppress author names.

        def textcite(citekey)
          # USAGE: textcite('citationkey')
          # Modeled on biblatex command \textcite{citationkey}

          # Assign an entry based on the citation key we have been passed.
          # TODO: Something smart if lookup fails.
          @theentry = @thebibliography[citekey.to_sym]

          # @theentry[:author] returns an array of names.
          # TODO: Display more than one surname, if such there be.
          citestring = @theentry[:author][0].last + " (" + @theentry[:year].to_s + ")"
          return citestring
        end # def textcite 

        def parencite(citekey)
        # USAGE: parencite('citationkey')
        # Modeled on biblatex command \parencite{citationkey}
        end # def parencite

        # REFERENCE LISTS
        
      end # class Bibliography    
    end # module Maldini
  end # module Plugin

  class App
    helpers Nesta::Plugin::Maldini::Helpers
  end # class App
end # module Nesta
