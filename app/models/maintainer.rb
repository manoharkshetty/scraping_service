class Maintainer < ApplicationRecord
  def self.from_string(maintainer_string)
    if maintainer_string.include?("[")
      m = maintainer_string.match /(.+),\s(.+)/
      maintainers = m[1..-1]
    else
      maintainers = maintainer_string.split(",")
    end
    return [] unless maintainers
    maintainers.map do |maintainer|
      email = maintainer[/.*<([^>]*)/,1]
      name = maintainer.split("<").first.strip
      Maintainer.new(name: name, email: email)
    end
  end
end
