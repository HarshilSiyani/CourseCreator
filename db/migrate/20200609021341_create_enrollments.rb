class CreateEnrollments < ActiveRecord::Migration[6.0]
  def change
    create_table :enrollments do |t|
      t.integer :module_index
      t.references :course, null: false, foreign_key: true
      t.references :student, foreign_key: { to_table: 'users' }
      # t.integer :student_id

      t.timestamps
    end
  end
end
