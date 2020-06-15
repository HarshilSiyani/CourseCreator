class CoursesController < ApplicationController
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
      redirect_to course_path(@course)
    else
      render :new
    end
  end

  def show
    @course = Course.find(params[:id])
  end

  def index
    @courses = current_user.courses
  end

  def edit
    # raise
    @contentable = @course.study_modules.find(params[:study_module_id]).contentable
  end

  def publish
    study_module = @course.study_modules.find(params[:study_module_id])

    redirect_to course_path(@course) unless current_user == @course.teacher || current_user.enrollments.map(&:course).include?(@course)
    @contentable = study_module.contentable
  end

  private

  def set_course
    @course = Course.find(params[:id])
  end

  def course_params
    params.require(:course).permit(:category, :name, :description)
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
end
