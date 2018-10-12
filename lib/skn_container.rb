# ##
#
# Credits: Inspired by: andyholland1991@aol.com, http://cv.droppages.com
#
#   class UserRepository
#     def self.first
#       { name: 'Jack' }
#     end
#   end
#
#   class PersonRepository
#     def first
#       { name: 'Gill' }
#     end
#   end
#
## Using Classes
#
#   SknContainer.register(:user_repository, UserRepository)
#   -- or --
#   SknContainer.register(:user_repository, UserRepository, call: false )
#
#   SknContainer.resolve(:user_repository).first
#
##  Using Procs
#
#   SknContainer.register(:person_repository, -> { PersonRepository.new })
#   -- or --
#   SknContainer.register(:person_repository, -> { PersonRepository.new }, call: true )
#
#   SknContainer.resolve(:person_repository).first
#
##  Outside Example
#   SknContainer.register(:some_block, {call: false}) {|str| str.upcase }
# #
#   SknContainer.resolve(:some_block).call("hello")
#   # ==> "HELLO"
##

# This creates a global constant (and singleton) wrapping a Hash
class << (SknContainer = SknRegistry.new); end
