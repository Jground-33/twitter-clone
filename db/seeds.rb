# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.create!( name: "admin",
              email: "example@railstutorial.org", 
              password: "fizzbuzz", 
              password_confirmation: "fizzbuzz", 
              admin: true,
              activated: true,
              activated_at: Time.zone.now )

50.times do |n| 
  name = Faker::Name.name
  email = "example-#{n+1}@railstutorial.org"
  password = "password"
  
  User.create(name: name, 
              email: email, 
              password: password, 
              password_confirmation: password,
              activated: true,
              activated_at: Time.zone.now )
end

# creates microposts 
users = User.order(:created_at).take(6)
  25.times do 
    content = Faker::Lorem.sentence(word_count: 10)
    users.each { |user| user.microposts.create!(content: content)}
  end

  #  creates following relationships
  users = User.all
  user = User.first
  following = users[2..50]
  followers = users[3..40]
  following.each { |followed| user.follow(followed) }
  followers.each { |follower| follower.follow(user) }