class ChangeUploadedDownloadedToBigint < ActiveRecord::Migration
  def change
    change_column :peers, :downloaded, 'BIGINT UNSIGNED'
    change_column :peers, :uploaded, 'BIGINT UNSIGNED'
  end
end
