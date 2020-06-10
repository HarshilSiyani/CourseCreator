class LessonsController < ApplicationController
  def new
    # new_course_lesson GET    /courses/:course_id/lessons/new
    @course = Course.find(params[:course_id])
    @lesson = Lesson.new
    @lesson.study_module = StudyModule.new()
  end

  def create
    # raise
    # course_lessons POST   /courses/:course_id/lessons
    @course = Course.find(params[:course_id])
    @lesson = Lesson.new(lesson_params)
    @lesson.study_module.course = @course
    if @lesson.save
      # course_lesson GET    /courses/:course_id/lessons/:id
      redirect_to edit_course_path(@course, study_module_id: @lesson.study_module.id)
    else
      render :new
    end
  end

  def show
    # course_lesson GET    /courses/:course_id/lessons/:id
    @course = Course.find(params[:course_id])
    @lesson = Lesson.find(params[:id])
  end

  def edit
    # edit_course_lesson GET    /courses/:course_id/lessons/:id/edit
    @course = Course.find(params[:course_id])
    @lesson = Lesson.find(params[:id])
  end

  def update
    @course = Course.find(params[:course_id])
    @lesson = Lesson.find(params[:id])
    @lesson.update(lesson_params)
    redirect_to course_lesson_path(@course, @lesson)
  end

  private

  def lesson_params
    params.require(:lesson).permit(:content, study_module_attributes: {})
  end
end
