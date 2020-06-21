class StudyModule < ApplicationRecord
  belongs_to :course
  belongs_to :contentable, polymorphic: true

  validates :name, presence: true

  before_create :set_next_id

  def next_module
    # self.class.where(course_id: course_id).where("id > ?", id).first
    course.study_modules.where("id > ?", id).includes(:contentable).first
  end

  def previous_module
    # self.class.where(course_id: course_id).where("id < ?", id).last
    course.study_modules.where("id < ?", id).includes(:contentable).last
  end

  def first_module
    # self.class.where(course_id: course_id).first
    course.study_modules.includes(:contentable).first
  end

  def last_module
    # self.class.where(course_id: course_id).last
    course.study_modules.includes(:contentable).last
  end

  def first_module?
    self == first_module
  end

  def last_module?
    self == last_module
  end

  def lesson?
    contentable_type == Lesson.to_s
  end

  def quiz?
    contentable_type == Quiz.to_s
  end

  private

  def set_next_id
    last_module = course.last_module
    if last_module
      self.index = last_module.index + 1
    else
      self.index = 1
    end
  end
end
