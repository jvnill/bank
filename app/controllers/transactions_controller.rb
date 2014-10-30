class TransactionsController < ApplicationController
  before_action :fetch_connected_app

  def new
    @details = Rack::Utils.parse_nested_query(decrypted_items)
  end

  def create
  end

  private

  def fetch_connected_app
    @app = ConnectedApp.find(params[:app_id])
  end

  def decrypted_items
    private_key = OpenSSL::PKey::RSA.new(File.read(@app.private_key_path), @app.passphrase)

    private_key.private_decrypt(Base64.decode64(params[:items]))
  end
end
