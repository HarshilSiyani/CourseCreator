class EnrollmentsController < ApplicationController
  # before_action :enrollment_set
  def new
    @enrollment = Enrollment.new
  end

  def create
    @enrollment = Enrollment.new(enrollment_params)
    @enrollment.student = current_user
    @enrollment.module_index = 1

    if @enrollment.save
      notifiy_new_enrollment(@enrollment)
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

  def notifiy_new_enrollment(enrollment)
    flash[:notice] = render_to_string(partial: "chat/messages/welcome", locals: { user: current_user })
    NotificationChannel.broadcast_to(
      enrollment.course.teacher,
      render_to_string(partial: "chat/messages/enrollment", locals: { user: current_user })
    )
  end
end
