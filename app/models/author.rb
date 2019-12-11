class Author < ApplicationRecord

  def self.from_string(author_string)
    if author_string.include?("[")
      delimiters = [/(?<=\>),\s/, /(?<=\]),\s/]
      authors = author_string.split(Regexp.union(delimiters))
    else
      authors = author_string.split(",")
    end
    return [] unless authors
    authors.map do |author|
      email = author[/.*<([^>]*)/,1]
      name = author.split("<").first.strip
      Author.new(name: name, email: email)
    end
  end
end
