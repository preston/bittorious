# Read about factories at https://github.com/thoughtbot/factory_girl
include ActionDispatch::TestProcess
FactoryGirl.define do
  factory :torrent do
    sequence(:name) {|n| "Torrent Name #{n}" }
    sequence(:slug) {|n| "torrent_slug_#{n}" }
    user
    feed
    sequence(:info_hash) {|n| "FakeInfoHash#{n}"}
    torrent_file { fixture_file_upload(File.join(Rails.root, 'spec', 'fixtures', 'mtb.torrent'), 'application/x-bittorrent') }
  end
end
