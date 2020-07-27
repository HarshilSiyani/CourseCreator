class CoursesController < ApplicationController
  layout :student_layout
  skip_before_action :authenticate_user!, only: :index
  before_action :set_course, only: [:edit, :update, :publish]

  def new
    @course = Course.new
  end

  def create
    @course = Course.new(course_params)
    @course.teacher = current_user
    @course.published = false

    lesson = default_lesson(@course)

    @course.study_modules << lesson.study_module
    # raise

    if @course.save
      Chatroom.create(course: @course)
      redirect_to course_path(@course)
    else
      render :new
    end
  end

  def show
    @course = Course.find(params[:id])
    @total_modules = @course.study_modules.count.to_f
    @is_teacher = current_user.enrollments.count.positive?
    @is_my_course = current_user == @course.teacher
  end

  def index
    @courses = current_user.courses
  end

  def edit
    @current_module = @course.find_module_or_first(params[:study_module_id])
    conditional_params = params[:study_module_id] || params[:type]
    redirect_to edit_course_path(@course, study_module_id: @current_module) and return unless conditional_params

    # raise
    @contentable = @current_module.contentable
    return unless params[:type] == 'lesson' || params[:type] == 'quiz'

    @contentable = params[:type].capitalize.constantize.new
    @contentable.study_module = StudyModule.new
  end

  def publish
    redirect_to course_path(@course) and return unless current_user.teacher? || current_user.course?(@course)

    @current_module = @course.find_module_or_first(params[:study_module_id])
    @contentable = @current_module.contentable

    redirect_to publish_course_path(@course, study_module_id: @current_module) unless params[:study_module_id]
  end

  private

  def set_course
    @course = Course.find(params[:id])
  end

  def course_params
    params.require(:course).permit(:category, :name, :description)
  end

  def new_contentable_params
    params.permit(:id, :study_module_id, :lesson, :quiz)
  end

  def default_lesson(course)
    lesson = Lesson.new(
      text: "Welcome",
      study_module_attributes: {
        index: 1,
        course: course,
        name: "Welcome to #{course.name}"
      }
    )
    lesson.content.body = "Welcome to #{course.name}!"
    return lesson
  end

  def student_layout
    my_enrollments = current_user.enrollments
    my_enrollments.size.positive? && my_enrollments.map(&:course).include?(@course) ? "student_view" : "application"
  end
end
