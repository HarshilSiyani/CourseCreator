class LessonsController < ApplicationController
  before_action :set_course, only: [:new, :create, :show, :update]

  def new
    # GET    /courses/:course_id/lessons/new
    @lesson = Lesson.new
    @lesson.study_module = StudyModule.new()
  end

  def create
    # raise
    # POST   /courses/:course_id/lessons
    @lesson = Lesson.new(lesson_params)
    @lesson.study_module.course = @course
    if @lesson.save
      redirect_to edit_course_path(@course, study_module_id: @lesson.study_module.id)
    else
      render :new
    end
  end

  def show
    # GET    /courses/:course_id/lessons/:id
    @lesson = Lesson.find(params[:id])
  end

  def update
    @lesson = Lesson.find(params[:id])
    @lesson.update(lesson_params)
    redirect_to edit_course_path(@course, study_module_id: @lesson.study_module.id)
  end

  private

  def lesson_params
    params.require(:lesson).permit(:content, study_module_attributes: {})
  end

  def set_course
    @course = Course.find(params[:course_id])
  end
end

# def edit
#   # GET    /courses/:course_id/lessons/:id/edit
#   @course = Course.find(params[:course_id])
#   @lesson = Lesson.find(params[:id])
# end
