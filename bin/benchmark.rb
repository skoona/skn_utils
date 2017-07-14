#!/usr/bin/env ruby

require 'bundler/setup'
require 'skn_utils'
require 'ostruct'
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
    o = OpenStructClass.new(foo: nil)
    o.foo = :bar
    o.foo
  end

  x.report('NestedResult class') do
    n = SknUtils::NestedResult.new(foo: nil)
    n.foo = :bar
    n.foo
  end
end

# Warming up --------------------------------------
#      regular class   182.079k i/100ms
#   OpenStruct class    12.129k i/100ms
# NestedResult class    11.075k i/100ms
# Calculating -------------------------------------
#      regular class      4.140M (± 2.2%) i/s -     20.757M in   5.015689s
#   OpenStruct class    129.418k (± 2.3%) i/s -    654.966k in   5.063580s
# NestedResult class    115.819k (± 2.3%) i/s -    586.975k in   5.070852s
