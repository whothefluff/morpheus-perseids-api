require_relative '../../../../converter'

class Parser
  class Word
    class Entry
      class DictionaryEntry
        class Sublemma
          def initialize(doc)
            @language = doc['xml:lang']
            @content = Converter.latin_headword(doc.inner_html)
          end

          def bamboo_xml
            @bamboo_xml ||= %(<sublemma xml:lang="#{language}">#{content}</sublemma>)
          end

          def bamboo_json
            @bamboo_json ||= {
              sublemma: {
                lang: language,
                '$': content,
              },
            }
          end

          private

          attr_reader :language, :content
        end
      end
    end
  end
end
