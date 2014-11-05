require 'rails_helper'

RSpec.describe ConnectedApp, type: :model do
  let!(:subject) { create(:connected_app) }

  it { is_expected.to have_many(:transactions) }
  it { is_expected.to belong_to(:user) }
  it { is_expected.to validate_presence_of(:user) }
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:redirect_url) }
  it { expect(subject.passphrase).to be_present }

  describe '#public_key_path' do
    it { expect(subject.public_key_path).to eql(Rails.root.join('tmp', 'certs', subject.id.to_s, 'public_key.pem').to_s) }
  end

  describe '#private_key_path' do
    it { expect(subject.private_key_path).to eql(Rails.root.join('tmp', 'certs', subject.id.to_s, 'private_key.pem').to_s) }
  end

  describe '#generate_encryption_files' do
    before { subject.send(:generate_encryption_files) }
    after  { FileUtils.remove_dir(subject.send(:certificate_path)) }

    it { expect(File.exists?(subject.public_key_path)).to eql(true) }
    it { expect(File.exists?(subject.private_key_path)).to eql(true) }
  end
end
