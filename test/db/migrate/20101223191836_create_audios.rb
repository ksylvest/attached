class CreateAudios < ActiveRecord::Migration
  def change
    create_table :audios do |t|
      t.string :name
      t.attachment :file

      t.timestamps
    end
  end
end
