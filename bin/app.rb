require 'json'
require 'pry'
require_relative '../config/environment'
require "tty-prompt"
@prompt = TTY::Prompt.new
@user = nil

def welcome_message
    puts "~~~~~~~~~~~~~~~~~~~~~~~~~"
    puts "} Welcome to BodyWork! {"
    puts "~~~~~~~~~~~~~~~~~~~~~~~~~"
    puts
    user_input 
end

def user_input
    user_input = @prompt.ask("What is your name?") do |q|
        q.required true
        q.validate /\A\w+\Z/
        q.modify   :capitalize
    end
    @user = User.find_name(user_input)
    personalized_message
end  

def personalized_message
    puts "Welcome, #{@user.name}!"
    main_menu
end

def main_menu
    selected_exercise = @prompt.select("What would you like to do?") do | menu |
        menu.choice "See All Exercises"
        menu.choice "See My Exercises"
        menu.choice "Create New Exercise"
        menu.choice "View My Stats"
        menu.choice "Exit"
    end
    if selected_exercise == "See All Exercises"
        all_exercises
    elsif selected_exercise == "See My Exercises"
        my_exercises
    elsif selected_exercise == "Create New Exercise"
        create_exercise
    elsif selected_exercise == "View My Stats"
        stat_menu
    else
        puts "See you next time!"
    end
end

def select_an_exercise(exercise_array)
    @prompt.select("Pick an exercise:") do | menu |
        exercise_array.each do | exercise |
            menu.choice exercise.name, exercise.id
        end
    end
end

def display_exercise(exercise_id)
    puts "Here is your chosen exercise:"
    exercise = Exercise.find_by(id: exercise_id)
    puts "#{exercise.name}"
    puts "Category: #{exercise.category}"
    puts "Instructions: #{exercise.instructions}"

    if record = Record.order('id desc').find_by(user_id: @user.id, exercise_id: exercise_id)
        puts "Last time, you completed #{record.sets} sets and #{record.total_reps} total reps at a weight of #{record.weight}lbs."
    end
end

def create_new_record?(exercise_id)
    create_new_record = @prompt.select("Would you like to log your exercise?") do | menu |
        menu.choice "Yes"
        menu.choice "No"
    end
        
    if create_new_record == "Yes"
        new_record(exercise_id)
    else
        main_menu
    end
end

def new_record(exercise_id)
    weight = @prompt.ask("Input the weight amount you used:", convert: :integer) do |q|
        q.convert :integer
        q.messages[:convert?] = "Please enter a number."
    end
    sets = @prompt.ask("How many sets did you do?", convert: :integer) do |q|
        q.convert :integer
        q.messages[:convert?] = "Please enter a number."
    end
    total_reps = @prompt.ask("Input your total reps:", convert: :integer) do |q|
        q.convert :integer
        q.messages[:convert?] = "Please enter a number."
    end
    Record.create(user_id: @user.id, exercise_id: exercise_id, weight: weight, sets: sets, total_reps: total_reps)
    view_recent_log
end
    
def view_recent_log
    puts "Your record was saved!"
    last_record = @user.records.last
    exercise = Exercise.find_by(id: last_record.id)
    puts "#{last_record.exercise.name}"
    puts "Weight: #{last_record.weight}"
    puts "Sets: #{last_record.sets}"
    puts "Total Reps: #{last_record.total_reps}"
    main_menu
end

def all_exercises
    all_exercises = Exercise.all
    exercise_id = select_an_exercise(all_exercises)
    display_exercise(exercise_id)
    create_new_record?(exercise_id)
end

def my_exercises
    user_exercises = @user.exercises.uniq
    exercise_id = select_an_exercise(user_exercises)
    display_exercise(exercise_id)
    create_new_record?(exercise_id)
end
    
def create_exercise
    exercise_name = @prompt.ask("What is the name of the exercise?")

    category = @prompt.select("What is the exercise category?") do | menu |
        menu.choice "Bodyweight"
        menu.choice "Abs"
        menu.choice "Upperbody"
        menu.choice "Lowerbody"
        menu.choice "Kettlebells"
    end

    instructions = @prompt.ask("Please include some instructions?")

    new_exercise = Exercise.create(name: exercise_name, category: category, instructions: instructions)

    puts "Here is your new exercise!"
    puts "#{new_exercise.name}"
    puts "Category: #{new_exercise.category}"
    puts "Instructions: #{new_exercise.instructions}"

    create_new_record?(new_exercise.id)
end

def stat_menu
    chosen_stat = @prompt.select("Pick a Stat") do | menu |
        menu.choice "Strongest Exercise"
        menu.choice "Weakest Exercise"
        menu.choice "My Personal Records"
        menu.choice "Back to Main Menu"
    end 
    if chosen_stat == "Strongest Exercise"
        strongest_exercise
    elsif chosen_stat == "Weakest Exercise"
        weakest_exercise
    elsif chosen_stat == "My Personal Records"
        personal_records
    elsif chosen_stat == "Back to Main Menu"
        main_menu
    end
end

def strongest_exercise
    max_weight = 0
    exercise_id = nil
    @user.records.each do |record| 
        if record.weight > max_weight
            max_weight = record.weight 
            exercise_id = record.exercise_id
        end  
    end 
    exercise = Exercise.find_by(id: exercise_id)
    puts "Your strongest exercise is #{exercise.name} at a weight of #{max_weight}lbs."  
    stat_menu    
end 

def weakest_exercise
    min_weight = 1000
    exercise_id = nil
    @user.records.each do |record| 
        if record.weight < min_weight
            min_weight = record.weight 
            exercise_id = record.exercise_id
        end  
    end 
    exercise = Exercise.find_by(id: exercise_id)
    puts "Your Weakest Exercise is #{exercise.name} at a weight of #{min_weight}lbs."
    stat_menu 
end
    
def personal_records
    user_exercises = @user.exercises.uniq
    exercise_id = select_an_exercise(user_exercises)
    @user.personal_record(exercise_id)
    stat_menu
end 

def run 
    welcome_message
end

run

0 #Necessary when placing a binding.pry on above line.