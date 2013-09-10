require 'spec_helper'
describe FeedsController do

  describe "POST create" do
    login_admin
    it "should redirect to dashboard" do
      post :create, {:feed => {:name => 'Foo', :user_id => @admin.id}}
      response.should redirect_to(dashboard_path)
    end

    it "should return json" do
      post :create, {:feed => {:name => 'Foo', :user_id => @admin.id}, :format => :json}
      json = JSON.parse(response.body)
      json['name'].should == 'Foo'
      json['id'].should_not be_nil
    end
  end

  describe "DELETE destroy" do
    login_admin
    it "should redirect to dashboard" do
      feed = FactoryGirl.create(:feed, :user => @admin)
      delete :destroy, {:id => feed.id}
      response.should redirect_to(dashboard_path)
    end

    it "should return json" do
      feed = FactoryGirl.create(:feed, :user => @admin)
      delete :destroy, {:id => feed.id, :format => :json}
      json = JSON.parse(response.body)
      json['name'].should == feed.name
      json['id'].should == feed.id
    end
  end
end
