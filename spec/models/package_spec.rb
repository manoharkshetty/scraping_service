require 'rails_helper'

RSpec.describe Package, type: :model do
  it "imports" do
    import_size = 1
    expect { Package.import_packages(import_size) }.to change{Package.count}.by(import_size)
    package = Package.first
    expect(Author.where(package_id: package.id).count).to eq(1)
    expect(Maintainer.where(package_id: package.id).count).to eq(1)
  end

  it "new_from_hash" do
    hash = {:package=>"A3", :type=>"Package", :title=>"Accurate, Adaptable, and Accessible Error Metrics for Predictive Models", :version=>"1.0.0", :date=>"2015-08-15", :author=>"Scott Fortmann-Roe", :maintainer=>"Scott Fortmann-Roe <scottfr@berkeley.edu>", :description=>"Supplies tools for tabulating and analyzing the results of predictive models. The methods employed are applicable to virtually any predictive model and make comparisons between different methodologies straightforward.",  :"date/publication"=>"2015-08-16 23:05:52"}
    package = Package.new_from_hash(hash)
    expect(package).not_to eq(nil)
    expect(package.name).to eq("A3")
    expect(package.authors.first.name).to eq("Scott Fortmann-Roe")
    expect(package.maintainers.first.name).to eq("Scott Fortmann-Roe")
  end
end
