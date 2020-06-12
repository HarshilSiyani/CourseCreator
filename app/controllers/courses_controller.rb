class CoursesController < ApplicationController
  skip_before_action :authenticate_user!, only: :index
  before_action :set_course, only: [:edit, :update, :publish]

  def new
    @course = Course.new
  end

  def create
    @course = Course.new(course_params)
    @course.teacher = current_user

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
    @contentable = @course.study_modules.find(params[:study_module_id]).contentable
  end

  def original_url
    base_url + original_fullpath
  end

  private

  def set_course
    @course = Course.find(params[:id])
  end

  def course_params
    params.require(:course).permit(:category, :name, :description)
  end
end
