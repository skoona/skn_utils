#!/usr/bin/env ruby

require 'bundler/setup'
require 'skn_utils'
require 'ostruct'
require 'psych'
require 'benchmark/ips'

Benchmark.ips do |x|

  class RegularClass
    attr_accessor :foo
  end

  class OpenStructClass < OpenStruct
  end

  x.report('regular class') do
    r = RegularClass.new
    r.foo = :bar
    r.foo
  end

  x.report('OpenStruct class') do
    o = OpenStructClass.new
    o.foo = :bar
    o.foo
  end

  x.report('NestedResult class') do
    o = SknUtils::NestedResult.new
    o.foo = :bar
    o.foo
  end
end
