# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

1.upto(3) do |day|
  0.upto(23) do |hour|
    (0..59).step(5) do |minute|
      t = Time.new(2016, 1, day, hour, minute, 0)
      Rgb.create red: rand(255), green: rand(255), blue: rand(255),
                 created_at: t, updated_at: t
    end
  end
end
