class QuizzesController < ApplicationController
  def new
    @course = Course.find(params[:course_id])
    @quiz = Quiz.new
    @quiz.study_module = StudyModule.new
  end

  def create
    @course = Course.find(params[:course_id])
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
    @course = Course.find(params[:course_id])
    @quiz = Quiz.find(params[:id])

    handle_questions(@quiz)
    # raise
    redirect_to edit_course_path(@course, study_module_id: @quiz.study_module.id)
  end

  private

  def quiz_params
    # params.require(:lesson).permit(:content, study_module_attributes: {})
    params
      .require(:quiz)
      .permit(:text, study_module_attributes: StudyModule.attribute_names.map(&:to_sym).push(:_destroy))
  end

  def question_params
    params
      .require(:quiz)
      .permit(questions_attributes: Question.attribute_names.map(&:to_sym).push(:_destroy))
      # .values[0]
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

    # raise
    quiz.questions.build(createables)
  end

  def update_questions(quiz)
    question_text = question_params["questions_attributes"]
                    .values.reject { |question| question["_destroy"] == "1" }
                    .map do |question|
                      { text: question["text"] }
                    end
    
    # raise
    Question.update(quiz.question_ids, question_text)
  end

  # questions = question_params["questions_attributes"].values
  # Question.find_or_initialize_by(question_params["questions_attributes"].values)
  def destroy_questions(quiz)
    destroyable_ids = question_params["questions_attributes"]
                      .values.select { |question| question["_destroy"] == "1" }
                      .map { |question| question["id"].to_i }
    
    return if destroyable_ids.nil?

    destroyable_ids&.each do |id|
      # Question.find(id).destroy
      quiz.questions.destroy(Question.find(id))
    end
  end
end
