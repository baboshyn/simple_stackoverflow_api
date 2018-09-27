class ChangeColumnLoginToFirstName < ActiveRecord::Migration[5.0]
  def change
    rename_column :users, :login, :first_name
  end
end
