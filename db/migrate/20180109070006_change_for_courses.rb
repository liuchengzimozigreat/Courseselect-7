class ChangeForCourses < ActiveRecord::Migration
  def change
    add_column :courses, :mark, :integer
  end
end
