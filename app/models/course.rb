class Course < ApplicationRecord
  belongs_to :teacher, class_name: "User"
  has_many :enrollments
  # belongs_to :user, foreign_key: "teacher_id"
end
