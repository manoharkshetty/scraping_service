require 'rails_helper'

RSpec.describe "packages/index", type: :view do
  before(:each) do
    assign(:packages, [
      Package.create!(
        :name => "Name",
        :version => 2
      ),
      Package.create!(
        :name => "Name",
        :version => 2
      )
    ])
  end

  it "renders a list of packages" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
  end
end
