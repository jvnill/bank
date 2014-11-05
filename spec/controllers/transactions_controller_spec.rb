require 'rails_helper'

RSpec.describe TransactionsController do
  describe 'POST create' do
    let!(:app) { create(:connected_app) }

    before do
      session[:app_id] = app.id
      session[:price]  = 10

      post :create
    end

    it { expect(session[:app_id]).to be_nil }
    it { expect(response).to render_template(:success) }
    it { expect(response).to be_success }
    it { expect(app.transactions.count).to eql(1) }
    it { expect(app.transactions.first.price).to eql(10) }
  end

  describe 'GET pay' do
    include_context 'connected_app with certs'

    let!(:order_items)   { { 'Order1' => { 'quantity' => '1', 'price' => '10' } } }
    let!(:callback_data) { { 'callback_data' => { 'order_id' => '1' } } }
    let!(:public_key)    { OpenSSL::PKey::RSA.new(File.read(app.public_key_path)) }
    let!(:encrypted)     { Base64.encode64(public_key.public_encrypt(order_items.merge(callback_data).to_param)) }

    before { get :new, app_id: app.id, items: encrypted }

    it { expect(response).to be_success }
    it { expect(response).to render_template(:new) }
    it { expect(assigns[:app]).to eql(app) }
    it { expect(assigns[:details]).to eql(order_items) }
    it { expect(assigns[:transaction]).to be_new_record }
    it { expect(session[:callback_data]).to eql(callback_data['callback_data']) }
    it { expect(session[:price]).to eql(10) }
    it { expect(session[:app_id]).to eql(app.id) }
  end

  describe 'POST verify' do
    context 'transaction exists' do
      let!(:transaction) { create(:transaction) }

      before { post :verify, random: transaction.random_token, reference: transaction.id }

      it { expect(response).to be_success }
      it { expect(response.body).to eql(' ') }
    end

    context 'transaction does not exist' do
      it { expect { post :verify, random: 1, reference: 2 }.to raise_error(ActiveRecord::RecordNotFound) }
    end
  end
end
