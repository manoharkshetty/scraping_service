require "rubygems"
require "treetop"
require_relative 'dcf_grammar'

module Dcf
  # @param [String] input
  # @return [Array, nil] An array of { attr => val } hashes or nil if failure
  def self.parse(input, size = 50)
    parse = DcfParser.new.parse(input)
    return if parse.nil?
    elements = parse.elements.first(size)
    elements.collect do |i|
      paragraph = {}
      i.paragraph.elements.each do |row|
        paragraph[row.field.attribute.text_value] = row.field.value.text_value
      end
      paragraph
    end
  end
end
