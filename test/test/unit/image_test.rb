require 'test_helper'

class ImageTest < ActiveSupport::TestCase
  
  setup do
    @image = images(:image)
    @file = File.open("#{Rails.root}/test/fixtures/images/image.png")
  end
  
  test "file assignment" do
    # @image.file = @file
    # @image.save
  end
  
end
