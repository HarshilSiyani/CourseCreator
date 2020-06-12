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
    # @enrolled_ids = current_user.enrollment_ids
    # # @enrolled_ids.each do |enrolled|
    #   if (@enrolled_ids.course_id == @course_id)
    #     @contentable = @course.study_modules.find(params[:study_module_id]).contentable
    #   else
    #     redirect_to user_enrollments_path(current_user.id)
    #   end
    # end
    @course = Course.find(params[:id])
    if current_user == @course.teacher
        redirect_to publish_course_path(@course_id)
      else
        redirect_to course_path(@course_id)
      end

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
