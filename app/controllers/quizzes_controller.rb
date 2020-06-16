class QuizzesController < ApplicationController
  before_action :set_course, only: [:new, :create, :update, :show]

  def new
    @quiz = Quiz.new
    @quiz.study_module = StudyModule.new
  end

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
    # raise
    @quiz = Quiz.find(params[:id])
    @quiz.update quiz_params
    @quiz.update question_params

    # handle_questions(@quiz) # OLD CODE
    if params[:commit] == "Preview"
      redirect_to course_quiz_path(@course, @quiz)
    else
      redirect_to edit_course_path(@course, study_module_id: @quiz.study_module.id)
    end
  end

  def show
    @quiz = Quiz.includes(:questions, :answers, :study_module).find(params[:id])
  end

  def answers
    @quiz = Quiz.find(params[:id])
    @answers = @quiz.answers
    # raise
    # puts params
    # raise
    respond_to do |format|
      # format.json { render json: { correct_answers: @answers, status: :ok }, content_type: 'application/json' }
      format.json
      format.html { redirect_to study_course_path(@quiz.study_module.course), notice: "Unathorized accessed!", content_type: 'text/html' }
      # format.js { render json: { correct_answers: answers, user_answers: user_answers, status: :ok }, content_type: 'application/json' }
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

  # def handle_questions(quiz)
  #   # HANDLE QUESTIONS ACTIONS: CREATE, UPDATE, DELETE
  #   destroy_questions(quiz)

  #   quiz.save if create_questions(quiz)

  #   quiz.save if update_questions(quiz)
  # end

  # def create_questions(quiz)
  #   createables = question_params["questions_attributes"]
  #                 .values.select { |question| question["id"].nil? }
  #                 .map do |question|
  #                   { text: question["text"] }
  #                 end
  #   return false if createables.nil?

  #   quiz.questions.build(createables)
  #   return true
  # end

  # def update_questions(_quiz)
  #   updateables = question_params["questions_attributes"]
  #                 .values.reject { |question| question["_destroy"] == "1" || question["id"].nil? }
  #   updateable_text = updateables.map { |question| { text: question["text"] } }
  #   updateable_ids = updateables.map { |question| question["id"].to_i }

  #   current_questions = Question.where(id: updateable_ids).map(&:text)
  #   # current_questions == updateables.map { |question| question["text"] }
  #   # => TRUE if no changes, FALSE if there are changes
  #   return false if updateable_ids.nil? || current_questions == updateables.map { |question| question["text"] }

  #   Question.update(updateable_ids, updateable_text)
  #   return true
  # end

  # # Question.find_or_initialize_by(question_params["questions_attributes"].values)
  # def destroy_questions(quiz)
  #   destroyables = question_params["questions_attributes"]
  #                 .values.select { |question| question["_destroy"] == "1" }
  #   destroyable_ids = destroyables.map { |question| question["id"].to_i }

  #   return if destroyable_ids.nil?

  #   destroyable_ids&.each do |id|
  #     quiz.questions.destroy(Question.find(id))
  #   end
  # end
end
