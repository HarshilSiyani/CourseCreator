class Quiz < ApplicationRecord
  has_one :study_module, as: :contentable
  has_many :questions
  has_many :answers, through: :questions
  validates :study_module, presence: true
end
