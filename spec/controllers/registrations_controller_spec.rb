require 'spec_helper'
describe RegistrationsController do

  describe "GET destroy" do
    login_admin
    it "should return an error if the user has torrents" do
      torrent = FactoryGirl.create(:torrent, user: @admin)
      delete :destroy 
      response.should redirect_to(edit_user_registration_path)
      flash[:error].should == "You must transfer ownership of your files before you delete your account."
    end

    it "should destroy if the user has no torrents" do
      delete :destroy 
      response.should redirect_to('http://test.host/')
      lambda{ User.find(@admin.id)}.should raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
