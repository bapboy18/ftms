Fabricator(:course) do
  name {sequence(:name) {|i| "Course Master#{i + 1}"}}
  description {Faker::Lorem.sentence}
end
