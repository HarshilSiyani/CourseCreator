class Question < ApplicationRecord
  belongs_to :quiz, optional: true
  has_many :answers, dependent: :destroy
  accepts_nested_attributes_for :answers,
                                allow_destroy: true,
                                reject_if: proc { |att| att['text'].blank? }

  validates :text, presence: true
end
