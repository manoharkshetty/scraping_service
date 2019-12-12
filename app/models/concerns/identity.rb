module Identity
  extend ActiveSupport::Concern

  module ClassMethods
    def construct_list_from_string(identity_string)
      if identity_string.include?("[")
        delimiters = [/(?<=\>),\s/, /(?<=\]),\s/]
        identities = identity_string.split(Regexp.union(delimiters))
      else
        identities = identity_string.split(",")
      end
      return [] unless identities
      identities.map do |identity|
        email = identity[/.*<([^>]*)/,1]
        name = identity.split("<").first.strip
        self.new(name: name, email: email)
      end
    end

  end

end