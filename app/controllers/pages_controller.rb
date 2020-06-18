class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :home ]

  def home
    @course = Course.new
    @course.teacher = current_user
  end
end
