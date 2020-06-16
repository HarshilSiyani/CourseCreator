class NotificationChannel < ApplicationCable::Channel
  def subscribed
    # binding.pry
    user = User.find(params[:id]) # <- from notification_channel.js
    stream_for user
  end
end
