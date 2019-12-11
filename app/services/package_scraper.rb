require 'nokogiri'
require 'rubygems/package'
require 'scraper/dcf'
require 'down'
require 'parallel'

DESCRIPTION_FILE_PATH = "DESCRIPTION"
CRAN_BASE_PATH = "http://cran.r-project.org/src/contrib"
FILE_MAX_READ_SIZE = 10 * 1024
PACKAGE_MAX_LENGTH = 50

class PackageScraper
  def scrape
    scrape_package("A3", "1.0.0")
  end

  def scrape_package(package_name, version)
    package = scrape_tar_file("#{CRAN_BASE_PATH}/#{package_name}_#{version}.tar.gz")
    return nil unless package
    package.deep_transform_keys!{ |key| key.downcase.to_sym }
  end

  def get_package_list
    remote_file = Down.open("#{CRAN_BASE_PATH}/PACKAGES")

    # read first 50KB of data which includes at least 50 items
    source = remote_file.read(FILE_MAX_READ_SIZE)
    package_data = Nokogiri::HTML(source).css('p').try(:inner_html)
    return [] unless package_data
    parsed_hash = Dcf.parse(package_data)
    return [] unless parsed_hash

    return parsed_hash.map do |r|
      { name: r["Package"], version: r["Version"]}
    end
  end

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
