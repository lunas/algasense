class CreateRgbs < ActiveRecord::Migration
  def change
    create_table :rgbs do |t|
      t.integer :red
      t.integer :green
      t.integer :blue

      t.timestamps null: false
    end
  end
end
