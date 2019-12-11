require 'rails_helper'

describe PackageScraper do
  describe '#get_package_list' do
    it 'scrapes the packages name and versions' do
      res = PackageScraper.new.get_package_list(2)
      expect(res).not_to be_empty
      expect(res.length).to eq(2)
    end
  end

  describe '#get_package_list' do
    it 'scrapes the packages name and versions' do
      res = PackageScraper.new.scrape_package("A3", "1.0.0")
      expect(res).not_to eq(nil)
      expect(res[:package]).to eq("A3")
    end
  end

  describe '#get_package_list' do
    it 'scrapes the packages name and versions' do
      res = PackageScraper.new.send(:scrape_tar_file, "#{CRAN_BASE_PATH}/A3_1.0.0.tar.gz")
      expect(res).not_to eq(nil)
      expect(res["Package"]).to eq("A3")
    end
  end
end