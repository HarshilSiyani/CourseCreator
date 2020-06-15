class Chat::MessagesController < ApplicationController
  def create
    @course = Course.includes(:students).find(params[:course_id]) # <- N+1 query
    @chatroom = @course.chatroom
    @message = Message.new(message_params)
    @message.chatroom = @chatroom
    @message.user = current_user
    if @message.save
      ChatroomChannel.broadcast_to(
        @chatroom,
        render_to_string(partial: "chat/messages/message", locals: { message: @message })
      )
      NotificationChannel.broadcast_to(
        @course.teacher,
        render_to_string(partial: "chat/messages/notification", locals: { message: @message, course: @course })
      )
      @course.students.each do |student|
        NotificationChannel.broadcast_to(
          student,
          render_to_string(partial: "chat/messages/notification", locals: { message: @message, course: @course })
        )
      end

      redirect_to chat_course_path(@course, anchor: "message-#{@message.id}")
    else
      render "chat/courses/show"
    end
  end

  private

  def message_params
    params.require(:message).permit(:content)
  end
end
