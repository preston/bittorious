require 'spec_helper'
describe UsersController do
  context "GET manage" do
    login_admin
    it "should assign approved and pending users" do
      approved_user = FactoryGirl.create(:user, :approved => true)
      pending_user = FactoryGirl.create(:user, :approved => false)
      get :manage
      assigns[:pending].collect(&:id).should == [pending_user.id]
      assigns[:approved].collect(&:id).should == [@admin.id, approved_user.id]
    end
  end

  context "POST approve" do
    login_admin
    it "should approve a user" do
      user = FactoryGirl.create(:user, :approved => false)
      post :approve, {:user_id => user.id}
      user.reload
      user.approved.should == true
    end
  end

  context "POST deny" do
    login_admin
    it "should deny a user" do
      user = FactoryGirl.create(:user, :approved => false)
      post :deny, {:user_id => user.id}
      lambda{ user.reload }.should raise_error(ActiveRecord::RecordNotFound)
    end
  end
end