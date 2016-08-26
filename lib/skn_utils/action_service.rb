## lib/skn_utils/action_service.rb
#
# Exploritory Action/Service Class
# Ref: https://blog.lelonek.me/what-service-objects-are-not-7abef8aa2f99#.p64vudxq4
#
# Not a template or abstract class, Just an Example of an Action class
#

module SknUtils
  class ActionService

    def initialize(dependency_injection_arguments)
      @thingy = dependency_injection_arguments
    end

    def call(*command_and_params)
      puts "Called with: #{command_and_params}"
      value = command_and_params
      if value.first.is_a?(Symbol)
        (value.size == 1 ? self.send(value.first) : self.send(value.first, value[1..-1]))
      else
        puts('No Action Taken')
      end

      self
    end

    private
    # a bunch of private methods
    def action_one
      puts "#{__method__}() #{@thingy}"
      true
    end

    def action_two(parm)
      puts "#{__method__} => #{parm} #{@thingy}"
      true
    end

  end # end class
end # end module


# - regular execution
# action = DoSomeAction.new.(arg1, arg2)
#
# action.('Mine')
# => Called with: ["Mine"]
# => "No Action Taken"
# => #<SknUtils::ActionService:0x007ffa62079c20 @thingy="Things">
#
# action.()
# =>Called with: []
# => "No Action Taken"
# => #<SknUtils::ActionService:0x007ffa62079c20 @thingy="Things">
#
# action.(:action_two,'samples')
# => Called with: [:action_two, "samples"]
# => action_two(["samples"]) with Thingy: Things
# => #<SknUtils::ActionService:0x007ffa62079c20 @thingy="Things">
#
# action.(:action_one,'samples')
# => Called with: [:action_one, "samples"]
# => action_one() Thingy: Things
# => #<SknUtils::ActionService:0x007ffa62079c20 @thingy="Things">
#
# action.(:action_one).(:action_two,'Always')
# => Called with: [:action_one]
# => action_one() Thingy: Things
# => Called with: [:action_two, "Always"]
# => action_two(["Always"]) with Thingy: Things
# => #<SknUtils::ActionService:0x007ffa62079c20 @thingy="Things">
#
# - with dependency injection
#
# def do_some_action
#   DoSomeAction.new(http_adapter)
# end
#
# do_some_action.(arg1, arg2)
#
#
#
# - in tests
#
# let(:do_some_action) { DoSomeAction.new(fake_http_adapter) }
# it { is_expected.to be_connected }
#
