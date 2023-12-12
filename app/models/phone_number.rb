class PhoneNumber < ApplicationRecord

  # attr_reader :from, :to, :text
  belongs_to :account

end