class CreatePeople < ActiveRecord::Migration
  def self.up
    create_table :people do |t|
      t.string :name
      
      t.string :avatar_identifier
      t.string :avatar_extension
      t.integer :avatar_size

      t.timestamps
    end
  end

  def self.down
    drop_table :people
  end
end
