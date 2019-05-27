# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
@user1 = User.create(email: 'test1@gmail.com', password: 'aaaaaa', password_confirmation: 'aaaaaa')
@user2 = User.create(email: 'test2@gmail.com', password: 'aaaaaa', password_confirmation: 'aaaaaa')

30.times do |n|
  post = @user1.posts.build
  post.memo = "#{n}"
  post.tag_list.add(n)
  post.link_list.add("https://example.com/#{n}")
  post.save
end

15.times do |n|
  post = @user2.posts.build
  post.memo = "#{n}"
  post.tag_list.add(n)
  post.link_list.add("https://example.com/#{n}")
  post.save
end