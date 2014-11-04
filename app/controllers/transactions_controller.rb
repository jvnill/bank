class TransactionsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: :verify

  def new
    @app         = ConnectedApp.find(params[:app_id])
    @details     = Rack::Utils.parse_nested_query(decrypted_items)
    @transaction = @app.transactions.build

    session[:callback_data] = @details.delete('callback_data')
    session[:price]         = total_price(@details)
    session[:app_id]        = @app.id
  end

  def create
    app = ConnectedApp.find(session[:app_id])
    transaction = app.transactions.create(price: session[:price], random_token: SecureRandom.urlsafe_base64)

    render template: 'transactions/success', locals: { app: app, callback_data: session[:callback_data].presence || {}, transaction: transaction }

    reset_session
  end

  def verify
    Transaction.find_by!(random_token: params[:random], id: params[:reference])
    render nothing: true
  end

  private

  def decrypted_items
    private_key = OpenSSL::PKey::RSA.new(File.read(@app.private_key_path), @app.passphrase)

    private_key.private_decrypt(Base64.decode64(params[:items]))
  end

  def total_price(details)
    details.inject(0) do |sum, (k,v)|
      sum + (v['price'].to_d * v['quantity'].to_d)
    end
  end
end
