class Course < ApplicationRecord
  belongs_to :teacher, class_name: "User"
  # belongs_to :user, foreign_key: "teacher_id"
end
