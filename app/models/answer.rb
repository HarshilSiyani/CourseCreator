class Answer < ApplicationRecord
  belongs_to :question, optional: true

  validates :text, presence: true
end
