class CreateAccount < ActiveRecord::Migration[7.0]
  def change
    create_table :accounts do |t|
      t.string :auth_id, :limit => 40
      t.string :username, :limit => 30
      t.timestamps
    end
    create_table :phone_numbers do |t|
      t.string :number, :limit => 40
      t.references :account, index: true, foreign_key: true
      t.timestamps
    end
  end
end
