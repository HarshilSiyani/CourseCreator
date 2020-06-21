class Study::CoursesController < ApplicationController
  layout "student_view"
  def show
    @course = Course.find(params[:id])
    redirect_to course_path(@course) and return unless current_user.currently_enrolled?(@course)

    # @current_module = set_current_module(@course, params[:study_module_id])
    @current_module = @course.find_module_or_first(params[:study_module_id])
    @contentable = @current_module.contentable
    redirect_to study_course_path(@course, study_module_id: @current_module) and return unless params[:study_module_id]

    @enrollment = current_user.find_my_enrollment(@course)
    @enrollment.next_module_index(@current_module)
    # @quiz_passed control how the next button to go to next study module
    # if @current_module is Lesson then able to go next to module
    # if @current_module is a Quiz and student already passed this quiz
    @quiz_passed = @current_module.lesson? ||
                    (@current_module.quiz? && @enrollment.module_index > @current_module.index)
  end

  def current_progress
    @course = Course.find(params[:id])
    enrollment = current_user.enrollments.find_by(course: @course)

    respond_to do |format|
      format.json { render head :no_content }
      format.json { render json: { current_module_index: enrollment.module_index } }
    end
  end

  private

  def set_current_module(course, module_id = nil)
    if module_id
      course.find_module(module_id)
    else
      course.first_module
    end
  end
end
