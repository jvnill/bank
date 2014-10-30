class ConnectedApp < ActiveRecord::Base
  belongs_to :user, inverse_of: :connected_apps

  validates :user, :name, presence: true

  after_create :set_passphrase
  after_create :generate_encryption_files

  def generate_encryption_files
    create_certificate_path

    key = OpenSSL::PKey::RSA.new(2048)

    open(certificate_path.join('private_key.pem'), 'w') { |f| f.write(key.to_pem(OpenSSL::Cipher::Cipher.new('des3'), passphrase)) }
    open(certificate_path.join('public_key.pem'), 'w')  { |f| f.write(key.public_key.to_pem) }
  end

  def public_key_path
    certificate_path.join('public_key.pem').to_s
  end

  def private_key_path
    certificate_path.join('private_key.pem').to_s
  end

  private

  def set_passphrase
    begin
      self.passphrase = SecureRandom.urlsafe_base64
    end while ConnectedApp.exists?(passphrase: passphrase)

    update_column :passphrase, passphrase
  end

  def certificate_path
    @certificate_path ||= Rails.root.join('certs', id.to_s)
  end

  def create_certificate_path
    FileUtils.mkdir_p(certificate_path)
  end
end
