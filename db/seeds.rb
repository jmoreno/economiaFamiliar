# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.delete_all

user = User.new
user.email = 'jmoreno.zn@gmail.com'
user.password = 'piopioqueyonohesido'
user.password_confirmation = 'piopioqueyonohesido'
user.admin = true
user.save!

user = User.new
user.email = 'amreyg@hotmail.com'
user.password = 'vayalioelmontepio'
user.password_confirmation = 'vayalioelmontepio'
user.admin = true
user.save!

