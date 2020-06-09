class CreateLessons < ActiveRecord::Migration[6.0]
  def change
    create_table :lessons do |t|
      t.text :text

      t.timestamps
    end
  end
end
