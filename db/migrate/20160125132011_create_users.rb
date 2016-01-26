class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :zooniverse_id
      t.string :access_token
      t.string :refresh_token

      t.timestamps null: false
    end
  end
end
