class Shop < User

  mount_uploader :avatar, AvatarUploader

  validates_length_of :password, {minimum: 8}
  validates_presence_of :shopname
  validates_presence_of :avatar
end