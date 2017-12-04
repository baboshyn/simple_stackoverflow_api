class CreateSessions < ActiveRecord::Migration[5.0]
  def change
    create_table :sessions do |t|
      t.string :auth_token
      t.references :user, index: true, foreign_key: true
      t.timestamps
    end
  end
end
