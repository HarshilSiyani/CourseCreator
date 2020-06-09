class Quiz < ApplicationRecord
  has_one :study_module, as: :contentable
end
