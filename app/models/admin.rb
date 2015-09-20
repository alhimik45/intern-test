class Admin < User
  validates_length_of :password, {minimum: 10}
  validates_presence_of :firstname
  validates_presence_of :lastname
  validates_presence_of :birthday
  validates_presence_of :avatar
  validates_presence_of :passport
end