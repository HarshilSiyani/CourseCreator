class Enrollment < ApplicationRecord
  belongs_to :course
  belongs_to :user, foreign_key: "student_id"
end
