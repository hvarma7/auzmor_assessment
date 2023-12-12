class Account < ApplicationRecord

  has_many :phone_numbers, class_name: 'PhoneNumber'
end