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
