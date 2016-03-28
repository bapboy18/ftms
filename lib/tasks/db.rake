namespace :db do
  desc "remake database data"
  task remake_data: :environment do
    Rake::Task["db:migrate:reset"].invoke

    puts "Creating Role"
    ["admin", "trainer"].each do |name|
      Fabricate :role, name: name, allow_access_admin: true
    end
    Fabricate :role, name: "trainee", allow_access_admin: false

    puts "Creating Permissions"
    Fabricate :permission, model_class: "CourseMaster", role_id: 1
    Fabricate :permission, model_class: "Task", role_id: 3
    ["Course", "CourseSubject", "Subject", "UserSubject"].each do |name|
      Fabricate :permission, model_class: name, action: "manage", role_id: 2
    end
    ["UserSubject", "UserTask", "User"].each do |name|
      Fabricate :permission, model_class: name, action: "update", role_id: 3
    end
    ["Course", "Subject", "Task", "UserCourse", "UserSubject", "UserTask", "User"].each do |name|
      Fabricate :permission, model_class: name, action: "read", role_id: 3
    end

    puts "Creating User"
    Fabricate :user, email: "admin@tms.com", role_id: 1
    Fabricate :user, email: "supervisor@tms.com", role_id: 2
    30.times do
      Fabricate :user
    end

    puts "Creating Subject"
    10.times do
      Fabricate :subject
    end

    puts "Creating Evaluation Template"
    5.times do
      Fabricate :evaluation_template
    end

    puts "Creating Task Master"
    5.times do
      Fabricate :task_master
    end

    puts "Create Rank"
    5.times do
      Fabricate :rank
    end
  end
end
