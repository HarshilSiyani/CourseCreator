class EnrollmentsController < ApplicationController
  # before_action :enrollment_set
  def new
    @enrollment = Enrollment.new
  end

  def create
    @enrollment = Enrollment.new(enrollment_params)
    @enrollment.student_id = current_user.id
    if @enrollment.save
      #need to redirect to study/course/show later
      redirect_to course_path(@enrollment.course)
    else
      redirect_to course_path(@enrollment.course)
    end
  end

  # def show
  #   @enrollments = current_user.enrollments
  # end

  private

  def enrollment_params
    params.permit(:course_id)
  end

  # def enrollment_set
  #   @enrollment = Enrollment.find(params[:id])
  # end
end
