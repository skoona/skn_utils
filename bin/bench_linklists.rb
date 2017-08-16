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
# LinkedList Ops     2.297k i/100ms
#      Array Ops    34.468k i/100ms
# Calculating -------------------------------------
# LinkedList Ops     17.015k (±35.2%) i/s -     71.207k in   5.100193s
#      Array Ops    377.943k (± 7.3%) i/s -      1.896M in   5.048217s
#
# Comparison:
#       Array Ops:   377942.7 i/s
# LinkedList Ops:    17015.4 i/s - 22.21x  slower


Benchmark.ips do |x|
  x.config(:suite => suite)

  adders = [50, 10, 110, 6, 30, 101, 12, 33, 4]
  vargs  = [70, 71, 72, 73, 74, 75, 76, 77, 78, 79]
  cproc  = lambda {|a| a}

  x.report('LinkedList Ops') do
    ll = SknUtils::Lists::LinkedList.new(*vargs, &cproc)
    adders.each {|x| ll.insert_after(74, x)}
    value = ll.sort!
    ll.first
    ll.clear
  end

  x.report('Array Ops') do
    ary = Array.new(vargs)
    adders.each {|x| ary.insert(5, x)}
    value = ary.sort!
    ary.first
    ary.clear
  end

  x.compare!
end
