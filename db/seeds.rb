# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
product1=Product.create!(name:"product1")
product1.gen_image_from_path(path:'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcSNG7XDGjC4LjvDZt9egxGrq-oIHgSMAEftk02sPnxTKfrI-bDl', filename: 'kidlat_tahimik.jpg', content_type: 'image/jpg')
