class Shop < User
  validates_length_of :password, {minimum: 8}
end