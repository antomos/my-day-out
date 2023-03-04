# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
TestEvent.destroy_all
TestEvent.create!(title: "Restaurant", description: Faker::Lorem.paragraph_by_chars(number: 100, supplemental: false),address: Faker::Address.full_address, duration: [15,30,45,60].sample, image_url: "https://images.unsplash.com/photo-1592417817038-d13fd7342605?crop=entropy&cs=tinysrgb&fit=crop&fm=jpg&h=900&ixid=MnwxfDB8MXxyYW5kb218MHx8cmVzdGF1cmFudHx8fHx8fDE2Nzc2MDAzNzA&ixlib=rb-4.0.3&q=80&utm_campaign=api-credit&utm_medium=referral&utm_source=unsplash_source&w=1600")
TestEvent.create!(title: "Museum", description: Faker::Lorem.paragraph_by_chars(number: 100, supplemental: false),address: Faker::Address.full_address, duration: [15,30,45,60].sample, image_url: "https://images.unsplash.com/photo-1592825653663-89d1a1fe9923?crop=entropy&cs=tinysrgb&fit=crop&fm=jpg&h=900&ixid=MnwxfDB8MXxyYW5kb218MHx8bXVzZXVtfHx8fHx8MTY3NzYwMDMyMg&ixlib=rb-4.0.3&q=80&utm_campaign=api-credit&utm_medium=referral&utm_source=unsplash_source&w=1600")
TestEvent.create!(title: "Park", description: Faker::Lorem.paragraph_by_chars(number: 100, supplemental: false),address: Faker::Address.full_address, duration: [15,30,45,60].sample, image_url: "https://images.unsplash.com/photo-1633254103625-44068cceeb0a?crop=entropy&cs=tinysrgb&fit=crop&fm=jpg&h=900&ixid=MnwxfDB8MXxyYW5kb218MHx8cGFya3x8fHx8fDE2Nzc2MDAyMzM&ixlib=rb-4.0.3&q=80&utm_campaign=api-credit&utm_medium=referral&utm_source=unsplash_source&w=1600")
TestEvent.create!(title: "Shop", description: Faker::Lorem.paragraph_by_chars(number: 100, supplemental: false),address: Faker::Address.full_address, duration: [15,30,45,60].sample, image_url: "https://images.unsplash.com/photo-1443884590026-2e4d21aee71c?crop=entropy&cs=tinysrgb&fit=crop&fm=jpg&h=900&ixid=MnwxfDB8MXxyYW5kb218MHx8c2hvcHx8fHx8fDE2Nzc1OTk5Njk&ixlib=rb-4.0.3&q=80&utm_campaign=api-credit&utm_medium=referral&utm_source=unsplash_source&w=1600")
TestEvent.create!(title: "Bar", description: Faker::Lorem.paragraph_by_chars(number: 100, supplemental: false), address: Faker::Address.full_address, duration: [15,30,45,60].sample, image_url: "https://images.unsplash.com/photo-1516997121675-4c2d1684aa3e?crop=entropy&cs=tinysrgb&fit=crop&fm=jpg&h=900&ixid=MnwxfDB8MXxyYW5kb218MHx8YmFyfHx8fHx8MTY3NzU5OTg1MA&ixlib=rb-4.0.3&q=80&utm_campaign=api-credit&utm_medium=referral&utm_source=unsplash_source&w=1600")
puts "Created #{TestEvent.count} events"
