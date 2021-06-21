class CreateRecords < ActiveRecord::Migration[6.0]
  def change
    create_table :records do |t|
      t.integer :user_id
      t.integer :exercise_id
      t.integer :weight
      t.integer :sets
      t.integer :total_reps
      t.timestamps
    end
  end
end
