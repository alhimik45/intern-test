class Guest < User
  validates_length_of :password, {minimum: 6}
end