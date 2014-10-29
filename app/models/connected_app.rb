class ConnectedApp < ActiveRecord::Base
  belongs_to :user, inverse_of: :connected_apps

  validates :user, :name, presence: true

  after_create :generate_encryption_files

  def generate_encryption_files
    create_certificate_path

    key = OpenSSL::PKey::RSA.new(2048)

    open(certificate_path.join('private_key.pem'), 'w') { |f| f.write(key.to_pem) }
    open(certificate_path.join('public_key.pem'), 'w')  { |f| f.write(key.public_key.to_pem) }
  end

  def public_key_url
    certificate_path.join('public_key.pem').to_s
  end

  private

  def certificate_path
    @certificate_path ||= Rails.root.join('certs', user.id.to_s)
  end

  def create_certificate_path
    FileUtils.mkdir_p(certificate_path)
  end
end
