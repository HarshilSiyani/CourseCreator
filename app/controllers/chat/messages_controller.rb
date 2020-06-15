class Chat::MessagesController < ApplicationController
  def create
    @course = Course.find(params[:course_id])
    @chatroom = @course.chatroom
    @message = Message.new(message_params)
    @message.chatroom = @chatroom
    @message.user = current_user
    if @message.save
      ChatroomChannel.broadcast_to(@chatroom,
        render_to_string(partial: "chat/messages/message", locals: { message: @message })
      )
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
