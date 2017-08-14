#!/usr/bin/env ruby

#
# Ref: https://github.com/evanphx/benchmark-ips
#

require 'bundler/setup'
require 'skn_utils'
require 'ostruct'
require 'benchmark/ips'

class GCSuite
  def warming(*)
    run_gc
  end

  def running(*)
    run_gc
  end

  def warmup_stats(*)
  end

  def add_report(*)
  end

  private

  def run_gc
    GC.enable
    GC.start
    GC.disable
  end
end

suite = GCSuite.new

Benchmark.ips do |x|
  x.config(:suite => suite)

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

  x.compare!
end

# Warming up --------------------------------------
#      regular class     179.755k i/100ms
#   OpenStruct class      11.367k i/100ms
# NestedResult class       9.674k i/100ms
# Calculating -------------------------------------
#      regular class       3.674M (±17.4%) i/s -     17.256M in   5.001576s
#   OpenStruct class     155.394k (±31.2%) i/s -    670.653k in   5.095404s
# NestedResult class     119.896k (±39.0%) i/s -    493.374k in   5.212147s
#
# Comparison:
#      regular class:   3673640.5 i/s
#   OpenStruct class:    155394.0 i/s - 23.64x  slower
# NestedResult class:    119896.1 i/s - 30.64x  slower
#
# Warming up --------------------------------------
# LinkedList Ops      1.067k i/100ms
#      Array Ops     35.020k i/100ms
# Calculating -------------------------------------
# LinkedList Ops      6.182k (±49.5%) i/s -     24.541k in   5.047128s
#      Array Ops    390.617k (± 3.5%) i/s -      1.961M in   5.026810s
#
# Comparison:
#      Array Ops:   390617.3 i/s
# LinkedList Ops:     6182.1 i/s - 63.19x  slower
#


Benchmark.ips do |x|
  x.config(:suite => suite)

  adders = [50, 10, 110, 6, 30, 101, 12, 33, 4]
  vargs  = [70, 71, 72, 73, 74, 75, 76, 77, 78, 79]

  x.report('LinkedList Ops') do
    ll = SknUtils::Lists::LinkedList.new(*vargs)
    adders.each {|x| ll.insert_after(74, x)}
    value = ll.sort!
    ll.first
    ll.clear
  end

  x.report('Array Ops') do
    ary = vargs.dup
    adders.each {|x| ary.insert(5, x)}
    value = ary.sort!
    ary.first
    ary.clear
  end

  x.compare!
end
