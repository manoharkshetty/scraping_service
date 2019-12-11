PACKAGE_MAX_LENGTH = 50

class Package < ApplicationRecord
  has_many :authors
  has_many :maintainers
  validates :name, uniqueness: { scope: :version }

  def self.import_packages(package_size = PACKAGE_MAX_LENGTH)
    scrapper = PackageScraper.new
    list = scrapper.get_package_list(package_size)
    Rails.logger.info "Importing #{package_size} packages"
    Parallel.each(list, in_processes: 8) do |p|
      # TODO: Optimise the query. this code is doing 50 selects and 50 insertions.
      if self.where(name: p[:name], version: p[:version]).count != 0
        Rails.logger.info "Not importing #{p[:name]} as it already exists"
        next
      end
      package_hash = scrapper.scrape_package(p[:name], p[:version])
      unless package_hash
        Rails.logger.error "Failed to import #{p[:name]} as scrapping failed"
        next
      end
      package = Package.new_from_hash(package_hash)
      saved = package.save
      Rails.logger.error "Failed to import #{package.name} packages" unless saved
    end
  end

  def self.new_from_hash(package_hash)
    #TODO: handle publication date better
    package = Package.new(name: package_hash[:package],
      version: package_hash[:version],
      description: package_hash[:description],
      title: package_hash[:title],
      publication_date: package_hash[:"date/publication"].to_date
    )
    package.authors = Author.from_string(package_hash[:author])
    package.maintainers = Maintainer.from_string(package_hash[:maintainer])
    return package
  end
end
