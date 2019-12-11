require 'rails_helper'

RSpec.describe Package, type: :model do
  it "imports" do
    package = Package.import
    expect(package).not_to eq(nil)
    expect(Package.first).to eq(package)
    expect(Maintainer.where(package_id: package.id)).to eq(package.maintainers)
    expect(Author.where(package_id: package.id)).to eq(package.authors)
  end
end
