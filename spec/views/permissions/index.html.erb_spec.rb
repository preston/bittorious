require 'spec_helper'

describe "permissions/index" do
  before(:each) do
    assign(:permissions, [
      stub_model(Permission,
        :user => nil,
        :feed => nil,
        :role => "Role"
      ),
      stub_model(Permission,
        :user => nil,
        :feed => nil,
        :role => "Role"
      )
    ])
  end

  it "renders a list of permissions" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    # assert_select "tr>td", :text => nil.to_s, :count => 2
    # assert_select "tr>td", :text => nil.to_s, :count => 2
    # assert_select "tr>td", :text => "Role".to_s, :count => 2
  end
end
