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
    email: record["email"],
    nickname: record["nickname"],
    role: record["role"]
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
    teacher: teachers[1]
  })


  if course.save!
    name = "Welcome"
    lesson = Lesson.new(text: name)
    lesson.content.body = "Welcome to #{course.name}!"
    lesson.study_module = StudyModule.new(
      course: course,
      index: 1,
      name: name,
    )
    lesson.save!

    courses << course

    Chatroom.create(course: course)
  end
end
puts "...finished seeding Courses"


puts "Seeding Enrollments..."
2.times do
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
  record.content.body = lesson["content"].html_safe
  record.study_module = StudyModule.new(
    course: course_ruby,
    index: index + 1,
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

########################################################################################
########################################################################################
puts "Generating ActionCable full course...."

puts "AC teacher...."
z = User.create!(
  first_name: "Zach",
  last_name: "Chung",
  nickname: "zachchung",
  email: "zach@study.com",
  password: "abc123"
  )

puts "AC course...."
c = Course.create!(
  name: "WebSocket & ActionCable",
  category: "Information Technology",
  description: "Sometimes, web applications need real-time features. ActionCable can solve this issue and make your app sharp!",
  published: false,
  teacher: z
  )

Chatroom.create(course: c)

####################
puts "AC lessons...."
lessons = []
lessons << "<div class=\"trix-content\">\n  <div>\n<strong><br>Problem<br></strong><br>\n</div><div>Sometimes, web applications need <strong>real-time</strong> features<br><br>\n</div><div>\n<strong><br>HTTP<br></strong><br>\n</div><div>HTTP is a request / response cycle protocol<br><br>\n</div><div><action-text-attachment content-type=\"image\" url=\"https://kitt.lewagon.com/karr/karr.kitt/assets/protocols/http-protocol-196ca16d87e497066e774d6cba95ad63f816c6a6b5eda08ec008d41c6b4ff24b.svg?program_id=1\" width=\"300\" height=\"113\"><figure class=\"attachment attachment--preview\">\n  <img width=\"300\" height=\"113\" src=\"https://kitt.lewagon.com/karr/karr.kitt/assets/protocols/http-protocol-196ca16d87e497066e774d6cba95ad63f816c6a6b5eda08ec008d41c6b4ff24b.svg?program_id=1\">\n</figure></action-text-attachment></div><div>The request <strong>has to</strong> be triggered by the <strong>client<br></strong><br>\n</div><div>In a chat app, several clients need to be updated in real-time with incoming messages<br><br>\n</div><div>We don’t want to trigger HTTP requests every second to fake real-time<br><br>\n</div>\n</div>\n"
lessons << "<div class=\"trix-content\">\n  <div>\n<strong><br>Web Socket<br></strong><br>\n</div><div>Unlike HTTP, WS is <strong>bidirectional<br></strong><br>\n</div><div><action-text-attachment content-type=\"image\" url=\"https://kitt.lewagon.com/karr/karr.kitt/assets/protocols/websocket-13ec4f23124226db5152cf4a9a94d0f3a3c1a247cedb8b9da431663b65e8829e.svg?program_id=1\" width=\"300\" height=\"113\"><figure class=\"attachment attachment--preview\">\n  <img width=\"300\" height=\"113\" src=\"https://kitt.lewagon.com/karr/karr.kitt/assets/protocols/websocket-13ec4f23124226db5152cf4a9a94d0f3a3c1a247cedb8b9da431663b65e8829e.svg?program_id=1\">\n</figure></action-text-attachment></div><div>A message created on the server can be broadcasted to subscribed clients (browsers)</div>\n</div>\n"
lessons << "<div class=\"trix-content\">\n  <div>\n<strong><br>Action Cable<br></strong><br>\n</div><div>Let’s setup Action Cable in 3 steps 😎<br><br>\n</div><div>\n<strong><br>1. Generate channel<br></strong><br>\n</div><div><action-text-attachment content-type=\"image\" url=\"https://kitt.lewagon.com/karr/karr.kitt/assets/protocols/websocket_create_cable-0b0a52c00c0c8e0577b8da3197ea9a412662e105cfd504d5261c60582ecf6f44.svg?program_id=1\" width=\"300\" height=\"143\"><figure class=\"attachment attachment--preview\">\n  <img width=\"300\" height=\"143\" src=\"https://kitt.lewagon.com/karr/karr.kitt/assets/protocols/websocket_create_cable-0b0a52c00c0c8e0577b8da3197ea9a412662e105cfd504d5261c60582ecf6f44.svg?program_id=1\">\n</figure></action-text-attachment></div><div>\n<strong><br>2. Setup client subscriber<br></strong><br>\n</div><div><action-text-attachment content-type=\"image\" url=\"https://kitt.lewagon.com/karr/karr.kitt/assets/protocols/websocket_connect-b46930fe972de0af195ace66a7f22c73d95a56557c18e6ab9e49ee4e8b86fd25.svg?program_id=1\" width=\"300\" height=\"143\"><figure class=\"attachment attachment--preview\">\n  <img width=\"300\" height=\"143\" src=\"https://kitt.lewagon.com/karr/karr.kitt/assets/protocols/websocket_connect-b46930fe972de0af195ace66a7f22c73d95a56557c18e6ab9e49ee4e8b86fd25.svg?program_id=1\">\n</figure></action-text-attachment></div><div>\n<strong><br>3. Broadcast data through the cable<br></strong><br>\n</div><div><action-text-attachment content-type=\"image\" url=\"https://kitt.lewagon.com/karr/karr.kitt/assets/protocols/websocket_broadcast-d4416f03617773be2c7c2273e46d44ac6f80518a029a579745fed4d979480e38.svg?program_id=1\" width=\"300\" height=\"143\"><figure class=\"attachment attachment--preview\">\n  <img width=\"300\" height=\"143\" src=\"https://kitt.lewagon.com/karr/karr.kitt/assets/protocols/websocket_broadcast-d4416f03617773be2c7c2273e46d44ac6f80518a029a579745fed4d979480e38.svg?program_id=1\">\n</figure></action-text-attachment></div>\n</div>\n"

lessons.each_with_index do |text, i|
  # binding.pry
  l = Lesson.new()
  l.content.body = text.html_safe
  l.study_module = StudyModule.new(
    name: "Part #{i + 1}",
    course: c,
    index: i + 1,
    )
  l.save!
end

####################
puts "AC quiz...."
answers = [{
            "correct": false,
            "text": "Make your website runs faster"
          },
          {
            "correct": true,
            "text": "Help you build real-time features"
          },
          {
            "correct": false,
            "text": "Help manage your database"
          },
          {
            "correct": false,
            "text": "I don't know!"
          }]

q = Quiz.new(text: "quiz?")
q.study_module = StudyModule.new(
  name: "Final Quiz",
  course: c,
  index: c.study_modules.last.index + 1,
)
q.save!

question = Question.create!(text: "What does actioncable do?", quiz: q)

question.answers.build(answers)
question.save!

####################
puts "AC lesson - youtube...."
lessons = []
lessons << "<div class=\"trix-content\">\n  <div>Watch this video:<br><span><action-text-attachment sgid=\"BAh7CEkiCGdpZAY6BkVUSSI4Z2lkOi8vY291cnNlLWNyZWF0b3IvWW91dHViZS9uUlA5MUMxdVgtdz9leHBpcmVzX2luBjsAVEkiDHB1cnBvc2UGOwBUSSIPYXR0YWNoYWJsZQY7AFRJIg9leHBpcmVzX2F0BjsAVDA=--78a8a5fe578e1aeeecf886e8d8c9814b096c828f\" content-type=\"application/octet-stream\"><div>\n  <iframe width=\"640\" height=\"360\" src=\"https://www.youtube.com/embed/nRP91C1uX-w\"></iframe>\n</div></action-text-attachment></span>\n</div>\n</div>\n"

lessons.each_with_index do |text, i|
  l = Lesson.new()
  l.content.body = text.html_safe
  l.study_module = StudyModule.new(
    name: "Going further",
    course: c,
    index: c.study_modules.last.index + 1,
    )
  l.save!
end

puts "....finished generating the whole ActionCable course"
########################################################################################
########################################################################################
puts "<--- --- Finished seeding!"
