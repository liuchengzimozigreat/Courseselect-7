class CoursesController < ApplicationController

  before_action :student_logged_in, only: [:select, :quit, :list, :assess, :evaluate]
  before_action :teacher_logged_in, only: [:new, :create, :edit, :destroy, :update, :open, :close]#add open by qiao
  before_action :logged_in, only: :index

  #-------------------------for teachers----------------------

  def new
    @course=Course.new
  end

  def create
    @course = Course.new(course_params)
    if @course.save
      current_user.teaching_courses<<@course
      redirect_to courses_path, flash: {success: "新课程申请成功"}
    else
      flash[:warning] = "信息填写有误,请重试"
      render 'new'
    end
  end

  def edit
    @course=Course.find_by_id(params[:id])
  end

  def update
    @course = Course.find_by_id(params[:id])
    if @course.update_attributes(course_params)
      flash={:info => "更新成功"}
    else
      flash={:warning => "更新失败"}
    end
    redirect_to courses_path, flash: flash
  end

  def open
    @course=Course.find_by_id(params[:id])
    @course.update_attributes(open: true)
    redirect_to courses_path, flash: {:success => "已经成功开启该课程:#{ @course.name}"}
  end

  def close
    @course=Course.find_by_id(params[:id])
    @course.update_attributes(open: false)
    redirect_to courses_path, flash: {:success => "已经成功关闭该课程:#{ @course.name}"}
  end

  def destroy
    @course=Course.find_by_id(params[:id])
    current_user.teaching_courses.delete(@course)
    @course.destroy
    flash={:success => "成功删除课程: #{@course.name}"}
    redirect_to courses_path, flash: flash
  end

  #-------------------------for students----------------------
  def analysis
    @mark = 0
    @grade1 = params[:grade1]
    @grade2 = params[:grade2]
    @grade3 = params[:grade3]
    @grade4 = params[:grade4]
    @grade5 = params[:grade5]
    @mark = @grade1.to_i + @grade2.to_i + @grade3.to_i + @grade4.to_i + @grade5.to_i
    @course = current_user.courses
    return @course,@mark
  end

  def list
    #-------QiaoCode--------
    @course=Course.where(:open=>true)
    @course=@course-current_user.courses
    tmp=[]
    @course.each do |course|
      if course.open==true
        tmp<<course
      end
    end
    @course=tmp
  end
  
  def query
    @course=Course.where("name like ?","%#{params[:courseName]}%")
    @course=@course+(Course.where("credit like ?","%#{params[:courseName]}%")-@course)
    @course=@course+(Course.where("course_time like ?","%#{params[:courseName]}%")-@course)
    @course=@course+(Course.where("course_type like ?","%#{params[:courseName]}%")-@course)
    @course=@course+(Course.where("course_week like ?","%#{params[:courseName]}%")-@course)
    @course=@course+(Course.where("exam_type like ?","%#{params[:courseName]}%")-@course)
    @course=@course+(Course.where("teaching_type like ?","%#{params[:courseName]}%")-@course)
    @course=@course-current_user.courses
    tmp=[]
    @course.each do |course|
      if course.open==true
        tmp<<course
      end
    end
    @course=tmp
  end
  
  def assess
    #-------QiaoCode--------
    @course=current_user.courses
    tmp=[]
    @course.each do |course|
      tmp<<course
    end
    @course=tmp
  end
  
  def evaluate
    @course = Course.find_by_id(params[:id])
  end

  def select
    @course=Course.find_by_id(params[:id])
    conflict,conflictcourse=timeconflict(@course)
    if @course.student_num+1<=@course.limit_num and conflict
      current_user.courses<<@course
      @course.student_num=@course.student_num+1
      @course.save
      flash={:suceess => "成功选择课程: #{@course.name}"}
      redirect_to courses_path, flash: flash
    else
      if @course.student_num+1>@course.limit_num 
        flash={:alert => "#{@course.name}已达人数上限"}
      else
        flash={:alert => "#{@course.name} 与 #{conflictcourse.name} 上课时间冲突"}
      end
      redirect_to list_courses_path, flash: flash
    end
  end
    
  def timeconflict(newcourse)  #若不冲突返回true，否则返回false
    newminweek=100
    newmaxweek=0
    newmintime=100
    newmaxtime=0
    fminweek=100
    fmaxweek=0
    fmintime=100
    fmaxtime=0
    if newcourse.course_week.strip.length==5  #提取新课程最大最小周
      newminweek=newcourse.course_week[1].to_i
      newmaxweek=newcourse.course_week[3].to_i
    elsif newcourse.course_week.strip.length==6
      newminweek=newcourse.course_week[1].to_i
      newmaxweek=newcourse.course_week[3].to_i*10+newcourse.course_week[4].to_i
    elsif newcourse.course_week.strip.length==7
      newmaxweek=newcourse.course_week[1].to_i*10+newcourse.course_week[2].to_i
      newmaxweek=newcourse.course_week[4].to_i*10+newcourse.course_week[5].to_i
    else
      newminweek=80
      newmaxweek=0
    end
    if newcourse.course_time.strip.length==7 #提取新课程上课时间中的开始与结束节数
      newmintime=newcourse.course_time[3].to_i
      newmaxtime=newcourse.course_time[5].to_i
    elsif newcourse.course_time.strip.length==8
      newmintime=newcourse.course_time[3].to_i
      newmaxtime=newcourse.course_time[5].to_i*10+newcourse.course_time[6].to_i
    end
    current_user.courses.each do |f|
      if f.course_week.strip.length==5  #提取已有课程最大最小周
        fminweek=f.course_week[1].to_i
        fmaxweek=f.course_week[3].to_i
      elsif f.course_week.strip.length==6
        fminweek=f.course_week[1].to_i
        fmaxweek=f.course_week[3].to_i*10+f.course_week[4].to_i
      elsif f.course_week.strip.length==7
        fmaxweek=f.course_week[1].to_i*10+f.course_week[2].to_i
        fmaxweek=f.course_week[4].to_i*10+f.course_week[5].to_i
      else
        fminweek=80
        fmaxweek=0
      end
      if newmaxweek < fminweek or fmaxweek < newminweek
        next
      else
        if newcourse.course_time[1] != f.course_time[1]  #比较是否在一周的同一天
          next
        else
          if f.course_time.strip.length==7   #提取已有课程上课时间中的开始与结束节数
            fmintime=f.course_time[3].to_i
            fmaxtime=f.course_time[5].to_i
          elsif f.course_time.strip.length==8
            fmintime=f.course_time[3].to_i
            fmaxtime=f.course_time[5].to_i*10+newcourse.course_time[6].to_i
          end
          if fmaxtime < newmintime or newmaxtime<fmintime
            next
          else 
            return false,f
          end
        end
      end
    end
    return true,nil
  end

  def quit
    @course=Course.find_by_id(params[:id])
    current_user.courses.delete(@course)
    flash={:success => "成功退选课程: #{@course.name}"}
    if @course.student_num>0
      @course.student_num=@course.student_num-1
      @course.save
    end
    redirect_to courses_path, flash: flash
  end
  
  def check
    @course=Course.find_by_id(params[:id])
  end

  #-------------------------for both teachers and students----------------------

  def index
    @course=current_user.teaching_courses if teacher_logged_in?
    @course=current_user.courses if student_logged_in?
  end


  private

  # Confirms a student logged-in user.
  def student_logged_in
    unless student_logged_in?
      redirect_to root_url, flash: {danger: '请登陆'}
    end
  end

  # Confirms a teacher logged-in user.
  def teacher_logged_in
    unless teacher_logged_in?
      redirect_to root_url, flash: {danger: '请登陆'}
    end
  end

  # Confirms a  logged-in user.
  def logged_in
    unless logged_in?
      redirect_to root_url, flash: {danger: '请登陆'}
    end
  end

  def course_params
    params.require(:course).permit(:course_code, :name, :course_type, :teaching_type, :exam_type,
                                   :credit, :limit_num, :class_room, :course_time, :course_week)
  end


end
