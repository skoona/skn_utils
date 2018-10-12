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
##  Proc without depends as value Example
#   SknContainer.register(:some_block, {call: false}) {|str| str.upcase }
# #
#   SknContainer.resolve(:some_block).call("hello")
#   # ==> "HELLO"
#
##  Proc without depends Example
#   SknContainer.register(:some_block, {call: true}) { Object.new }
# #
#   SknContainer.resolve(:some_block)
#   # ==> <Object#instance...>
#
##  Proc with Depends Example
#   SknContainer.register(:some_block, {call: true, greet: 'My warmest', str: 'Hello'}) {|pkg| "#{pkg[:greet]} #{pkg[:str].upcase}" }
# #
#   SknContainer.resolve(:some_block).call("hello")
#   # ==> "HELLO"
##

# This creates a global constant (and singleton) wrapping a Hash
class SknRegistry < Concurrent::Hash

  # Child to contain contents
  class Content
    attr_reader :item, :options

    def initialize(item, options = {})
      @item, @options = item, {
          call: item.is_a?(::Proc)
      }.merge(options)
    end

    # Determine if call is required, without changing original values
    # - yes, determine if depends are available
    #   -- yes, call with depends: #item.call(depends)
    #   -- no, just #item.call()
    # - no, return #item
    def call
      _depends = options.dup
      _do_call = !!_depends.delete(:call)
      if _do_call
        _depends.empty? ? item.call : item.call(_depends)
      else
        item
      end
    end
  end

  # base initializer
  #
  def initialize(&block)
    super
    block.call(self) if block_given?
  end

  # public instance methods
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
