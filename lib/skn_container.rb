##
# Register:
#   SknContainer.<new.key> = AnyObject
#
# Resolve:
#   SknContainer.<new.key>  # => AnyObject
#   SknContainer.<new.key>?  # => True | False based on existance #
#
#
#   class UserRepository
#     def self.first
#       { name: 'Jack' }
#     end
#   end
#
#   SknContainer.register(:user_repository, UserRepository)
#   SknContainer.resolve(:user_repository).first
#
#   class PersonRepository
#     def first
#       { name: 'Gill' }
#     end
#   end
#
#   SknContainer.register(:person_repository, -> { PersonRepository.new })
#   SknContainer.resolve(:person_repository).first
##

# This creates a global constant (and singleton) wrapping a Hash
class << (SknContainer = SknUtils::NestedResult.new())

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
  end

  def resolve(key)
    content = self.fetch(key) do
      fail ArgumentError, "Nothing registered with the name #{key}"
    end

    content.call
  end

end