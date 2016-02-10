##
# spec/lib/skn_utils/commander_spec.rb
#
#

class Person
  extend SknUtils::Commander
  command [:make_me_a_sandwich, :cook, :blocky] => :@friend
  query [:activities, :go, :say_what] => :friend
  attr_accessor :friend
end

class Friend
  def make_me_a_sandwich
    Table.place "a sandwich!"
  end

  def cook(what)
    Table.place what
  end

  def activities
    'running, biking, hiking'
  end

  def go(do_what)
    Activities.record do_what
  end

  def blocky(text)
    Activities.record([yield(self).to_s,text].join(' '))
  end

  def say_what(text)
    [yield(self).to_s,text].join(' ')
  end
end

module Table
  def self.place(text)
    contents << text
  end
  def self.contents
    @contents ||= []
  end
  def self.clear
    @contents = []
  end
end

module Activities
  def self.record(text)
    list << text
  end
  def self.list
    @list ||= []
  end
  def self.clear
    @list = []
  end
end

RSpec.describe SknUtils::Commander, 'command' do
  let(:friend){ Friend.new }
  let(:person){ person = Person.new
  person.friend = friend
  person
  }
  before do
    Table.clear
    Activities.clear
  end
  it 'forwards a message to another object' do
    expect(Table.contents).to eq []
    person.make_me_a_sandwich
    expect(Table.contents).to include "a sandwich!"
  end

  it 'returns the original receiver' do
    expect( person).to eq person.make_me_a_sandwich
  end

  it 'forwards additional arguments' do
    expect(Table.contents).to eq []
    person.cook('yum')
    expect(Table.contents).to include "yum"
  end

  it 'forwards block arguments' do
    expect(Activities.list).to eq []
    person.blocky('yay!') do |friend|
      "Arguments forwarded to #{friend}"
    end
    expect(Activities.list).to include "Arguments forwarded to #{friend} yay!"
  end
end

RSpec.describe SknUtils::Commander, 'query' do
  let(:friend){ Friend.new }
  let(:person){ person = Person.new
  person.friend = friend
  person
  }
  before do
    Activities.clear
  end

  it 'forwards a message to another object' do
    expect(person.activities).to eq "running, biking, hiking"
  end

  it 'forwards additional arguments' do
    expect(Activities.list).to eq []
    person.go('have fun')
    expect(Activities.list).to include "have fun"
  end

  it 'forwards block arguments' do
    expect(Activities.list).to eq []
    what_said = person.say_what('yay!') do |friend|
      "Arguments forwarded to #{friend}"
    end
    expect(what_said).to eq "Arguments forwarded to #{friend} yay!"
  end
end
