require 'nokogiri'
require 'rubygems/package'
require 'scraper/dcf'
require 'down'

DESCRIPTION_FILE_PATH = "DESCRIPTION"
CRAN_BASE_PATH = "http://cran.r-project.org/src/contrib"
FILE_MAX_READ_SIZE = 20 * 1024

class PackageScraper

  def scrape_package(package_name, version)
    package = scrape_tar_file("#{CRAN_BASE_PATH}/#{package_name}_#{version}.tar.gz")
    return nil unless package
    package.deep_transform_keys!{ |key| key.downcase.to_sym }
  end

  def get_package_list(number_of_packages)
    remote_file = Down.open("#{CRAN_BASE_PATH}/PACKAGES")

    # read first 20KB of data which includes at least 50 items
    source = remote_file.read(FILE_MAX_READ_SIZE)
    package_data = Nokogiri::HTML(source).css('p').try(:inner_html)
    unless package_data
      Rails.logger.error "Failed to fetch package list info as scrapping failed"
      return []
    end
    parsed_hash = Dcf.parse(package_data, number_of_packages)
    unless parsed_hash
      Rails.logger.error "Failed to fetch package list info as DCF failed"
      return []
    end

    return parsed_hash.map do |r|
      { name: r["Package"], version: r["Version"]}
    end
  end

  private

  def scrape_tar_file(tar_gz_file_path)
    source = Down.download(tar_gz_file_path)
    Gem::Package::TarReader.new( Zlib::GzipReader.open source ) do |tar|
      tar.each do |entry|
        if entry.file? && entry.full_name.include?(DESCRIPTION_FILE_PATH)
          package =  Dcf.parse(entry.read)
          return package.length > 0 ? package[0] : nil
        end
      end
    end
  end

end
