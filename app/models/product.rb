class Product < ActiveRecord::Base
  belongs_to :user

  def delete_photo
    unless self.photo.nil?
      File.delete('public' + self.photo)
    end
  end

end
