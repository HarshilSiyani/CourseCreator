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
  user: user,
  category: "Information Technology",
  published: false,
  # name: "Full stack web development",
  # description: "Developing website from A to Z",
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

puts "--- --- Finished seeding!"