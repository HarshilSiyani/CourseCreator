class CreateCourses < ActiveRecord::Migration[6.0]
  def change
    create_table :courses do |t|
      t.string :category
      t.boolean :published
      t.integer :teacher_id

      t.timestamps
    end
  end
end
