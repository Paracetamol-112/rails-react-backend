class Student < ApplicationRecord
  default_scope { order(rollnumber: :asc) }
  validates :name, :email, :rollnumber, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :rollnumber, numericality: { only_integer: true }
end
