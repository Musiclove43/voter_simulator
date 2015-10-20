
# require_relative 'voter_module'
# require_relative 'c_person'
# include MainMenu
# include ClassPersonFactory
require 'faker'

class World
  attr_accessor :republicans_on_ballot, :democrats_on_ballot, :tea_party_members, :conservatives, :neutrals, :liberals, :socialists, :overall_winner, :votes, :VOTER_ASSOCIATIONS, :politician_list, :voter_list

  def initialize
    #People type aggregate
    @voter_list = []#create_all_voters(12,1,3,5,6)
    @politician_list = []#create_all_politicians(10,12)
    @all_people = [@voter_list, @politician_list].flatten!

    #candidates by category
    @republicans_on_ballot = []
    @democrats_on_ballot = []

    #affiliation membership
    @tea_party_members = []
    @conservatives = []
    @neutrals = []
    @liberals = []
    @socialists = []

    #winners
    @republican_winner = []
    @democratic_winner = []
    @overall_winner = []

    #all votes
    @votes = []

    #probabilities and relationships
    @TEA_PARTY_PROBABLITY = {republican: 90, democrat: 10}
    @CONSERVATIVE_PROBABLITY = {republican: 75, democrat: 25}
    @NEUTRAL_PROBABLITY = {republican: 50, democrat: 50}
    @LIBERAL_PROBABLITY = {republican: 25, democrat: 75}
    @SOCIALIST_PROBABLITY = {republican: 10, democrat: 90}
    @VOTER_ASSOCIATIONS = [{party: @tea_party_members, prob: @TEA_PARTY_PROBABLITY},
                          {party: @conservatives, prob: @CONSERVATIVE_PROBABLITY},
                          {party: @neutrals, prob: @NEUTRAL_PROBABLITY},
                          {party: @liberals, prob: @LIBERAL_PROBABLITY},
                          {party: @socialists, prob: @SOCIALIST_PROBABLITY}]

  end

  def simulation
    categorize_politicians
    categorize_voters
    @republican_winner = @republicans_on_ballot.sample
    @democratic_winner = @democrats_on_ballot.sample
    @VOTER_ASSOCIATIONS.each do |association|
      association[:party].length.times {cast_vote(association[:prob])}
    end
    if @votes.count(1) > @votes.size/2
      @overall_winner << @republican_winner
    elsif @votes.count(1) == @votes.size/2
      puts "There was a draw! RECOUNT AND MAKE HISTORY!"
      simulation
    else
      @overall_winner << @democratic_winner
    end
  end

  def politician_create(name, party)
    x = Politician.new(name, party)
    h = Hash.new
    h[:name] = x.name
    h[:party] = x.party
    h[:vote_count] = 1
    @politician_list << h
    @all_people << h
  end

  def voter_create(name, affiliation)
    v = Voter.new(name, affiliation) #gets information and transfers to appropriate list
    h = Hash.new
    h[:name] = v.name
    h[:affiliation] = v.affiliation
    @voter_list << h
    @all_people << h
  end

  def list
    puts "Here are the politicans:"
    @politician_list.each do |politician|
      puts "Name: #{politician[:name]}  Party: #{politician[:party]}"
    end
    puts "\nHere are the voters:"
    @voter_list.each do |voter|
      puts "Name: #{voter[:name]} Affiliation: #{voter[:affiliation]}"
    end
  end

  def update(name, change_type, new_change)
    person_to_change = @all_people.select {|hash| hash[:name].downcase == name}
    person_to_change[0][:name] = person_to_change[0][:name].downcase
    case change_type
      when "p"
        politician_found = @politician_list.select {|hash| person_to_change[0][:name] == hash[:name].downcase}
        politician_found[0][:party] = new_change
      when "n"
        if @politician_list.select {|politician| politician[:name] == name}.empty? == false
          politician_foundname = @politician_list.select {|hash| person_to_change[0][:name] == hash[:name].downcase}
          politician_foundname[0][:name] = new_change
        else
          voter_foundname = @voter_list.select {|hash| person_to_change[0][:name] == hash[:name].downcase}
          voter_foundname[0][:name] = new_change
          p @voter_list
        end
      when "a"
        voter_found = @voter_list.select {|hash| person_to_change[0][:name] == hash[:name].downcase}
        voter_found[0][:affiliation] = new_change
    end
  end

  def find_type(name)
    p name
    name_to_change = @all_people.select {|hash| hash[:name].downcase == name}
    p name_to_change
    a = name_to_change[0].keys
    if a.include? :affiliation
      puts "New (n)ame or new (a)ffiliation?"
    else
      puts "New (n)ame or new (p)arty?"
    end
  end

private
  def create_all_politicians(reps, dems)
    names = (reps+dems).times.map {Faker::Name.name}
    keys = [:name, :party, :vote_count]
    all = []
    all << Array.new(reps, "republican")
    all << Array.new(dems, "democrat")
    all.flatten!
    values = []
    names.each_with_index.map do |name, index|
      values << [name, all[index], 1]
    end
    values.map{|r| Hash[r.zip(keys)].invert }
  end

  def create_all_voters(t, c, n, l, s)
    names = (t+l+n+s+c).times.map {Faker::Name.name}
    all = []
    all << Array.new(t, "tea party")
    all << Array.new(l, "liberal")
    all << Array.new(n, "neutral")
    all << Array.new(s, "socialist")
    all << Array.new(c, "conservative")
    all.flatten!
    keys = [:name, :affiliation]
    values = []
    names.each_with_index.map do |name, index|
      values << [name, all[index]]
    end
    values.map{|r| Hash[r.zip(keys)].invert }
  end


  def categorize_politicians
    @politician_list.each do |politician|
      if politician[:party] == "democrat"
        @democrats_on_ballot << politician
      elsif politician[:party] == "republican"
        @republicans_on_ballot << politician
      end
    end
  end

  def categorize_voters
    @voter_list.each do |voter|
      case voter[:affiliation]
      when "tea party"
        @tea_party_members << voter
      when "conservative"
        @conservatives << voter
      when "neutral"
        @neutrals << voter
      when "liberal"
        @liberals << voter
      when "socialist"
        @socialists << voter
      end
    end
  end

  def cast_vote(prob_type)
    reps = Array.new(prob_type[:republican],1)
    deps = Array.new(prob_type[:democrat],0)
    all = (reps << deps).flatten!
    vote = all.sample
     if vote == 1
       @votes << 1
     else
       @votes << 0
     end
  end
end
