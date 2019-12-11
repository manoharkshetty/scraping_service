class PackagesController < ApplicationController

  # GET /packages
  # GET /packages.json
  def index
    @packages = Package.all.includes(:authors, :maintainers)
  end
end
