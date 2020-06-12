class Quiz < ApplicationRecord
  has_one :study_module, as: :contentable
  has_many :questions, dependent: :destroy
  has_many :answers, through: :questions

  accepts_nested_attributes_for :study_module
  accepts_nested_attributes_for :questions,
                                allow_destroy: true,
                                reject_if: proc { |att| att['text'].blank? }

  accepts_nested_attributes_for :answers,
                                allow_destroy: true,
                                reject_if: proc { |att| att['text'].blank? }

  validates :study_module, presence: true
  validates :text, presence: true
end
