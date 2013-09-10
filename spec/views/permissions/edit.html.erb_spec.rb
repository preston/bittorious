require 'spec_helper'

describe "permissions/edit" do
  before(:each) do
    @permission = assign(:permission, stub_model(Permission,
      :user => nil,
      :feed => nil,
      :role => "MyString"
    ))
  end

  it "renders the edit permission form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => permissions_path(@permission), :method => "post" do
      assert_select "input#permission_user", :name => "permission[user]"
      assert_select "input#permission_feed", :name => "permission[feed]"
      assert_select "input#permission_role", :name => "permission[role]"
    end
  end
end
