# frozen_string_literal: true
# typed: strict

# Extract & re-add directives to a docstring
module YARDSorbet::Directives
  def self.extract_directives(docstring)
    parser = YARD::DocstringParser.new.parse(docstring)
    # Directives are already parsed at this point, and there doesn't
    # seem to be an API to tweeze them from one node to another without
    # managing YARD internal state. Instead, we just extract them from
    # the raw text and re-attach them.
    directives = parser.raw_text&.split("\n")&.select do |line|
      line.start_with?('@!')
    end || []

    [parser.to_docstring, directives]
  end

  def self.add_directives(docstring, directives)
    directives.each do |directive|
      docstring.concat("\n#{directive}")
    end
  end
end
