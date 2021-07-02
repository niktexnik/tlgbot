class AddColumnActionToUser < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :action, :string
  end
end
