class Image < ActiveRecord::Base

  has_attached :file, processor: :image, path: "images/files/:style/:identifier:extension", 
    styles: {
      full: { size: "400x400#", extension: ".jpg", quality: 90 },
      large: { size: "400x400<", extension: ".jpg", quality: 90 },
      small: { size: "200x200>", extension: ".jpg", quality: 90 },
      thumb: { size: "100x100#", extension: ".jpg", quality: 90 },
    }

  validates_attached_presence :file
  validates_attached_size :file, in: 2.kilobytes..2.megabytes
  validates_attached_extension :file, in: %w(png jpg)

end
