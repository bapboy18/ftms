class Admin::ChangeStatusUserSubjectsController.rb < ApplicationController
  load_and_authorize_resource :user_subject

  def update
    if @user_subject.init?
      @user_subject.start_user_subject
    elsif @user_subject.progress?
      @user_subject.finish_user_subject
      flash[:success] = flash_message "finish_user_subject"
    else
      flash[:failed] = flash_message "user_subject_not_update"
    end
  end
end
