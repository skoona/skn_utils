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
class << (SknContainer = Concurrent::Hash.new)

  class Content
    attr_reader :item, :options

    def initialize(item, options = {})
      @item, @options = item, {
          call: item.is_a?(::Proc)
      }.merge(options)
    end

    def call
      if options[:call] == true
        item.call
      else
        item
      end
    end
  end

  def register(key, contents = nil, options = {}, &block)
    if block_given?
      item = block
      options = contents if contents.is_a?(::Hash)
    else
      item = contents
    end

    self[key] = Content.new(item, options)

    self # enable chaining
  end

  def resolve(key)
    self.fetch(key) {|k| nil }&.call
  end

end