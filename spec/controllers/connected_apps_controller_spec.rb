require 'rails_helper'

RSpec.describe ConnectedAppsController, type: :controller do
  include_context 'user logged in'

  describe 'GET index' do
    let!(:app1) { create(:connected_app, user: user) }
    let!(:app2) { create(:connected_app) }

    before { get :index }

    it { expect(response).to be_success }
    it { expect(response).to render_template(:index) }
    it { expect(assigns(:connected_apps)).to match_array([app1]) }
  end

  describe 'GET new' do
    before { get :new }

    it { expect(response).to be_success }
    it { expect(response).to render_template(:new) }
    it { expect(assigns(:connected_app)).to be_new_record }
  end

  describe 'POST create' do
    context 'invalid app' do
      before { post :create, connected_app: { redirect_url: 'localhost:3000', name: '' } }

      it { expect(response).to be_success }
      it { expect(response).to render_template(:new) }
      it { expect(assigns(:connected_app).errors.to_a).to match_array(['Name can\'t be blank']) }
      it { expect(assigns(:connected_app)).to be_new_record }
    end

    context 'valid app' do
      before { post :create, connected_app: { redirect_url: 'localhost:3000', name: 'App' } }

      it { expect(response).to redirect_to(connected_apps_path) }
      it { expect(assigns(:connected_app)).to be_persisted }
    end
  end

  describe 'GET destroy' do
    let!(:app) { create(:connected_app, user: user) }

    before { delete :destroy, id: app.id }

    it { expect(response).to redirect_to(connected_apps_path) }
    it { expect { app.reload }.to raise_error(ActiveRecord::RecordNotFound) }
  end

  describe 'GET download' do
    let!(:app) { create(:connected_app, user: user) }

    before do
      app.send(:generate_encryption_files)

      get :download, id: app.id
    end

    after { FileUtils.remove_dir(app.send(:certificate_path)) }

    it { expect(response.header['Content-Disposition']).to eql('attachment; filename="public_key.pem"') }
    it { expect(response.header['Content-Type']).to eql('application/octet-stream') }
  end
end
