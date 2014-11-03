class AddRedirectUrlToConnectedApps < ActiveRecord::Migration
  def change
    add_column :connected_apps, :redirect_url, :string
  end
end
