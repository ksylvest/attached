class Person < ActiveRecord::Base
  
  has_attached :avatar, :processor => :image, :styles => {
    :full  => { :size => "400x400#" },
    :thumb => { :size => "100x100#" },
    :small => { :size => "200x200>" },
    :large => { :size => "400x400<" },
  }
  
  validates_attached_presence :avatar
  validates_attached_size :avatar, :in => 2.kilobytes..2.megabytes
  
end


