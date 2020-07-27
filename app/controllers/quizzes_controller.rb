class QuizzesController < ApplicationController
  before_action :set_course, only: [:create, :update, :show]


  def create
    @quiz = Quiz.new(quiz_create_params)
    @quiz.study_module.course = @course
    # raise
    if @quiz.save
      redirect_to edit_course_path(@course, study_module_id: @quiz.study_module.id)
    else
      render :new
    end
  end

  def update
    @quiz = Quiz.find(params[:id])
    @quiz.update quiz_params
    @quiz.update question_params

    # redirect_to course_quiz_path(@course, @quiz) and return if params[:commit] == "Preview"

    redirect_to edit_course_path(@course, study_module_id: @quiz.study_module.id)
  end

  def show
    @quiz = Quiz.includes(:questions, :answers, :study_module).find(params[:id])
  end

  def answers
    @quiz = Quiz.find(params[:id])
    @answers = @quiz.answers
    respond_to do |format|
      format.json
      format.html do
        redirect_to study_course_path(@quiz.study_module.course),
                    notice: "Unathorized accessed!", content_type: 'text/html'
      end
    end
  end

  private

  def set_course
    @course = Course.find(params[:course_id])
  end

  def quiz_params
    params.require(:quiz).permit(
      :text,
      study_module_attributes: StudyModule.attribute_names.map(&:to_sym)
    )
  end

  def question_params
    tmp_params = params.require(:quiz).permit(
      questions_attributes: Question.attribute_names.map(&:to_sym).push(:_destroy)
      .push(answers_attributes: Answer.attribute_names.map(&:to_sym).push(:_destroy))
    )

    params.permit(:id).merge!(tmp_params)
  end

  def quiz_create_params
    params
      .require(:quiz)
      .permit(
        :text,
        study_module_attributes: StudyModule.attribute_names.map(&:to_sym),
        questions_attributes: Question.attribute_names.map(&:to_sym).push(:_destroy)
        .push(answers_attributes: Answer.attribute_names.map(&:to_sym).push(:_destroy))
      )
  end
end
