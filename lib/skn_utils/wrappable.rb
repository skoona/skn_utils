# frozen_string_literal: true

# ##
#
# Ref: https://blog.appsignal.com/2018/10/02/ruby-magic-class-level-instance-variables.html

module SknUtils

  module Wrappable
    def wrap(mod)
      wrappers << mod
    end

    def wrappers
      @wrappers ||= []
    end

    def inherited_wrappers
      ancestors
          .grep(Wrappable)
          .reverse
          .flat_map(&:wrappers)
    end

    def new(*arguments, &block)
      instance = allocate
      inherited_wrappers.each { |mod|instance.singleton_class.include(mod) }
      instance.send(:initialize, *arguments, &block)
      instance
    end
  end
end