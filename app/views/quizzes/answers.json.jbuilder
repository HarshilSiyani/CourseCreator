json.id @quiz.id
json.answers @answers do |answer|
  json.id answer.id
  json.correct answer.correct
  json.question_id answer.question_id
end
