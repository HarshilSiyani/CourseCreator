class NotificationChannel < ApplicationCable::Channel
  def subscribed
    # stream_from "some_channel"
    # binding.pry
    user = User.find(params[:id])
    stream_for user
  end
end
