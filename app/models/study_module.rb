class StudyModule < ApplicationRecord
  belongs_to :course
  belongs_to :contentable, polymorphic: true

validates :name, presence: true
end
