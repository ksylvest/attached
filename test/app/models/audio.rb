class Audio < ActiveRecord::Base
  
  has_attached :file, :processor => :audio, :path => "audios/files/:style/:identifier:extension", 
  :styles => {
    :full  => { :preset => "320kbps", :extension => ".wav" },
    :large => { :preset => "256kbps", :extension => ".wav" },
    :small => { :preset => "128kbps", :extension => ".wav" },
  }
  
  validates_attached_presence :file
  validates_attached_size :file, :in => 2.kilobytes..2.megabytes
  validates_attached_extension :file, :in => %w(wav aif)
  
end
