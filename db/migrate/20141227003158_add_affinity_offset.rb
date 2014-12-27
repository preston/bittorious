class AddAffinityOffset < ActiveRecord::Migration
  def change
		add_column	:peers, :volunteer_affinity_length, :integer, default: 0
  end
end
