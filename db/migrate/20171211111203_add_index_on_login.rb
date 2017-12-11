class AddIndexOnLogin < ActiveRecord::Migration[5.0]
  def change
    add_index :users, :login
  end
end
