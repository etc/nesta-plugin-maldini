# encoding: UTF-8

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
        # - 'file' is optional
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

        # USAGE: nocite('citationkey')
        # - Modeled on biblatex command \nocite{citationkey}
        # - nocite('*') is a special case, which cites every entry in the bibliography
        def nocite(citekey) 
          citestring = ""
          if citekey == '*'
            @thebibliography.entries.each_value { |entry|
              addentry(entry.key)
            }
          else
            theentry = addentry(citekey)
            citestring  << "**Maldini: Invalid Citation Key `" << citekey << "`**" if theentry == nil
          end
          return citestring
        end # def nocite

        # USAGE: textcite('citationkey', 'postnote', 'prenote')
        # - 'prenote' and 'postnote' are both optional
        # - Modeled on biblatex command \textcite[prenote][postnote]{citationkey}
        def textcite(citekey, postnote="", prenote="")
          citestring = ""
          theentry=addentry(citekey)
          if theentry == nil
            citestring << "**Maldini: Invalid Citation Key** `" << citekey << "`**"
          else
            citestring << prenote << " " unless prenote == ""
            citestring << formatauthors(theentry[:author]) << " (" << theentry[:year].to_s
            citestring << ", " << postnote unless postnote == ""
            citestring << ")"
          end # if
          citestring = "**Maldini: Invalid encoding in entry `" << citekey << "`**" unless citestring.force_encoding("UTF-8").valid_encoding?
          return citestring
        end # def textcite 

        # USAGE: citeauthor('citationkey', 'postnote', 'prenote')
        # - 'prenote' and 'postnote' are both optional
        # - Modeled on biblatex command \citeauthor[prenote][postnote]{citationkey}
        def citeauthor(citekey, postnote="", prenote="")

          # We don't keep track of entries cited this way for displaying in the bibliography,
          # so it may make sense to give a warning if this is called for an entry that is not
          # already in @theentries

          # Assign an entry based on the citation key we have been passed.
          # TODO: Something smart if lookup fails.
          theentry = @thebibliography[citekey.to_sym]

          if theentry == nil
            citestring << "**Maldini: Invalid Citation Key**"
          else
            # Format page numbers
            theentry[:pages] = theentry[:pages].gsub(/(\d+)(-+)(\d+)/,'\\1&ndash;\\3') if theentry.has_field?(:pages)

            citestring = ""
            citestring << prenote << " " unless prenote == ""
            citestring << formatauthors(theentry[:author])
            citestring << ", " << postnote unless postnote == ""
          end # if
          citestring = "**Maldini: Invalid encoding in entry `" << citekey << "`**" unless citestring.force_encoding("UTF-8").valid_encoding?
          return citestring
        end # def citeauthor

        # USAGE: cite('citationkey', 'postnote', 'prenote')
        # - 'prenote' and 'postnote' are both optional
        # - Modeled on biblatex command \cite[prenote][postnote]{citationkey}
        def cite(citekey, postnote="", prenote="")
          citestring = ""
          theentry=addentry(citekey)
          if theentry == nil
            citestring << "**Maldini: Invalid Citation Key**"
          else
            citestring << prenote << " " unless prenote == ""
            citestring << formatauthors(theentry[:author]) << ", " << theentry[:year].to_s
            citestring << ", " << postnote unless postnote == ""
          end # if
          citestring = "**Maldini: Invalid encoding in entry `" << citekey << "`**" unless citestring.force_encoding("UTF-8").valid_encoding?
          return citestring
        end # def cite

        # USAGE: parencite('citationkey', 'postnote', 'prenote')
        # - 'prenote' and 'postnote' are both optional
        # - Modeled on biblatex command \parencite[prenote][postnote]{citationkey}
        def parencite(citekey, postnote="", prenote="")
          citestring = "("
          citestring << cite(citekey, postnote, prenote)
          citestring << ")"
          return citestring
        end # def parencite

        # USAGE: fullcite('citationkey', 'postnote', 'prenote')
        # - 'prenote' and 'postnote' are both optional
        # - Modeled on biblatex command \fullcite[prenote][postnote]{citationkey}
        def fullcite(citekey, postnote="", prenote="")
          citestring = ""
          theentry=addentry(citekey)
          if theentry == nil
            citestring << "**Maldini: Invalid Citation Key**"
          else
            citestring << prenote << " " unless prenote == ""
            citestring << formatentry(theentry)
            citestring << ", " << postnote unless postnote == ""
          end # if
          citestring = "**Maldini: Invalid encoding in entry `" << citekey << "`**" unless citestring.force_encoding("UTF-8").valid_encoding?
          return citestring
        end
        
        # @group REFERENCE LISTS

        # USAGE: printbibliography()
        # - Modeled on biblatex command \printbibliography        
        def printbibliography()
          # Sort by last name first, first name second, year third
          @theentries.sort_by!{ |e| [
            e.has_field?(:author) ? 1 : 0,
            e.has_field?(:author) ? e[:author].each { |a| (a.last && a.first) ? a.last + a.first : a.last || ""} : "",
            e.has_field?(:year) ? e[:year].to_i : 0
          ] }
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
          # BibTeX::Entry[:author] returns an array of BibTeX::Names, so this is what we have here.
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
            entrystring << " " << entry[:year].to_s << ". “" << entry[:title].to_s + "”, in *" << entry[:journal].to_s << "*"
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
            entrystring << " " << entry[:year].to_s << ". “" << entry[:title].to_s + "”, in "
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

            entrystring << entry[:author].to_s 
            entrystring << "." if entrystring[-1] != "."
            entrystring << " " << entry[:year].to_s << ". “" << entry[:title].to_s + "”, in "
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
            entrystring << entry[:author].to_s 
            entrystring << "." if entrystring[-1] != "."
            entrystring << " " << entry[:year].to_s << ". “" << entry[:title].to_s + "”, in "
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
            entrystring << "**Maldini: Unsupported entry type `" << entry.type.to_s << "`**"

          # UNPUBLISHED
          elsif entry.type == :unpublished
            # REQUIRED_FIELDS: :unpublished => [:author,:title,:note]
            entrystring << entry[:author].to_s
            entrystring << "." if entrystring[-1] != "."
            entrystring << " " << entry[:year].to_s << ". “" << entry[:title].to_s + "”"
            entrystring << ", " << Date::MONTHNAMES[BibTeX::Entry::MONTHS.index(entry[:month].to_sym)+1] if entry.has_field?(:month)
            entrystring << ". " << entry[:note].to_s if entry.has_field?(:note)
            entrystring << "." if entrystring[-1] != "."
            entrystring << " URI: [" << entry[:url].to_s << "](" << entry[:url].to_s << ")" if entry.has_field?(:url)
            # entrystring << "  \nFields: " << entry.fields.to_s
            
          # PROCEEDINGS
          elsif entry.type == :proceedings
            # REQUIRED_FIELDS: :proceedings => [:title,:year]
            #
            # TODO:
            # - Write this method.
            entrystring << "**Maldini: Unsupported entry type `" << entry.type.to_s << "`**"

          # OTHER
          else
            entrystring << "**Maldini: Unsupported entry type `" << entry.type.to_s << "`**"
          end # if

          entrystring = "**Maldini: Invalid encoding in entry `" << entry.key.to_s << "`**" unless entrystring.force_encoding("UTF-8").valid_encoding?
          
          return entrystring
        end #formatentry

        # @group UTILITIES

        # USAGE: addentry('citationkey')
        # - Preprocessing to keep track of our citations
        def addentry(citekey)
          theentry = @thebibliography[citekey.to_sym]
          if theentry == nil
            return nil
          else
            # Add to entries and preprocess if not already in our list
            if !@theentries.include?(theentry)
              @theentries << theentry 
              # Cross populate fields
              theentry.save_inherited_fields if theentry.has_parent?
              # Format page numbers
              theentry[:pages] = theentry[:pages].gsub(/(\d+)(-+)(\d+)/,'\\1&ndash;\\3') if theentry.has_field?(:pages)
            end # if
            return theentry
          end #if
        end # def addentry

      end # class Bibliography    
    end # module Maldini
  end # module Plugin

  class App
    helpers Nesta::Plugin::Maldini::Helpers
  end # class App

end # module Nesta
