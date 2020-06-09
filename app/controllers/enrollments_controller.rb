class EnrollmentsController < ApplicationController
  # before_action :enrollment_set
  def new
    @enrollment = Enrollment.new
  end

  def create
    @enrollment = Enrollment.new(enrollment_params)
    @enrollment.student = current_user
    if @enrollment.save
      redirect_to user_enrollments_path(current_user)
    else
      redirect_to course_path(@enrollment.course)
    end
  end

  def index
    @enrollments = current_user.enrollments
  end

  private

  def enrollment_params
    params.permit(:course_id)
  end

  # def enrollment_set
  #   @enrollment = Enrollment.find(params[:id])
  # end
end
