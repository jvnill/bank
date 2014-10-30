class AddPassphraseToConnectedApps < ActiveRecord::Migration
  def change
    add_column :connected_apps, :passphrase, :string
  end
end
