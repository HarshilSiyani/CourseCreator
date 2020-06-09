# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
puts "Start seeding! --- --->"

user = User.new({
  first_name: "Erik", 
  last_name: "Tran", 
  email: "erik@study.com"
})
user.password = "abc123"
user.save!

course = Course.create!({
  teacher: user,
  category: "Information Technology",
  published: false,
  name: "Full stack web development",
  description: "Developing website from A to Z",
})

lesson = Lesson.create!(text: "Welcome to Ruby!")
quiz = Quiz.create!(text: "Initial quiz for ice-breaking")

StudyModule.create!({
  index: 1,
  course: course,
  name: "Hello world!",
  contentable: lesson
})

StudyModule.create!({
  index: 2,
  course: course,
  name: "First quizz",
  contentable: quiz
})

lisa = User.new({
  first_name: "Lisa", 
  last_name: "Huang", 
  email: "lisa@study.com"
})
lisa.password = "abc123"
lisa.save!

Enrollment.create({
  module_index: 1,
  course: Course.first,
  student: lisa
})

# Question 1
question_1 = Question.create!(text: "What is IRB?", quiz: quiz)
question_1.answers.create!([
  {question: question_1, correct: true, text: "It's a run time environemt for Ruby."},
  {question: question_1, correct: false, text: "Rails use this to host website."},
  {question: question_1, correct: false, text: "Not related to Ruby or Rails."},
  {question: question_1, correct: false, text: "I don't know!"},
])

# Question 2
question_2 = Question.create!(text: "What is OOP?", quiz: quiz)
question_2.answers.create!([
  {question: question_2, correct: true, text: "Object-Oriented Programming."},
  {question: question_2, correct: false, text: "Onward on Programming."},
  {question: question_2, correct: false, text: "Not related to Ruby or Rails."},
  {question: question_2, correct: false, text: "I don't know!"},
])

puts "--- --- Finished seeding!"