class Package < ApplicationRecord

  has_many :authors
  has_many :maintainers
  validates :name, uniqueness: { scope: :version }

  def self.import
    package_hash = PackageScraper.new.scrape
    package = new_from_hash package_hash
    return unless package.valid?
    return package if package.save
  end

  def self.import_packages
    list = PackageScraper.get_package_list
    Parallel.each(list, in_processes: 8) do |p|
      begin
        next if self.where(name: p[:name], version: p[:version]).count != 0
        package_hash = scrape_package(p[:name], p[:version])
        next unless package_hash
        package = Package.new_from_hash(package_hash)
        package.save
      rescue StandardError => e
        Rails.logger.error "error in importing"
        next
    end
    return nil
  end

  def self.new_from_hash(package_hash)
    package =  Package.new
    package.name = package_hash[:package]
    package.version = package_hash[:version]
    package.description = package_hash[:description]
    package.title = package_hash[:title]
    package.publication_date = package_hash[:"date/publication"].to_date
    package.authors = Author.from_string(package_hash[:author])
    package.maintainers = Maintainer.from_string(package_hash[:maintainer])
    return package
  end
end
