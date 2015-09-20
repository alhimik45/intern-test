class Admin < User
  validates_length_of :password, {minimum: 10}
end