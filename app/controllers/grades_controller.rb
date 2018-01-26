class GradesController < ApplicationController

  before_action :teacher_logged_in, only: [:update]

  def update
    @grade=Grade.find_by_id(params[:id])
    if @grade.update_attributes!(:grade => params[:grade][:grade])
      if @grade.grade==100
         @grade.gradepoint=5.0
      elsif @grade.grade>=95
         @grade.gradepoint=4.5
      elsif @grade.grade>=90
         @grade.gradepoint=4.0
      elsif @grade.grade>=85
         @grade.gradepoint=3.5
      elsif @grade.grade>=80
         @grade.gradepoint=3.0
      elsif @grade.grade>=75
         @grade.gradepoint=2.5
      elsif @grade.grade>=70
         @grade.gradepoint=2.0
      elsif @grade.grade>=65
         @grade.gradepoint=1.5
      elsif @grade.grade>=60
         @grade.gradepoint=1.0
      else @grade.gradepoint=0
      end
      @grade.save
      flash={:success => "#{@grade.user.name} #{@grade.course.name}的成绩已成功修改为 #{@grade.grade}"}
    else
      flash={:danger => "上传失败.请重试"}
    end
    redirect_to grades_path(course_id: params[:course_id]), flash: flash
  end

  def index
    if teacher_logged_in?
      @course=Course.find_by_id(params[:course_id])
      @grades=@course.grades
    elsif student_logged_in?
      @grades=current_user.grades
    else
      redirect_to root_path, flash: {:warning=>"请先登陆"}
    end
  end


  private

  # Confirms a teacher logged-in user.
  def teacher_logged_in
    unless teacher_logged_in?
      redirect_to root_url, flash: {danger: '请登陆'}
    end
  end

end
