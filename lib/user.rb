require 'pry'
class User < ActiveRecord::Base
    has_many :records
    has_many :exercises, through: :records 

    def self.find_name(user_name)
       user = self.find_by(name: user_name)
       if !user
        new_user = self.create(name: user_name)
       else
        user
       end
    end 

    def personal_record(exercise_id)
        exercise_array = self.records.select do | record |
            record.exercise_id == exercise_id
        end 
        weights_array = exercise_array.map do | record |
            record.weight
        end 
        max_weight = weights_array.max 
    end 

    def strongest_exercise
        max_weight = 0
        exercise_id = nil
        self.records.each do |record| 
            if record.weight > max_weight
                max_weight = record.weight 
                exercise_id = record.exercise_id
            end  
        end 
        exercise = Exercise.find_by(id: exercise_id)
        puts "Your strongest exercise is #{exercise.name} at a weight of #{max_weight}lbs."     
    end 
    
    def weakest_exercise
        min_weight = Float::INFINITY
        exercise_id = nil 
        user_exercises = self.exercises.uniq
        weights_array = user_exercises.each do | exercise |
            pr = self.personal_record(exercise.id)
            if pr < min_weight
                min_weight = pr
                exercise_id = exercise.id
            end
        end
        exercise = Exercise.find_by(id: exercise_id)
        puts "Your Weakest Exercise is #{exercise.name} at a weight of #{min_weight}lbs."
    end
end 