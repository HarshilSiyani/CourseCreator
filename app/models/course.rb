class Course < ApplicationRecord
  belongs_to :teacher, class_name: "User"
  has_many :enrollments
  has_many :students, through: :enrollments, foreign_key: :student_id
  has_many :study_modules
  # belongs_to :user, foreign_key: "teacher_id"
  validates :description, length: { minimum: 30,
    too_short: "requires minimum of %{count} characters" }
  validates :name, presence: true
  validates :category, presence: true
  has_one :chatroom
end
