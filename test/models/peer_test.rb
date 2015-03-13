require 'test_helper'

class PeerTest < ActiveSupport::TestCase

	setup do
		torrents('1MiB').reprocess_meta.save!
		torrents('10MiB').reprocess_meta.save!
	end

	test "volunteer 1MiB affinity calculation" do
		peer = peers(:anonymous_1MiB)
		torrent = torrents('1MiB')
		peer.recalculate_affinity
		assert_equal 0, peer.volunteer_affinity_offset
		assert_equal 1, peer.volunteer_affinity_length
		assert_equal '44', peer.peer_id
	end

	test "volunteer 10MiB affinity calculation" do
		peer = peers(:anonymous_10MiB)
		torrent = torrents('10MiB')
		peer.recalculate_affinity
		assert_equal 0, peer.volunteer_affinity_offset
		assert_equal 2, peer.volunteer_affinity_length
		assert_equal '45', peer.peer_id
	end

end
