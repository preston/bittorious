class AdditionalUserFields < ActiveRecord::Migration
  def change
  	add_column	:users, :admin, :boolean, default: false

    add_column	:users,	:name,	:string,	null: false,	default: ''
    add_column	:users,	:authentication_token,	:string
    add_column :users, :approved, :boolean, defalut: false
    add_index  :users, :approved
  end
end
