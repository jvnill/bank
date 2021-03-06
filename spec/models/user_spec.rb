require 'rails_helper'

RSpec.describe User, type: :model do
  let!(:subject) { create(:user) }

  it { is_expected.to have_many(:connected_apps) }
end
