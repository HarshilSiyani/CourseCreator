module Study
  class ProgressesController < ApplicationController
    def show
      @course = Course.find(params[:course_id])
      enrollment = current_user.enrollments.find_by(course: @course)

      respond_to do |format|
        format.html
        format.json do
          render json: { current_index: enrollment.module_index,
                         total: @course.study_modules.count }
        end
      end
    end

    def teacher_show
      @course = Course.find(params[:course_id])
      @current_module = @course.enrollments.find_by(course: @course).module_index
      @total_modules = @course.study_modules.count
      @current = ((@current_module / @total_modules) * 100)
    end
  end
end
