class StudyModule < ApplicationRecord
  belongs_to :course
  belongs_to :contentable, polymorphic: true
end
