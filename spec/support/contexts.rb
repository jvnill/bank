RSpec.shared_context 'user logged in' do
  let!(:user) { create(:user) }

  before { sign_in_as(user) }
end
