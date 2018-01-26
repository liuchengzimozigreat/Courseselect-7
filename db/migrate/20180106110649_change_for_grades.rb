class ChangeForGrades < ActiveRecord::Migration
  def change
    add_column :grades, :gradepoint, :float
  end
end
