class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.references :connected_app, index: true
      t.decimal :price, precision: 10, scale: 2

      t.timestamps
    end
  end
end
