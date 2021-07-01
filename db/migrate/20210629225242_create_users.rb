class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :firstname
      t.string :lastname
      t.string :telegram_id
      t.text :query
      t.integer :phone

      t.timestamps
    end
  end
end
