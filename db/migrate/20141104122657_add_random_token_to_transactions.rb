class AddRandomTokenToTransactions < ActiveRecord::Migration
  def change
    add_column :transactions, :random_token, :string
  end
end
