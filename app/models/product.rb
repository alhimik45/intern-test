class Product < ActiveRecord::Base
  belongs_to :user

  mount_uploader :photo, ProductPhotoUploader
  
end
