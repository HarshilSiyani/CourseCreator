class StudyModule < ApplicationRecord
  belongs_to :course
  belongs_to :contentable, polymorphic: true

  validates :name, presence: true

  def next_module
    self.class.where(course_id: course_id).where("id > ?", id).first
  end

  def previous_module
    self.class.where(course_id: course_id).where("id < ?", id).last
  end

  def first_module
    self.class.where(course_id: course_id).first
  end

  def last_module
    self.class.where(course_id: course_id).last
  end
end
