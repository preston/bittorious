class AddGeocodingFields < ActiveRecord::Migration

  def change
  	add_column	:peers,	:country_name, :string
  	add_column	:peers,	:city_name, :string
  end

end
