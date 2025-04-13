class CreateTasks < ActiveRecord::Migration[7.2]
  def change
    create_table :tasks do |t|
      t.string :title, null: false
      t.text :description
      t.string :status, null: false, default: '未完了'
      t.date :due_date
      t.references :user, null: false, foreign_key: true
      t.timestamps
    end
  end
end
