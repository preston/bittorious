require 'test_helper'

class TorrentsControllerTest < ActionController::TestCase

	include Devise::TestHelpers
	include Warden::Test::Helpers


	setup do
		@public = feeds(:public)
		@private = feeds(:private)
	end

	test 'should load valid test torrents' do

	end

	# INDEX

end