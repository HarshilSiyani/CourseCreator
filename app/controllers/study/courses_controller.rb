module Study
  class CoursesController < ApplicationController
    def show
      @course = Course.find(params[:id])

      # if current_user is not enrolled into the course, then
      # 1. redirect_to the user's enrollment #index
      # redirect_to user_enrollments_path(current_user) unless current_user_enrolled?(@course)
      # 2. redirect_to the course #show
      # redirect_to course_path(@course) unless current_user_enrolled?(@course)

      @contentable = @course.study_modules.find(params[:study_module_id]).contentable
    end

    def attempt
      @course = Course.find(params[:course_id])
      @contentable = @course.study_modules.find(params[:study_module_id]).contentable
    end

    private

    def current_user_enrolled?(course)
      current_user.enrollments.map(&:course).include?(course)
      # current_user.enrollment_ids.map(&:)include?(course.id)
    end
  end
end
