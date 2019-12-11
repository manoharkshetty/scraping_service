require 'rails_helper'

RSpec.describe Author, type: :model do
  describe '#from_string' do
    it "parses single author" do
      authors = Author.from_string("Scott Fortmann-Roe <scottfr@berkeley.edu>")
      expect([Author.new(name: "Scott Fortmann-Roe", email: "scottfr@berkeley.edu")].to_json).to eq(authors.to_json)
    end

    it "parses single author name" do
      authors = Author.from_string("Scott Fortmann-Roe")
      expect([Author.new(name: "Scott Fortmann-Roe")].to_json).to eq(authors.to_json)
    end

    it "parses multiple names" do
      authors = Author.from_string("George Vega Yon [aut, cre], Enyelbert Muñoz [ctb]")
      expect([Author.new(name: "George Vega Yon [aut, cre]"), Author.new(name: "Enyelbert Muñoz [ctb]")].to_json).to eq(authors.to_json)
    end


    it "parses multiple names with email" do
      authors = Author.from_string("George Vega Yon [aut, cre]<scottfr@berkeley.edu>, Enyelbert Muñoz [ctb]")
      expect([Author.new(name: "George Vega Yon [aut, cre]", email: "scottfr@berkeley.edu"), Author.new(name: "Enyelbert Muñoz [ctb]")].to_json).to eq(authors.to_json)
    end

    it "parses multiple names with email" do
      authors = Author.from_string("Zongjun Liu [aut], Chun-Hao Yang [aut], John Burkardt [ctb], Samuel W.K. Wong [aut, cre]")
      expected = [
          Author.new(name: "Zongjun Liu [aut]"),
          Author.new(name: "Chun-Hao Yang [aut]"),
          Author.new(name: "John Burkardt [ctb]"),
          Author.new(name: "Samuel W.K. Wong [aut, cre]")
      ]
      expect(authors.to_json).to eq(expected.to_json)
    end
  end
end
