User.destroy_all
Exercise.destroy_all
Record.destroy_all

kirsty = User.new(name: "Kirsty")
kirsty.save
romina = User.create(name: "Romina")

bw_pull_up = Exercise.create(name: "Pull-up", category: "Bodyweight", instructions: "https://www.google.com/url?client=internal-element-cse&cx=002443720644516542879:b1ngobnwydy&q=https://www.acefitness.org/education-and-resources/lifestyle/exercise-library/191/pull-ups/&sa=U&ved=2ahUKEwj4yNrypK3tAhXUQzABHaLMAz0QFjAAegQIBhAB&usg=AOvVaw239E9KOuPuMj2XBMy3qCWo")
bw_squat = Exercise.create(name: "Squat", category: "Bodyweight", instructions: "https://www.acefitness.org/education-and-resources/lifestyle/exercise-library/135/bodyweight-squat/")
crunch = Exercise.create(name: "Crunches", category: "Bodyweight", instructions: "https://www.google.com/url?client=internal-element-cse&cx=002443720644516542879:b1ngobnwydy&q=https://www.acefitness.org/education-and-resources/lifestyle/exercise-library/52/crunch/&sa=U&ved=2ahUKEwj3_r_Tpa3tAhWswVkKHQwXBDMQFjAAegQIAxAB&usg=AOvVaw0aLxSSEvnvfraW6SUT7FMy")

record1 = Record.create(user_id: kirsty.id, exercise_id: bw_pull_up.id, weight: 4, sets: 3, total_reps: 15)
record2 = Record.create(user_id: romina.id, exercise_id: bw_squat.id, weight: 2, sets: 3, total_reps: 45)
record3 = Record.create(user_id: kirsty.id, exercise_id: crunch.id, weight: 5, sets: 3, total_reps: 45)
record4 = Record.create(user_id: romina.id, exercise_id: crunch.id, weight: 1, sets: 4, total_reps: 30)

puts "Seeds is running!"