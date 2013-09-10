require 'spec_helper'

describe Torrent do
  describe 'relationships' do
    it { should belong_to(:user) }
  end
end