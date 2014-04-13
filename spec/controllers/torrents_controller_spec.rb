require 'spec_helper'
describe TorrentsController do

  # This should return the minimal set of attributes required to create a valid
  # Feed. As you add validations to Feed, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    {}
  end

  def peer_params_for_torrent(torrent, event = 'starter')
    {
      info_hash:   pack_info_hash(torrent),
      peer_id:     ['fake_peer_' + rand(9999999).to_s].pack('H*'), 
      uploaded:    100,
      downloaded:  100,
      left:        100,
      key:         'key',
      event:       event,
      port:        6881
    }
    end

  describe "GET index" do
    login_admin
    it "assigns all torrents as @torrents" do
      torrent = FactoryGirl.create(:torrent, user: @admin)
      get :index, {}
      assigns(:torrents).should eq([torrent])
    end
  end

  describe "POST create" do
    login_admin
    it "should redirect to the dashboard" do
      feed = FactoryGirl.create(:feed)
      post :create, torrent: FactoryGirl.attributes_for(:torrent).merge({feed_id: feed.id, user_id: @admin.id})
      response.should redirect_to(dashboard_url)
    end
  end

  describe "DELETE destroy" do
    login_admin
    it "should redirect to the dashboard" do
      torrent = FactoryGirl.create(:torrent, :user => @admin)
      delete :destroy, {:id => torrent.id}
      response.should redirect_to(dashboard_url)
    end
  end

  describe "GET announce" do
    login_admin
    it "returns a bencoded list of peers" do
      torrent = FactoryGirl.create(:torrent, user: @admin)
      peer_params = peer_params_for_torrent(torrent)
      get :announce, peer_params
      response.body.bdecode.should == {"complete"=>0, "incomplete"=>1, "interval"=>900, "peers"=>[{"ip"=>"0.0.0.0", "peer id"=> peer_params[:peer_id].unpack('H*').first, "port"=>6881}]}
    end
  end

  describe "GET scrape" do
    login_admin
    it "returns a bencoded list of files for the torrent" do
      torrent = FactoryGirl.create(:torrent, user: @admin)
      peer_params = peer_params_for_torrent(torrent)
      get :scrape, {:info_hash => peer_params[:info_hash]}
      response.body.bdecode.should == {"files" => {torrent.private_info_hash => {"complete"=>0, "incomplete"=>0, "name" => torrent.name}}  }
    end

    it "returns a bencoded list of files for all the torrent" do
      torrent = FactoryGirl.create(:torrent, user: @admin)
      get :scrape
      response.body.bdecode.should == {"files" => {torrent.private_info_hash => {"complete"=>0, "incomplete"=>0, "name" => torrent.name}}  }
    end
  end

  describe "GET search" do
    login_admin
    it "returns json for the search results" do
      torrent = FactoryGirl.create(:torrent, user: @admin)
      fix_solr_index(Torrent)
      get :search, {:q => 'Test'}
      assigns(:torrents).collect(&:id).should eq [torrent.id]
    end
  end

  describe "GET show.torrent" do
    login_admin
    it "should return a torrent file" do
      torrent = FactoryGirl.create(:torrent, user: @admin)
      get :show, {:id => torrent, :format => 'torrent'}
      response.content_type.should == 'application/x-bittorrent'
    end
  end

  describe "Logged in admin" do
    login_admin
    it "should have a current_user" do
      subject.current_user.should_not be_nil
    end
    it "should get index" do
      get 'index'
      response.should be_success
    end
  end


end
