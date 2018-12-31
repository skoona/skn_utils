# frozen_string_literal: true

# ##
# SknContainer
# - Key/Value Container where keys and/or values can be any valid Ruby Class, Proc, Instance, or object.
#
# Credits: Inspired by: andyholland1991@aol.com, http://cv.droppages.com
#
# Syntax:
#  SknContainer is a pre-initialized global singleton
#
#  - Methods:
#   self_chain = SknContainer.register(key, content, options={}, &block)
#      content = SknContainer.resolve(key, render_proc=true)
#
#  - Method Params:
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
#   SknContainer.register(:user, Person)
#   -- or --
#   SknContainer.register(:user, Person, call: false )
#   -- then --
#   SknContainer.resolve(:user).new({first: 'Monty', last: 'Python'}).name        # => 'Monty.Python'
#   SknContainer.resolve(:user).new({first: 'Monty', last: 'Python'}).name        # => 'Monty.Python'
#
# ##
## Using Procs: default #call before return
# ##
#
#   SknContainer.register(:user, -> { Person.new })
#   -- or --
#   SknContainer.register(:user, -> { Person.new }, call: false )
#   -- or --
#   SknContainer.register(:user, ->(hsh) { Person.new(hsh) }, call: false )
#   -- or --
#   SknContainer.register(:block_a, ->(hsh) { Person.new(hsh) }, {call: true, first: 'Monty', last: 'Python'} )
#   -- or --
#   SknContainer.register(:block_b, {call: true, greet: 'Hello', str: 'Python'}) {|hsh| "#{hsh[:greet]} #{hsh[:str].upcase}" }
#   -- then --
#   SknContainer.resolve(:person_repository).name         # => '.'
#   SknContainer.resolve(:person_repository).call().name  # => '.'
#   SknContainer.resolve(:person_repository).call({first: 'Monty', last: 'Python'}).name  # => 'Monty.Python'
#   SknContainer.resolve(:block_a).name                   # => 'Monty.Python'
#   SknContainer.resolve(:block_b)                        # => 'Hello PYTHON'
#
##

# This creates a global constant (and singleton) wrapping SknRegistry which wraps a Concurrent::Hash
class << (SknContainer = SknRegistry.new); end
