class CreateTasks < ActiveRecord::Migration[8.0]
  def change
    create_table :tasks do |t|
      t.string    :description
      t.integer   :status
      t.datetime  :due_at

      t.timestamps
    end
  end
end
