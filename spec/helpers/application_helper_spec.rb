require 'spec_helper'

describe ApplicationHelper do
  context "as_size" do
    [[102, '102 B'], [1024, '1 KiB'], [1048576, '1 MiB'], [1073741824, '1 GiB'], [1099511627776, '1 TiB']].each do |data|
      it "should convert sizes to human readable format" do
        helper.as_size(data[0]).should == data[1]
      end
    end
  end

  context "attachment_url" do
    it "should return a non localhost url when hostname is localhot" do
      mock_request(host: 'localhost', request_uri: 'http://localhost:3000', port: 3000)
      torrent = FactoryGirl.create(:torrent)
      helper.attachment_url(torrent.torrent_file, :bt).should == "http://#{AppConfig['default_hostname'].gsub(/:\d+/,'')}#{torrent.torrent_file.url(:bt)}"
    end

    it "should return a the current hostname when not localhost" do
      mock_request(host: 'foobar', request_uri: 'https://foobar:123', port: 123)
      controller.request.env['HTTPS'] = 'on'
      torrent = FactoryGirl.create(:torrent)
      helper.attachment_url(torrent.torrent_file, :bt).should == "https://foobar#{torrent.torrent_file.url(:bt)}"
    end
  end

  context "request_host_or_default" do
    it "should return the app config hostname when local host" do
      mock_request(host: 'localhost', request_uri: 'http://localhost:3000', port: 3000)
      helper.request_host_or_default.should == AppConfig['default_hostname'].gsub(/:\d+/,'')
    end

    it "should return the current request host without port if not localhost" do
      mock_request(host: 'foobar', request_uri: 'http://foobar:6969', port: 6969)
      helper.request_host_or_default.should == 'foobar'
    end
  end

  context "feed_url" do
    it "should return the url for a feed appended with .rss and auth token" do
      user = FactoryGirl.create(:user)
      helper.stub(:current_user).and_return(user)
      feed = FactoryGirl.create(:feed)
      helper.feed_rss_url(feed).should == 'http://test.host/feeds/' + feed.slug + ".rss?auth_token=#{user.auth_token}"
    end
  end

  context "torrents_rss_url" do
    it "should return the all torrents rss feed url with auth token" do
      user = FactoryGirl.create(:user)
      helper.stub(:current_user).and_return(user)
      helper.torrents_rss_url.should == 'http://test.host/torrents.rss' + "?auth_token=#{user.auth_token}"
    end
  end

  private
  def mock_request(params = {})
    params.each_pair{|k,v| controller.request.send(k.to_s + '=', v) }
  end
end
