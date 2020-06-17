module Study
  class CoursesController < ApplicationController
    layout "student_view"
    def show
      @course = Course.find(params[:id])
      redirect_to course_path(@course) and return unless current_user_enrolled?(@course)

      if params[:study_module_id]
        @current_module = @course.study_modules.find(params[:study_module_id])
      else
        @current_module = @course.study_modules.first
      end

      @contentable = @current_module.contentable
      @enrollment = current_user.enrollments.find_by(course_id: @course.id)
      @enrollment.module_index = @current_module.index if @current_module.index > @enrollment.module_index
      @enrollment.save
      # @quiz_passed control how the next button to go to next study module
      # if @current_module is Lesson then able to go next to module
      # if @current_module is a Quiz and student already passed this quiz
      @quiz_passed = @current_module.contentable_type == Lesson.to_s || (@current_module.contentable_type == Quiz.to_s && @enrollment.module_index > @current_module.index)
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

    def current_user_enrolled?(course)
      current_user.enrollments.map(&:course).include?(course)
    end
  end
end
