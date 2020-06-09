class Course < ApplicationRecord
  belongs_to :teacher, class_name: "User"
  has_many :enrollments
  has_many :study_modules
  # belongs_to :user, foreign_key: "teacher_id"
end
