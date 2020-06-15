class Chat::CoursesController < ApplicationController
  def show
    @course = Course.find(params[:id])
    @chatroom = @course.chatroom
    @message = Message.new
  end
end
