class CoursesController < ApplicationController
  skip_before_action :authenticate_user!, only: :index

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

  private

  def course_params
    params.require(:course).permit(:category, :name, :description)
  end
end
