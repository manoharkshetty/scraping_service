require 'rails_helper'

describe PackageScraper do
  it 'scrapes the packages name and versions' do
    p = PackageScraper.new
    res = p.get_package_list
    expect(res).not_to be_empty
    expect(res.length).to eq(PACKAGE_MAX_LENGTH)
  end
end