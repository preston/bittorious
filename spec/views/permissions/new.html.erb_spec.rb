require 'spec_helper'

describe "permissions/new" do
  before(:each) do
    assign(:permission, stub_model(Permission,
      :user => nil,
      :feed => nil,
      :role => "MyString"
    ).as_new_record)
  end

  it "renders new permission form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => permissions_path, :method => "post" do
      assert_select "input#permission_user", :name => "permission[user]"
      assert_select "input#permission_feed", :name => "permission[feed]"
      assert_select "input#permission_role", :name => "permission[role]"
    end
  end
end
