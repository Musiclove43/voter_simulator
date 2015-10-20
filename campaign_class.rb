require 'faker'
#require_relative 'world_class'

class Campaign #< World
  attr_accessor :voter_list, :politician_list

  def initialize(world)
    @voter_list = world.voter_list
    @politician_list = world.politician_list
  end

  def start_campaign
    puts ""
    puts "Running election simulation. Please wait......"
    sleep(3)
    puts ""
    liberalness
    winner
  end

  def liberalness #assigns a numeric to represent affiliation as a value for liberalness
    @voter_list.each do |politics|
      case politics[:affiliation]
      when "tea party"
        liberalness_number = 10
      when "conservative"
        liberalness_number = 25
      when "neutral"
        liberalness_number = 50
      when "liberal"
        liberalness_number = 75
      when "socialist"
        liberalness_number = 90
      end
      party_vote(liberalness_number)
    end
  end

  def party_vote(libnumber) #Determins which party to vote for based on liberalness
    party_vote = (rand(1..100) <= libnumber) ? "democrat" : "republican"
    case party_vote
    when "democrat"
      create_democrat_ballot
      pick_btw_democrat
    when "republican"
      create_republican_ballot
      pick_btw_republicans
    end
  end

  def create_democrat_ballot
    @democrat_on_ballot = (@politician_list.select {|whose| whose[:party] == "democrat"})
  end

  def pick_btw_democrat
    dem_vote = @democrat_on_ballot.sample #this pulls random democrat
    cast_vote(dem_vote)
  end

  def create_republican_ballot
    @republicans_on_ballot = (@politician_list.select {|whose| whose[:party] == "republican"})
  end

  def pick_btw_republicans
    rep_vote = @republicans_on_ballot.sample
    p rep_vote
    cast_vote(rep_vote)
  end

  def cast_vote(politician)
    politician[:vote_count] += 1 #accessing the candidate's vote_count created in the class
  end

  def winner
    puts "****************************************************"
    puts "******************Election Results******************"
    puts "****************************************************"
    politician_list.each do |candidate|
      puts "#{candidate[:name]}, #{candidate[:party].capitalize}, received #{candidate[:vote_count]} votes."
    end
    winner = politician_list.max_by{|x| x[:vote_count]}
    sleep(2)
    puts "****************************************************"
    puts "The winner is #{winner[:name]}!"
    puts "****************************************************"
    run_again
  end

  def run_again
    puts "Would you like to run the simulation again? (y/n)"
    print ""
    puts again = gets.chomp
    case again
    when "y"
      start_campaign
    else
      abort
    end
  end

end

#-----------------------------create fake voters_list to test ------------------
# def create_all_voters(t, c, n, l, s)
#   names = (t+l+n+s+c).times.map {Faker::Name.name}
#   all = []
#   all << Array.new(t, "Tea Party".downcase)
#   all << Array.new(l, "Liberal".downcase)
#   all << Array.new(n, "Neutral".downcase)
#   all << Array.new(s, "Socialist".downcase)
#   all << Array.new(c, "Conservative".downcase)
#   all.flatten!
#   keys = [:name, :affiliation, :voted]
#   values = []
#   names.each_with_index.map do |name, index|
#     values << [name, all[index], 'false']
#   end
#   values.map{|r| Hash[r.zip(keys)].invert }
# end
# #-----------------------------create fake politician_list to test---------------
# def create_all_politicians(number_of_democrats, number_of_republicans)
#   politician_names = (number_of_democrats+number_of_republicans).times.map {Faker::Name.name}
#   all = []
#   all << Array.new(number_of_democrats, "democrat")
#   all << Array.new(number_of_republicans, "republican")
#   all.flatten!
#   keys = [:name, :party, :vote_count]
#   politician_values = []
#   politician_names.each_with_index.map do |name, index|
#     politician_values << [name, all[index], 1]
#   end
#   politician_list = politician_values.map{|r| Hash[r.zip(keys)].invert }
# end
# #-------------------------------populate fake data------------------------------
# politician_list = create_all_politicians(2,2)
# voter_list = create_all_voters(2,35,20,28, 30)
#-----------------------------------call methods--------------------------------
#
# simulate = Campaign.new#(voter_list, politician_list)
# simulate.start_campaign
