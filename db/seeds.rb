# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

puts "Start seeding! --- --- --->"
require 'json'
teachers = []
students = []
courses = []

puts "Seeding Users..."
user_data = JSON.parse(File.open('db/seed_data/users.json').read)
user_data.each do |record|
  user = User.new({
    first_name: record["first_name"],
    last_name: record["last_name"],
    email: record["email"]
  })
  user.password = record["password"]
  if user.save!
    teachers << user if record["role"] == "teacher"
    students << user if record["role"] == "student"
  end
end
puts "...finished seeding Users"


puts "Seeding Courses..."
course_file = File.open('db/seed_data/courses.json').read
JSON.parse(course_file).each do |record|
  course = Course.new({
    name: record["name"],
    description: record["description"].join(" "),
    category: record["category"],
    published: record["published"],
    teacher: teachers.sample
  })
  
  
  if course.save!
    name = "Welcome to the first lesson of #{course.name}!"
    lesson = Lesson.new(text: name)
    lesson.study_module = StudyModule.new(
      course: course,
      index: 1,
      name: name,
    )
    lesson.save!
    
    courses << course
  end
end
puts "...finished seeding Courses"


puts "Seeding Enrollments..."
rand(1..3).times do
  student = students.sample
  available_courses = Course.ids - student.enrollment_ids.map{ |id| Enrollment.find(id).course_id }
  enrol = Enrollment.new({
    course_id: available_courses.sample,
    student: student,
    module_index: 1
  })
  enrol.save!
end
puts "...finished seeding Enrollments"


puts "Seeding Study Modules..."
puts "Sowing Lessons..."
lessons = JSON.parse(File.open('db/seed_data/lessons.json').read)
quizzes = JSON.parse(File.open('db/seed_data/quizzes.json').read)
course_ruby = Course.find_by(name: "Learn Ruby Basics")

lessons.each_with_index do |lesson, index|
  record = Lesson.new(text: lesson["text"])
  record.study_module = StudyModule.new(
    course: course_ruby,
    index: index,
    name: lesson["text"]
  )
  record.save!
end

puts "Sowing Quizzes..."
quizzes.each_with_index do |quiz, index|
  record = Quiz.new(text: quiz["text"])
  record.study_module = StudyModule.new(
    course: course_ruby,
    index: course_ruby.study_modules.last.index + 1,
    name: quiz["text"]
  )
  record.save!

  quiz["questions"].each do |question_data|
    question = Question.new(text: question_data["text"], quiz: record)
    question.save!

    question.answers.build(question_data["answers"])
    question.save!
  end
end
puts "...finished seeding Study Modules"

puts "<--- --- Finished seeding!"
