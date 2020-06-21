class Enrollment < ApplicationRecord
  belongs_to :course
  belongs_to :student, class_name: "User"
  # belongs_to :user, foreign_key: "student_id"

  def next_module_index(current_module)
    self.module_index = current_module.index if current_module.index > module_index
    save
  end
end
