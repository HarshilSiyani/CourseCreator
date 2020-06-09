class CreateCourses < ActiveRecord::Migration[6.0]
  def change
    create_table :courses do |t|
      t.string :category
      t.boolean :published
      t.references :teacher, foreign_key: { to_table: 'users' }
      # t.integer :teacher_id

      t.timestamps
    end
  end
end
