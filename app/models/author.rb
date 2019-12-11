class Author < ApplicationRecord
  include Identity
  belongs_to :package
end
