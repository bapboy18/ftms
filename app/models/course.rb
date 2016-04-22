class Course < ActiveRecord::Base
  include PublicActivity::Model
  include InitUserSubject
  mount_uploader :image, ImageUploader

  has_many :activities, as: :trackable, class_name: "PublicActivity::Activity", dependent: :destroy

  validate :check_day_present, on: [:create, :update]
  validate :check_end_date, on: [:create, :update]

  validates :start_date, presence: true
  validates :end_date, presence: true

  has_many :course_subjects, dependent: :destroy
  has_many :user_courses, dependent: :destroy
  has_many :user_subjects, dependent: :destroy
  has_many :users, through: :user_courses
  has_many :subjects, through: :course_subjects
  has_many :documents, as: :documentable

  belongs_to :programming_language

  enum status: [:init, :progress, :finish]

  scope :recent, ->{order created_at: :desc}

  scope :active_course, ->{where status: "progress"}

  accepts_nested_attributes_for :user_courses, allow_destroy: true
  accepts_nested_attributes_for :documents,
    reject_if: proc {|attributes| attributes["content"].blank?}, allow_destroy: true

  USER_COURSE_ATTRIBUTES_PARAMS = [user_courses_attributes: [:id, :user_id, :_destroy]]
  COURSE_ATTRIBUTES_PARAMS = [:name, :content, :image, :description,
    :programming_language_id,
    :start_date, :end_date, documents_attributes:
    [:id, :name, :content, :_destroy], subject_ids: []]

  delegate :name, to: :programming_language, prefix: true, allow_nil: true

  def active_user_courses_when_start_course
    user_courses.update_all active: true
  end

  def check_day_present
    unless self.start_date.nil?
      self.errors.add :start_date, I18n.t("error.wrong_date") if
        self.start_date.to_date < Date.today
    end
  end

  def check_end_date
    unless self.start_date.nil?
      errors.add :end_date, I18n.t("error.wrong_end_date") if
        self.end_date < self.start_date
    end
  end

  def start_course current_user
    self.update_attributes status: :progress
    active_user_courses_when_start_course
    create_activity key: "course.start_course", owner: current_user
  end

  def finish_course current_user
    self.update_attributes status: :finish
    self.user_subjects.update_all(status: Course.statuses[:finish])
    create_activity key: "course.finish_course", owner: current_user
  end

  def load_trainers
    users.trainers
  end

  def load_trainees
    users.trainees
  end
end
