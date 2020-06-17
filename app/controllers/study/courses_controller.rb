module Study
  class CoursesController < ApplicationController
    def show
      @course = Course.find(params[:id])
      # if current_user is not enrolled into the course, then
      # 1. redirect_to the user's enrollment #index
      # redirect_to user_enrollments_path(current_user) unless current_user_enrolled?(@course)
      # 2. redirect_to the course #show
      # redirect_to course_path(@course) unless current_user_enrolled?(@course)

      if params[:study_module_id]
        @current_module = @course.study_modules.find(params[:study_module_id])
        @contentable = @current_module.contentable
      else
        @current_module = @course.study_modules.first
        @contentable = @course.study_modules.first.contentable
      end
      @enrollment = current_user.enrollments.find_by(course_id: @course.id)
      @enrollment.module_index = @current_module.index if @current_module.index > @enrollment.module_index
      @enrollment.save

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
      # current_user.enrollment_ids.include?(course.id) #=> wrong
      current_user.enrollments.map(&:course).include?(course)
    end
  end
end
