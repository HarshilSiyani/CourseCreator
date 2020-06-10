class Lesson < ApplicationRecord
  has_one :study_module, as: :contentable
  has_rich_text :content
end
