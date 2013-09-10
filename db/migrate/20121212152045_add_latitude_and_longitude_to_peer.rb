class AddLatitudeAndLongitudeToPeer < ActiveRecord::Migration
  def change
    add_column :peers, :latitude, :float
    add_column :peers, :longitude, :float
  end
end
