class Maintainer < ApplicationRecord
  include Identity

  belongs_to :package
end
