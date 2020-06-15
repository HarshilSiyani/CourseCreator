class Chatroom < ApplicationRecord
  belongs_to :course
  has_many :messages
end
