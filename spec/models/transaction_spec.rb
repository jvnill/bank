require 'rails_helper'

RSpec.describe Transaction, type: :model do
  let!(:subject) { create(:transaction) }

  it { is_expected.to belong_to(:connected_app) }
  it { is_expected.to validate_presence_of(:connected_app) }
  it { is_expected.to validate_numericality_of(:price).is_greater_than(0) }
end
