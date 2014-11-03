class Transaction < ActiveRecord::Base
  belongs_to :connected_app, inverse_of: :transactions

  validates :connected_app, presence: true
  validates :price, numericality: { greater_than: 0 }
end
