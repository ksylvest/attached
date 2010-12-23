class Audio < ActiveRecord::Base
  
  has_attached :file, :processor => :audio, :styles => {
    :small => { :preset => "128kbps" },
    :large => { :preset => "256kbps" },
  }
  
  validates_attached_presence :file
  validates_attached_size :file, :in => 2.kilobytes..2.megabytes
  
end
