RSpec.shared_context 'user logged in' do
  let!(:user) { create(:user) }

  before { sign_in_as(user) }
end

RSpec.shared_context 'connected_app with certs' do
  let!(:app) { create(:connected_app) }
  before     { app.send(:generate_encryption_files) }
  after      { FileUtils.remove_dir(app.send(:certificate_path)) }
end
