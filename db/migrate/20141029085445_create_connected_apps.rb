class CreateConnectedApps < ActiveRecord::Migration
  def change
    create_table :connected_apps do |t|
      t.references :user, index: true
      t.string :name

      t.timestamps
    end
  end
end
