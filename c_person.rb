
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

  class Voter < Person
    attr_accessor :affiliation, :voted
    def initialize(name, affiliation)
      @name = Person.new(name, affiliation).name
      @affiliation = affiliation
      @voted = false
    end
  end

  class Politician < Voter
   attr_accessor :party, :vote_count, :name
   def initialize(name, party)
     @name = Person.new(name, party).name
     @party = party
     @vote_count = 1
   end
  end
end
