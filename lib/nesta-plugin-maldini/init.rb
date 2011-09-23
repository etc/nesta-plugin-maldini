require 'bibtex'
require 'date'

module Nesta
  module Plugin
    module Maldini
      module Helpers
        # Define helper methods.
      end # module Helpers

      class Bibliography

        # @group INITIALIZATION

        # USAGE:  Nesta::Plugin::Maldini::Bibliography.new('file')
        #         'file' is optional
        def initialize(file = nil)
          # Initialise instance variables
          @thebibliography = nil
          @theentries = []

          # Open file, if such there be
          if (file != nil)
            self.open(file)
          end # if (file != nil)
        end # def initialize

        # @group FILES

        # TODO:
        # - Set default file to '/attachments/bibliography.bib'
        def open(file)
          # USAGE: open('file')
          # 'file' is ordinarily a URI specifying the address of a .bib file formatted as BibTeX
          
          # The :filter => :latex hash tells BibTeX to convert all strings to Unicode,
          # which among other things converts '--' to endashes and special characters to
          # their Unicode equivalents.  See: https://github.com/inukshuk/latex-decode
          #
          # TODO: Something smart if file cannot be opened.
          @thebibliography = BibTeX.open(file)
          @thebibliography.convert(:latex)
        end # def open

        # @group CITATIONS
        # The syntax of citations is modeled on biblatex
        # See: http://goo.gl/UYoCY
        #
        # NOTES
        # - Whenever a new entry is cited, it should be added to @theentries
        #
        # TODO:
        # - Add starred versions, eg. textcite*(citekey), which suppress author names.

        # USAGE: textcite('citationkey')
        # Modeled on biblatex command \textcite{citationkey}
        def textcite(citekey)

          # Assign an entry based on the citation key we have been passed.
          # TODO: Something smart if lookup fails.
          theentry = @thebibliography[citekey.to_sym]

          if theentry.has_field?(:crossref)
            # The thing to do here is to populate any fields present in parent but not child.
            # This is a hack for now.  See: https://github.com/inukshuk/bibtex-ruby/issues/22
            theentry = crosspopulate(theentry,@thebibliography[theentry[:crossref].to_sym])
          end # if

          # Format page numbers
          theentry[:pages] = theentry[:pages].gsub(/(\d+)(-+)(\d+)/,'\\1&ndash;\\3') if theentry.has_field?(:pages)

          # Add to entries if not already present
          @theentries << theentry if !@theentries.include?(theentry)

          # BibTeX::Entry[:author] returns an array of BibTeX::Names.
          theauthors = theentry[:author]
          citestring = formatauthors(theauthors) + " (" + theentry[:year].to_s + ")"
          return citestring
        end # def textcite 

        # USAGE: citeauthor('citationkey')
        # Modeled on biblatex command \citeauthor{citationkey}
        def citeauthor(citekey)

          # We don't keep track of entries cited this way for displaying in the bibliography,
          # so it may make sense to give a warning if this is called for an entry that is not
          # already in @theentries

          # Assign an entry based on the citation key we have been passed.
          # TODO: Something smart if lookup fails.
          theentry = @thebibliography[citekey.to_sym]

          if theentry.has_field?(:crossref)
            # The thing to do here is to populate any fields present in parent but not child.
            # This is a hack for now.  See: https://github.com/inukshuk/bibtex-ruby/issues/22
            theentry = crosspopulate(entry,@thebibliography[theentry[:crossref].to_sym])
          end # if

          # Format page numbers
          theentry[:pages] = theentry[:pages].gsub(/(\d+)(-+)(\d+)/,'\\1&ndash;\\3') if theentry.has_field?(:pages)

          # BibTeX::Entry[:author] returns an array of BibTeX::Names.
          theauthors = theentry[:author]
          citestring = formatauthors(theauthors)
          return citestring                            
        end # def citeauthor

        # USAGE: parencite('citationkey')
        # Modeled on biblatex command \parencite{citationkey}
        def parencite(citekey)
          
          # Assign an entry based on the citation key we have been passed.
          # TODO: Something smart if lookup fails.
          theentry = @thebibliography[citekey.to_sym]

          if theentry.has_field?(:crossref)
            # The thing to do here is to populate any fields present in parent but not child.
            # This is a hack for now.  See: https://github.com/inukshuk/bibtex-ruby/issues/22
            theentry = crosspopulate(entry,@thebibliography[theentry[:crossref].to_sym])
          end # if

          # Add to entries if not already present
          @theentries << theentry if !@theentries.include?(theentry)

          # BibTeX::Entry[:author] returns an array of BibTeX::Names.
          theauthors = theentry[:author]
          citestring = "(" + formatauthors(theauthors) + ", " + theentry[:year].to_s + ")"
          return citestring
        end # def parencite

        # USAGE: fullcite('citationkey')
        # Modeled on biblatex command \fullcite{citationkey}
        def fullcite(citekey)

          # Assign an entry based on the citation key we have been passed.
          # TODO: Something smart if lookup fails.
          theentry = @thebibliography[citekey.to_sym]

          if theentry.has_field?(:crossref)
            # The thing to do here is to populate any fields present in parent but not child.
            # This is a hack for now.  See: https://github.com/inukshuk/bibtex-ruby/issues/22
            theentry = crosspopulate(entry,@thebibliography[theentry[:crossref].to_sym])
          end # if

          # Format page numbers
          theentry[:pages] = theentry[:pages].gsub(/(\d+)(-+)(\d+)/,'\\1&ndash;\\3') if theentry.has_field?(:pages)

          # Add to entries if not already present
          @theentries << theentry if !@theentries.include?(theentry)

          citestring = formatentry(theentry)
          return citestring
        end
        
        # @group REFERENCE LISTS

        # USAGE: printbibliography()
        # Modeled on biblatex command \printbibliography        
        def printbibliography()

          # Sort by last name first, first name second, year third
          @theentries.sort_by!{ |e| [ e[:author][0].last, e[:author][0].first, e[:year] ] }
          bibliographystring = ""
          @theentries.each do |e|
              # TODO:
              # - Add SmartyPants processing here, with eg. rubypants, though once 
              #   Nesta depends on redcarpet >= 2.0.0 we can do SmartyPants processing with this:
              #     Redcarpet::Render::SmartyPants.render(formatentry(e))
              bibliographystring << "- " << formatentry(e) << ".  \n"
          end # each
          return bibliographystring
        end # def printbibliography

        # PROTECTED METHODS
        protected        

        # @group FORMATS

        # Returns last names in a format suitable for citations
        # TODO:
        # - There has to be a way to do this in a few elegant lines, but I am a hack  
        # - Implement this in a class extending BibTeX::Names
        def formatauthors(author)
          citestring = ""
          if (author.length > 0)
            citestring << author[0].prefix.to_s << " " unless author[0].prefix.nil?
            citestring << author[0].last
            if (author.length > 1)
              if (author.length > 2)
                author[1,author.length-2].each do |a|
                  citestring << ", "
                  citestring << a.prefix.to_s unless a.prefix.nil?
                  citestring << a.last
                end # each
              end # if
              citestring << " and "
              citestring << author[-1].prefix.to_s unless author[-1].prefix.nil?
              citestring << author[-1].last
            end # if
          else # ie. author.length < 0
            # TODO: Something smart here.
          end # if
          return citestring
        end # def formatauthors

        # USAGE: formatentry(BibTeX::Entry)        
        # The format here is presently tailored to my own preferences. Formats should eventually be configurable.
        # TODO:
        # - Implement option to format citations in any format specified in Citation Style Language,
        #   by wrapping citeproc-ruby.
        def formatentry(entry)
          entrystring = ""

          # REQUIRED_FIELDS are specified in BibTeX::Entry::REQUIRED_FIELDS
          # We assume these are all present.  All other fields we check before processing.

          # ARTICLE
          if entry.type == :article
            # REQUIRED_FIELDS: :article => [:author,:title,:journal,:year]
            entrystring << entry[:author].to_s
            entrystring << "." if entrystring[-1] != "."
            entrystring << " " << entry[:year].to_s << ". \"" << entry[:title].to_s + "\", in *" << entry[:journal].to_s << "*"
            entrystring << ", Vol. " << entry[:volume].to_s if entry.has_field?(:volume)
            entrystring << ", No. " << entry[:number].to_s if entry.has_field?(:number)
            entrystring << ", " << Date::MONTHNAMES[BibTeX::Entry::MONTHS.index(entry[:month].to_sym)+1] if entry.has_field?(:month)
            entrystring << ", pp. " << entry[:pages].to_s if entry.has_field?(:pages)
            entrystring << ". URI: [" << entry[:url].to_s << "](" << entry[:url].to_s << ")" if entry.has_field?(:url)
            # entrystring << "  \nFields: " << entry.fields.to_s

          # BOOK
          elsif entry.type == :book
            # REQUIRED_FIELDS: :book => [[:author,:editor],:title,:publisher,:year]
            
            if entry.has_field?(:author)
              entrystring << entry[:author].to_s
            elsif entry.has_field?(:editor)
              # TODO: Add (Ed) or (Eds) here
              entrystring << entry[:editor].to_s
            end
            entrystring << "." if entrystring[-1] != "."
            entrystring << " " << entry[:year].to_s << ". *" << entry[:title].to_s + "*"
            entrystring << ", " << entry[:publisher].to_s if entry.has_field?(:publisher)
            entrystring << ", " << entry[:address].to_s if entry.has_field?(:address)
            entrystring << ", Vol. " << entry[:volume].to_s if entry.has_field?(:volume)
            entrystring << ", No. " << entry[:number].to_s if entry.has_field?(:number)
            entrystring << ", " << Date::MONTHNAMES[BibTeX::Entry::MONTHS.index(entry[:month].to_sym)+1] if entry.has_field?(:month)
            entrystring << ". URI: [" << entry[:url].to_s << "](" << entry[:url].to_s << ")" if entry.has_field?(:url)
            # entrystring << "  \nFields: " << entry.fields.to_s
            
          # INBOOK
          elsif entry.type == :inbook
            # REQUIRED_FIELDS: :inbook => [[:author,:editor],:title,[:chapter,:pages],:publisher,:year]

            if entry.has_field?(:author)
              entrystring << entry[:author].to_s
            elsif entry.has_field?(:editor)
              # TODO: Add (Ed) or (Eds) here
              entrystring << entry[:editor].to_s
            end
            entrystring << "." if entrystring[-1] != "."
            entrystring << " " << entry[:year].to_s << ". \"" << entry[:title].to_s + "\", in "
            entrystring << "*" << entry[:booktitle].to_s << "*"
            entrystring << ", " << entry[:publisher].to_s if entry.has_field?(:publisher)
            entrystring << ", " << entry[:address].to_s if entry.has_field?(:address)
            entrystring << ", Vol. " << entry[:volume].to_s if entry.has_field?(:volume)
            entrystring << ", No. " << entry[:number].to_s if entry.has_field?(:number)
            entrystring << ", " << Date::MONTHNAMES[BibTeX::Entry::MONTHS.index(entry[:month].to_sym)+1] if entry.has_field?(:month)
            entrystring << ", pp. " << entry[:pages].to_s if entry.has_field?(:pages)
            entrystring << ". URI: [" << entry[:url].to_s << "](" << entry[:url].to_s << ")" if entry.has_field?(:url)

          # INCOLLECTION
          elsif entry.type == :incollection
            # REQUIRED_FIELDS: :incollection => [:author,:title,:booktitle,:publisher,:year]

            entrystring << entry[:author].to_s << ". " << entry[:year].to_s << ". \"" << entry[:title].to_s + "\", in "
            # TODO: Work out why entry[:editor].to_s has a weird hash in the middle, but entry[:author].to_s doesn't.
            #       Hint: It's related to BibTeX::Value::to_s()
            entrystring << formatauthors(entry[:editor]) << " (Ed), " if entry.has_field?(:editor)
            entrystring << "*" << entry[:booktitle].to_s << "*"
            entrystring << ", " << entry[:publisher].to_s if entry.has_field?(:publisher)
            entrystring << ", " << entry[:address].to_s if entry.has_field?(:address)
            entrystring << ", Vol. " << entry[:volume].to_s if entry.has_field?(:volume)
            entrystring << ", No. " << entry[:number].to_s if entry.has_field?(:number)
            entrystring << ", " << Date::MONTHNAMES[BibTeX::Entry::MONTHS.index(entry[:month].to_sym)+1] if entry.has_field?(:month)
            entrystring << ", pp. " << entry[:pages].to_s if entry.has_field?(:pages)
            entrystring << ". URI: [" << entry[:url].to_s << "](" << entry[:url].to_s << ")" if entry.has_field?(:url)

          # INPROCEEDINGS
          elsif entry.type == :inproceedings
            # REQUIRED_FIELDS: :inproceedings => [:author,:title,:booktitle,:year]
            entrystring << entry[:author].to_s << ". " << entry[:year].to_s << ". \"" << entry[:title].to_s + "\", in "
            # TODO: Work out why entry[:editor].to_s has a weird hash in the middle, but entry[:author].to_s doesn't.
            #       Hint: It's related to BibTeX::Value::to_s()
            entrystring << formatauthors(entry[:editor]) << " (Ed), " if entry.has_field?(:editor)
            entrystring << "*" << entry[:booktitle].to_s << "*"
            entrystring << ", " << entry[:publisher].to_s if entry.has_field?(:publisher)
            entrystring << ", " << entry[:address].to_s if entry.has_field?(:address)
            entrystring << ", Vol. " << entry[:volume].to_s if entry.has_field?(:volume)
            entrystring << ", No. " << entry[:number].to_s if entry.has_field?(:number)
            entrystring << ", " << Date::MONTHNAMES[BibTeX::Entry::MONTHS.index(entry[:month].to_sym)+1] if entry.has_field?(:month)
            entrystring << ", pp. " << entry[:pages].to_s if entry.has_field?(:pages)
            entrystring << ". URI: [" << entry[:url].to_s << "](" << entry[:url].to_s << ")" if entry.has_field?(:url)

          # PHDTHESIS
          elsif entry.type == :phdthesis
            # REQUIRED_FIELDS: :phdthesis => [:author,:title,:school,:year]
            #
            # TODO:
            # - Write this method.
            entrystring << "Maldini support for phdthesis coming soon"

          # UNPUBLISHED
          elsif entry.type == :unpublished
            # REQUIRED_FIELDS: :unpublished => [:author,:title,:note]
            #
            # TODO:
            # - Write this method.
            entrystring << "Maldini support for unpublished coming soon"

          # OTHER
          else
            # TODO: Something smart here.
          end # if
          return entrystring
        end #formatentry

        # @group UTILITIES
        
        # This is a hack for now.  See: https://github.com/inukshuk/bibtex-ruby/issues/22
        def crosspopulate(entry,parententry)
          parententry.fields.keys.each do |k|
            entry[k] = parententry[k] unless entry.has_field?(k)
          end # each
          return entry
        end # def crosspopulate
        
      end # class Bibliography    
    end # module Maldini
  end # module Plugin

  class App
    helpers Nesta::Plugin::Maldini::Helpers
  end # class App

end # module Nesta
