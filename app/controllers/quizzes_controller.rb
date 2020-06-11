class QuizzesController < ApplicationController
  before_action :set_course, only: [ :new, :create, :update, :show ]

  def new
    @quiz = Quiz.new
    @quiz.study_module = StudyModule.new
  end

  def create
    @quiz = Quiz.new(quiz_params)
    @quiz.study_module.course = @course

    create_questions(@quiz)

    if @quiz.save
      redirect_to edit_course_path(@course, study_module_id: @quiz.study_module.id)
    else
      render :new
    end
  end

  def update
    @quiz = Quiz.find(params[:id])

    handle_questions(@quiz)
    # raise
    redirect_to edit_course_path(@course, study_module_id: @quiz.study_module.id)
  end

  def show
    @quiz = Quiz.includes(:questions, :answers, :study_module).find(params[:id])
  end

  private

  def set_course
    @course = Course.find(params[:course_id])
  end

  def quiz_params
    params
      .require(:quiz)
      .permit(:text, study_module_attributes: StudyModule.attribute_names.map(&:to_sym).push(:_destroy))
  end

  def question_params
    params
      .require(:quiz)
      .permit(questions_attributes: Question.attribute_names.map(&:to_sym).push(:_destroy))
  end

  def handle_questions(quiz)
    # HANDLE QUESTIONS ACTIONS: CREATE, UPDATE, DELETE
    destroy_questions(quiz)

    create_questions(quiz)
    quiz.save

    update_questions(quiz)
    quiz.save
  end

  def create_questions(quiz)
    createables = question_params["questions_attributes"]
                  .values.select { |question| question["id"].nil? }
                  .map do |question|
                    { text: question["text"] }
                  end
    return if createables.nil?

    quiz.questions.build(createables)
  end

  def update_questions(_quiz)
    updateables = question_params["questions_attributes"]
                  .values.reject { |question| question["_destroy"] == "1" || question["id"].nil? }
    updateable_text = updateables.map { |question| { text: question["text"] } }
    updateable_ids = updateables.map { |question| question["id"].to_i }

    current_questions = Question.where(id: updateable_ids).map(&:text)
    # current_questions == updateables.map { |question| question["text"] }
    # => TRUE if no changes, FALSE if there are changes
    return if updateable_ids.nil? || current_questions == updateables.map { |question| question["text"] }

    Question.update(updateable_ids, updateable_text)
  end

  # Question.find_or_initialize_by(question_params["questions_attributes"].values)
  def destroy_questions(quiz)
    destroyables = question_params["questions_attributes"]
                  .values.select { |question| question["_destroy"] == "1" }
    destroyable_ids = destroyables.map { |question| question["id"].to_i }

    return if destroyable_ids.nil?

    destroyable_ids&.each do |id|
      quiz.questions.destroy(Question.find(id))
    end
  end

end
