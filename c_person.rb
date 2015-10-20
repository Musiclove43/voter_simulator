
require_relative 'world_class'
module ClassPersonFactory


  class Person < World
      attr_accessor :name, :type

      def initialize(name, type)
        @name = name
        @type = :politician if type == "democrat" || type == "republican"
        @type = :voter if type == "tea party" || type == "conservative" || type == "neutral" || type == "liberal" || type == "socialist"
      end

  end
  # p person = Person.new('Joe Biden', 'Politician')
  # p person.name
  # p person.type



   class Voter < Person
    attr_accessor :affiliation, :voted
    def initialize(name, affiliation)
      @name = Person.new(name, affiliation).name
      @affiliation = affiliation
      @voted = false
    end

  end

  # voter = Voter.new('Bernie Sanders', 'Democrat')
  #
  # puts voter.name
  # puts voter.affiliation


  class Politician < Voter

   attr_accessor :party, :vote_count, :name
   def initialize(name, party)
     @name = Person.new(name, party).name
     @party = party
     @vote_count = 1
   end

  end

  # p hilary = Politician.new('Hilary Clinton', 'democrat')
  # h = Hash.new
  # h[:name] = hilary.name
  # h[:party] = hilary.party
  # a = Array.new
  # a << h
  # p a
end
