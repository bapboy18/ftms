class Admin::UserSubjectsController < ApplicationController
  before_action :load_course

  def show
    @user_courses = @course.user_courses
    @users = @user_courses.map(&:user).uniq
    @course_subjects = @course.course_subjects
    @subjects = @course_subjects.map(&:subject).uniq
  end

  private
  def load_course
    @course = Course.find params[:id]
  end
end
