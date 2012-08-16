# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Emanuel', :city => cities.first)

# Category.destroy_all
# 
# Category.create(:name => 'CELEBRITIES')
# Category.create(:name => 'COLLECTIBLES')
# Category.create(:name => 'CONSUMER PRODUCTS')
# Category.create(:name => 'CLUBS & HOBBIES')
# Category.create(:name => 'ENTERTAINMENT')
# Category.create(:name => 'FADS')
# Category.create(:name => 'FAMILY')
# Category.create(:name => 'FASHION & STYLE')
# Category.create(:name => 'FOOD & DRINK')
# Category.create(:name => 'HOLIDAYS')
# Category.create(:name => 'NEWS')
# Category.create(:name => 'NIGHTLIFE')
# Category.create(:name => 'PETS')
# Category.create(:name => 'SCHOOL')
# Category.create(:name => 'SEASONAL')
# Category.create(:name => 'SPORTS')
# Category.create(:name => 'TECHNOLOGY')
# Category.create(:name => 'THE FIRST TIME')
# Category.create(:name => 'TRANSPORTATION')
# Category.create(:name => 'TRAVEL & VACATIONS')
# Category.create(:name => 'TOYS & GAMES')
# Category.create(:name => 'OTHER')


categories = ["BOOKS & MAGAZINES", "CARS & CYCLES", "EVENTS", "FRIENDS", "GADGETS", "HOME", "MOVIES", "MUSIC", "PERSONAL CARE", "POLITICIANS", "RECREATION", "RELIGION", "SHOPPING", "SMELLS", "SNACKS", "TELEVISION & RADIO", "WORK", "WILD TIMES"]

categories.each do |c|
  Category.find_or_create_by_name(c)
end