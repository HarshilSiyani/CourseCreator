class Course < ApplicationRecord
  belongs_to :teacher, class_name: "User"
  has_many :enrollments
  has_many :students, through: :enrollments, foreign_key: :student_id
  has_many :study_modules
  # belongs_to :user, foreign_key: "teacher_id"
  validates :description, length: { minimum: 30, too_short: "requires minimum of %{count} characters" }
  validates :name, presence: true
  validates :category, presence: true
  has_one :chatroom

  def first_module
    study_modules.includes(:contentable).first
  end

  def last_module
    study_modules.includes(:contentable).last
  end

  def find_module(study_module)
    study_modules.includes(:contentable).find(study_module)
  end

  def find_module_or_first(study_module_id = nil)
    if study_module_id
      find_module(study_module_id)
    else
      first_module
    end
  end

  def self.default_course(user)
    course = Course.new(category: "Other", description: "This is a introduction course that will highlight some of the important features and guides", name: "Introduction", published: false, teacher: user)
    course.save
    Chatroom.create(course: course)
    lesson = Lesson.new
    lesson.study_module = StudyModule.new(course: course, index: 1, name: "Introduction")
    lesson.content.body = "<strong>Welcome</strong><br><br>This document will guide you some of the basic features need to use the web application<br><strong>Some interesting features of the appliation</strong><ul><li>Create lessons with images and videos</li><li>Create quizzes and have your students answer them when they study your content</li><li>Convert your existing Word or Pdf documents into digital interactive course</li><li>Share your course with your students by simply sharing sending them the link from the share button</li><li>You can check on students enrolled in your course</li><br><strong>How to create new lesson</strong><br>To create a new lesson, on the left sidebar, click on the '+ lesson' button and you will see an empty section appear, Enter the lesson name and the lesson content.<br>You can also copy paste your lesson from your Word document or Pdf.<br>Click on 'Create lesson' to have the lesson saved you can also edit the lesson by clicking on it from the sidebar, edit the content and click on 'Update'<br><br><strong>Add images or videos</strong><br>When you want to add an image to a section of your lesson content simply click on the attach icon on the editor toolbar and upload the picture you would like to add.<br>For your youtube videos, click on the embed button from the editor toolbar and paste the video link into the input field. Select yes to embed.<br><br><strong>How to share the course with students</strong><br>To share the course with your students, click on 'Share' and then on 'Copy Link' You can use this link to send it to your students via your preferred communication methods. <strong>NOTE: Your student will have to sign up to the platform and then enroll in the course for them to be able to view the course.</strong><br><br><strong>How to check enrolled student details</strong><br>To check the details of students enrolled in the course, from your courses dashboard - where you can see all your course(access it by clicking on 'Teach' on the navbar). Select the course you wish to see student details and click on 'View'. From this page you will see the course description and option to edit your course to add new modules. Below this you should see Student details of those enrolled in your course.".html_safe
    lesson.save
  end
end
