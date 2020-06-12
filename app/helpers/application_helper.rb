module ApplicationHelper
  # REQUIRED for quiz form builder
  def add_answer_link(name)
    link_to_function name do |page|
      page.insert_html :bottom, :answers, partial: 'Answer', object: Answer.new
    end
  end
end
