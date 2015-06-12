class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.string :user
      t.string :password

      t.timestamps null: false
    end
  end
end
