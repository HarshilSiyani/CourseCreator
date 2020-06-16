class EnrollmentsController < ApplicationController
  # before_action :enrollment_set
  def new
    @enrollment = Enrollment.new
  end

  def create
    @enrollment = Enrollment.new(enrollment_params)
    @enrollment.student = current_user
    if @enrollment.save
      flash[:notice] = render_to_string(partial: "chat/messages/welcome", locals: { user: current_user })
      # flash[:notice] = "Welcome to ##{@enrollment.course.name}! #{view_context.link_to('Come say hi 😊', chat_course_path(@enrollment.course))}"
      # flash[:notice] = "<a href='#{url_for(chat_course_path(@enrollment.course))}'> Come say hi </a>"
      redirect_to user_enrollments_path(current_user)
    else
      redirect_to course_path(@enrollment.course)
    end
  end

  def index
    @enrollments = current_user.enrollments
      # NotificationChannel.broadcast_to(
      #   current_user,
      #   render_to_string(partial: "chat/messages/welcome", locals: { user: current_user })
      # )
  end

  private

  def enrollment_params
    params.permit(:course_id)
  end

  # def enrollment_set
  #   @enrollment = Enrollment.find(params[:id])
  # end
end
