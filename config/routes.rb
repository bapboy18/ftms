Rails.application.routes.draw do
  filter :locale
  root "courses#show"
  devise_for :users, path: "auth", path_names: {sign_in: "login", sign_out: "logout"}

  namespace :admin do
    resources :course_masters
    resources :course_subjects, only: :update
    resources :courses do
      resource :assign_trainees
      resource :change_status_courses, only: :update
      resources :user_subjects do
        resource :change_status_user_subjects, only: :update
      end
    end
    resources :subjects
  end

  resources :courses, only: :show do
    resources :subjects, only: [:show, :update] do
      patch "/:status" => "subjects#update", as: :finish_subject
    end
    resources :user_subjects, only: :update
  end
  resources :users, only: [:edit, :update, :show]
  resources :subjects, only: [:show]
  resources :user_tasks
end
