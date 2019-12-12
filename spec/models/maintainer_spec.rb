require 'rails_helper'


RSpec.describe Maintainer, type: :model do
  # TODO: move these tests to concerns
  describe '#construct_list_from_string' do
    it "parses single maintainer" do
      maintainers = Maintainer.construct_list_from_string("Scott Fortmann-Roe <scottfr@berkeley.edu>")
      expect([Maintainer.new(name: "Scott Fortmann-Roe", email: "scottfr@berkeley.edu")].to_json).to eq(maintainers.to_json)
    end
  end

end
