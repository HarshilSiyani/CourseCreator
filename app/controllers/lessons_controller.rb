class LessonsController < ApplicationController

  def new
    @lesson = Lesson.new
    @course = Course.find(params[:course_id])
  end

  def create
    @lesson = Lesson.new(lesson_params)
    if @lesson.save!
      redirect_to root_path
    else
      render :new
    end
  end

  private

  def lesson_params
    params.require(:lesson).permit(:title, :content)
  end
end
