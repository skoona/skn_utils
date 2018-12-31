# ##
#

module Powered
  def make_noise
    puts "Powering up"
    super
    puts "Shutting down"
  end
end

class Machine
  extend SknUtils::Wrappable

  wrap Powered

  def make_noise
    puts "Buzzzzzz"
  end
end


module Logging
  def make_noise
    puts "Started making noise"
    super
    puts "Finished making noise"
  end
end

class Bird
  extend SknUtils::Wrappable

  wrap Logging

  def make_noise
    puts "Chirp, chirp!"
  end
end


module Flying
  def make_noise
    super
    puts "Is flying away"
  end
end

class Pigeon < Bird
  wrap Flying

  def make_noise
    puts "Coo!"
  end
end

describe 'SknUtils::Wrappable Module Handles Inheritance properly ' do

  it '#make_noise handles Bird module. ' do
    expect do
      obj = Bird.new
      obj.make_noise
    end.to output("Started making noise\nChirp, chirp!\nFinished making noise\n").to_stdout
  end

  it '#make_noise handles Pigeon module. ' do
    expect do
      obj = Pigeon.new
      obj.make_noise
    end.to output("Started making noise\nCoo!\nFinished making noise\nIs flying away\n").to_stdout
  end

  it '#make_noise handles Machine module. ' do
    expect do
      obj = Machine.new
      obj.make_noise
    end.to output("Powering up\nBuzzzzzz\nShutting down\n").to_stdout
  end

end