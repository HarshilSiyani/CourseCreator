class CreateEnrollments < ActiveRecord::Migration[6.0]
  def change
    create_table :enrollments do |t|
      t.integer :module_index
      t.integer :student_id
      t.references :course, null: false, foreign_key: true

      t.timestamps
    end
  end
end
