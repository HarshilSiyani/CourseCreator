class CreateStudyModules < ActiveRecord::Migration[6.0]
  def change
    create_table :study_modules do |t|
      t.integer :index
      t.string :name
      t.references :course, null: false, foreign_key: true
      t.references :contentable, polymorphic: true

      t.timestamps
    end
  end
end
