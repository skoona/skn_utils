# ##
# SknRegistry
# - Key/Value Container where keys and/or values can be any valid Ruby Class, Proc, Instance, or object.
#
# Credits: Inspired by: andyholland1991@aol.com, http://cv.droppages.com
#
# Syntax:
#   reg = SknRegistry.new(&reg_blk)
#         - where: &reg_blk is {|reg| reg.register(...); ... }
#
#   self_chain = reg.register(key, content, options={}, &block)
#      content = reg.resolve(key, render_proc=true)
#
#  Params:
#         key    - anyThing can be used as the key
#     content    - anyThing can be used as value; Class, Proc, instance, value
#     options    - hash of dependencies to pass into procs when rendering
#      &block    - block used for #content; with/without a parameter. ex: {|parm| ...} | { ... }
# render_proc    - bool: when #content is_a Proc, should it be #call()'ed before being returned
#
#
# ## Examples
#
#   class Person
#     attr_reader :first, :last
#     def initialize(names={})
#       self.first = names[:first]
#       self.last = names[:last]
#     end
#     def name
#       "#{first}.#{last}"
#     end
#   end
#
# ##
## Using Classes: default no #call before return
# ##
#   reg.register(:user, Person)
#   -- or --
#   reg.register(:user, Person, call: false )
#   -- then --
#   reg.resolve(:user).new({first: 'Monty', last: 'Python'}).name        # => 'Monty.Python'
#   reg.resolve(:user).new({first: 'Monty', last: 'Python'}).name        # => 'Monty.Python'
#
# ##
## Using Procs: default #call before return
# ##
#
#   reg.register(:user, -> { Person.new })
#   -- or --
#   reg.register(:user, -> { Person.new }, call: false )
#   -- or --
#   reg.register(:user, ->(hsh) { Person.new(hsh) }, call: false )
#   -- or --
#   reg.register(:block_a, ->(hsh) { Person.new(hsh) }, {call: true, first: 'Monty', last: 'Python'} )
#   -- or --
#   reg.register(:block_b, {call: true, greet: 'Hello', str: 'Python'}) {|hsh| "#{hsh[:greet]} #{hsh[:str].upcase}" }
#   -- then --
#   reg.resolve(:person_repository).name         # => '.'
#   reg.resolve(:person_repository).call().name  # => '.'
#   reg.resolve(:person_repository).call({first: 'Monty', last: 'Python'}).name  # => 'Monty.Python'
#   reg.resolve(:block_a).name                   # => 'Monty.Python'
#   reg.resolve(:block_b)                        # => 'Hello PYTHON'
#
##

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
    def call(render_proc=true)
      _opts    = options.reject {|k,v| k === :call }
      _do_call = render_proc && options[:call]

      _do_call ? (_opts.empty? ? item.call : item.call( _opts )) : item
    end
  end # end content

  # SknRegistry initializer
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

  def resolve(key, render_proc=true)  # false to prevent downstream #call
    self[key]&.call(render_proc)
  end

end
