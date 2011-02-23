require 'test_helper'

class AudioTest < ActiveSupport::TestCase
  
  setup do
    @audio = audios(:audio)
    @file = File.open("#{Rails.root}/test/fixtures/audios/audio.m4a")
  end
  
  test "file assignment" do
    # @audio.file = @file
    # @audio.save
  end
  
end
