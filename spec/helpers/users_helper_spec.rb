describe UsersHelper do
  context "active_role" do
    it "should return active if role matches" do
      helper.active_role(FactoryGirl.create(:user), User::USER_ROLE).should == 'active'
    end

    it "should return nil if the role does not match" do
      helper.active_role(FactoryGirl.create(:user), User::ADMIN_ROLE).should == nil
    end
  end
end