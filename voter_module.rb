#-----------------------------------------Main_menu Module-------------------------------------
require_relative 'c_person'
require_relative 'world_class'
require_relative 'campaign_class'
include ClassPersonFactory


# require_relative "world_class"


module MainMenu
  def intro(world)
    puts "                             Welcome to Voter Simulator                   "
    puts "                  Here we will help you simulate your own election        "
    sleep (1)
    puts "What are you going to do?"
    menu_option(world)
  end
end

  #-----------------------------------------------------------------------------
def menu_option(world)
  puts
  puts "C)reate a politician or a voter"
  puts "L)ist all"
  puts "U)pdate a politician or voter"
  puts "V)ote"
  users_choice = gets.chomp.downcase
  case users_choice
  when "c"
    create(world)
  when "l"
    view_list(world)
  when "u"
    display_update(world)
  when "v"
    voter_simulator(world)
  else
    no_choice(world)
  end
end

#--------------------------------------------Create------------------------------------------------
def create(world)
  puts "Do you want to create a P)olitician or a V)oter?"
  create_choice = gets.chomp.downcase
  case create_choice
  when "p"
    ask_create_politician(world)
  when "v"
    ask_create_voter(world)
  else
    no_choice(world)
  end
end
# ------------------------------------------politician_create----------------------------------------
def ask_create_politician(world)
  puts "Please enter the name of the politician you wish to create (full name)."
  politician_name = gets.chomp.downcase
  puts "Please enter the politician's party(Democrat or Republican only)"
  politician_party = gets.chomp.downcase
  world.politician_create(politician_name, politician_party)
  intro(world)
end
#---------------------------------------------voter_create------------------------------------------
def ask_create_voter(world)
  puts "Please enter the name of the voter you wish to create."
  voter_name = gets.chomp.downcase
  puts "please enter the politcal affiliation of your voter."
  voter_affiliation = gets.chomp.downcase
  world.voter_create(voter_name, voter_affiliation)
  intro(world)
end
#-----------------------------------------------List------------------------------------------------------
def view_list(world)
  puts "Here is the list of all voters and politicians\n\n"
  world.list
  intro(world)
end
#----------------------------------------------update--------------------------------------------------
def display_update(world)
  puts "Please enter the name of the politician or voter you would like to update."
  ask_update = gets.chomp.downcase
  world.find_type(ask_update)
  change_type = gets.chomp.downcase
  puts "What would you like to change it to?"
  new_change = gets.chomp
  world.update(ask_update, change_type, new_change)
  puts "You have successfully changed #{ask_update} to #{new_change}."
  intro(world)
end
#----------------------------------------------Voter_Simulator----------------------------------------------
def voter_simulator(world)
  simulate = Campaign.new(world)
  simulate.start_campaign
end
#-------------------------------------------------no_choice-------------------------------------------------
def no_choice(world)
  puts "Oops you didnt enter a valid choice. Start over."
  intro(world)
end

include MainMenu
w = World.new
intro(w)
