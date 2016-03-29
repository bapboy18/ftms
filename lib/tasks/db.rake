namespace :db do
  desc "remake database data"
  task remake_data: :environment do
    Rake::Task["db:migrate:reset"].invoke

    puts "Creating Role"
    ["admin", "trainer"].each do |name|
      Fabricate :role, name: name, allow_access_admin: true
    end
    Fabricate :role, name: "trainee", allow_access_admin: false

    puts "Creating User"
    Fabricate :user, email: "admin@tms.com", role_id: 1
    Fabricate :user, email: "supervisor@tms.com", role_id: 2
    30.times do
      Fabricate :user
    end

    puts "Creating CourseMaster and Course"
    5.times do
      Fabricate :course
    end
    Course.each do |course_master|
      2.times do
        Fabricate :course, name: course_master.name,
          description: course_master.description, parent_id: course_master.id
      end
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

    puts "Creating Permissions"
    Fabricate :permission, model_class: "CourseMaster", role_id: 1
    ["Course", "CourseSubject", "Subject", "UserSubject"].each do |name|
      Fabricate :permission, model_class: name, action: "manage", role_id: 2
    end
    ["update", "show"].each do |name|
      Fabricate :permission, model_class: "UserSubject", action: name
      Fabricate :permission, model_class: "UserTask", action: name
      Fabricate :permission, model_class: "User", action: name
    end

    puts "Create Rank"
    5.times do
      Fabricate :rank
    end
  end
end
