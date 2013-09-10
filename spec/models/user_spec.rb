require 'spec_helper'
require "cancan/matchers"

describe User do
  context "CanCan" do
    subject { ability }
    let(:ability){ Ability.new(user) }
    context "admin" do
      let(:user){ FactoryGirl.create(:admin_user) }


      it{ should      be_able_to(:create, Feed)}
      it{ should      be_able_to(:create, Torrent)}
      it{ should      be_able_to(:manage, Feed.new) }
      it{ should      be_able_to(:manage, Peer.new) }
      it{ should      be_able_to(:manage, Torrent.new) }
      it{ should      be_able_to(:manage, User.new) }
      it{ should      be_able_to(:approve, User.new) }
      it{ should      be_able_to(:deny, User.new) }
      it{ should      be_able_to(:deny, user) }
      it{ should      be_able_to(:approve, user) }
    end
    context "publisher" do
      let(:user){ FactoryGirl.create(:publisher_user) }

      it{ should      be_able_to(:create, Feed)}
      it{ should      be_able_to(:create, Torrent)}

      it{ should      be_able_to(:manage, Feed.new(:user_id => user.id)) }
      it{ should_not  be_able_to(:manage, Feed.new(:user_id => 999999)) }
      it{ should_not  be_able_to(:create, Torrent.new(:user_id => user.id, :feed_id => 99999))}
      it{ should      be_able_to(:manage, Torrent.new(:user_id => user.id, :feed => Feed.new(:user_id => user.id))) }
      it{ should_not  be_able_to(:manage, Torrent.new(:user_id => 999999)) }
      it{ should      be_able_to(:manage, Peer.new) }
      it{ should_not  be_able_to(:manage, User.new) }
      it{ should      be_able_to(:manage, user) }
      it{ should_not  be_able_to(:approve, User.new) }
      it{ should_not  be_able_to(:approve, user) }
      it{ should_not  be_able_to(:deny, User.new) }
      it{ should_not  be_able_to(:deny, user) }

      it{ should_not  be_able_to(:read, Feed.new(:user_id => 999999))}
    end
    context "user" do
      let(:user){ FactoryGirl.create(:approved_user) }

      it{ should_not  be_able_to(:create, Feed.new(:user_id => user.id))}
      it{ should_not  be_able_to(:create, Torrent.new(:user_id => user.id))}
      it{ should_not  be_able_to(:manage, Feed.new(:user_id => user.id)) }
      it{ should_not  be_able_to(:manage, Feed.new(:user_id => 999999)) }
      it{ should_not  be_able_to(:manage, Torrent.new(:user_id => user.id)) }
      it{ should_not  be_able_to(:manage, Torrent.new(:user_id => 999999)) }
      it{ should      be_able_to(:manage, Peer.new) }
      it{ should_not  be_able_to(:manage, User.new) }
      it{ should      be_able_to(:manage, user) }
      it{ should_not  be_able_to(:approve, User.new) }
      it{ should_not  be_able_to(:approve, user) }
      it{ should_not  be_able_to(:deny, User.new) }
      it{ should_not  be_able_to(:deny, user) }

      it{ should_not  be_able_to(:read, Feed.new(:user_id => 999999))}
    end

    context "feed roles" do
      let(:user){ FactoryGirl.create(:approved_user) }
      let(:feed){ FactoryGirl.create(:feed) }
      let(:torrent){ FactoryGirl.create(:torrent, :feed => feed)}
      let(:permission){ FactoryGirl.create(:permission, :user => user, :feed => feed)}

      context "publisher" do
        before{permission.update_attributes(:role => Permission::PUBLISHER_ROLE)}

        it{ should_not be_able_to(:manage, feed)}
      end

      context "admin" do
        before{permission.update_attributes(:role => Permission::ADMIN_ROLE)}

        it{ should be_able_to(:manage, feed)}
      end

    end
  end

  context "as_json default" do
    it "should include an auth token" do
      FactoryGirl.create(:user).as_json[:auth_token].should_not be_nil
    end
  end

  context "transfer_ownership" do
    it "should add an error if you don't specify new owner" do
      user = FactoryGirl.create(:user)
      user.transfer_ownership(nil).should be_false
      user.errors.full_messages.should_not be_nil
    end

    it "should transfer all torrents to the new user" do
      user = FactoryGirl.create(:user)
      new_user = FactoryGirl.create(:user)
      feed = FactoryGirl.create(:feed, :user => user)
      torrent = FactoryGirl.create(:torrent, :user => user, :feed => feed)
      user.transfer_ownership(new_user).should be_true
      user.reload && new_user.reload
      user.torrents.count.should == 0
      user.feeds.count.should == 0
      new_user.feeds.count.should == 1
      new_user.torrents.count.should == 1
      new_user.torrents.first.id.should == torrent.id
      new_user.feeds.first.id.should == feed.id
    end
  end

  context "inactive_message" do
    it "should show not approved if it isn't" do
      FactoryGirl.build(:user, :approved => false).inactive_message.should == :not_approved
    end
    it "should show inactive if it is approve" do
      FactoryGirl.build(:user, :approved => true).inactive_message.should == :inactive
    end
  end
end