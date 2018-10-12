##
# spec/lib/skn_utils/registry_spec.rb
#

class MyService
  def value
    true
  end
end



describe SknRegistry, "IoC Lite Container class." do

  let(:registry) { described_class.new }

  let(:services) {
    described_class.new do|cfg|
      cfg.register(:service_a, -> {MyService.new} )
      cfg.register(:service_b, MyService)
      cfg.register(:service_c, "AnyValue")
      cfg.register(:some_block, {call: false}) {|str| str.upcase }
      cfg.register(:some_depends, {call: true, greet: 'My warmest', str: 'Hello'}) {|pkg| "#{pkg[:greet]} #{pkg[:str].upcase}" }
    end
  }

  context "Basic Operation Features. " do

    it "#register accepts a proc object to produce unique instances. " do
      val = registry.register(:service, -> {MyService.new} )
      expect( val ).to eq registry
    end

    it "#resolve returns new instances. " do
      registry.register(:service, -> {MyService.new} )
      val_a = registry.resolve(:service)
      val_b = registry.resolve(:service)

      expect( val_a ).to be_instance_of MyService
      expect( val_a ).to_not be_equal val_b
    end

    it "#register accepts a class object and return self to enable chaining. " do
      val = registry.register(:service_k, MyService).register(:more, "More")
      expect( val ).to be_equal registry
    end

    it "#resolve returns class value. " do
      registry.register(:service_k, MyService)
      val = registry.resolve(:service_k)

      expect( val ).to be_equal MyService
      expect( val.new.value ).to be true
    end

    it "#resolve returns the same object value. " do
      thingy = MyService.new
      registry.register(:service_k, thingy)
      val_a = registry.resolve(:service_k)
      val_b = registry.resolve(:service_k)

      expect( val_a ).to be_equal thingy
      expect( val_b ).to be_equal thingy
      expect( val_a ).to be_equal val_b
    end

    it "#resolve returns nil when key is not found. " do
      registry.register(:service_a, "AnyValue")
      expect(registry.resolve(:no_find)).to be_nil
    end

    it "#resolve returns block without calling it first. " do
      registry.register(:service_b, {call: false}) do |str|
        str.upcase
      end

      expect( registry.resolve(:service_b).call("Hello") ).to eq "HELLO"
    end
  end


  context "Extended Initialization Feature. " do

    it "Register a hash of objects on initialization via block. " do
      expect(services.keys.size).to eq 5
    end

    it "#resolve returns new instances. " do
      val_a = services.resolve(:service_a)
      val_b = services.resolve(:service_a)

      expect( val_a ).to be_instance_of MyService
      expect( val_b ).to be_instance_of MyService
      expect( val_a ).to_not be_equal val_b
    end

    it "#resolve returns class value. " do
      val = services.resolve(:service_b)

      expect( val ).to be_equal MyService
      expect( val.new.value ).to be true
    end

    it "#resolve returns String value. " do
      val = services.resolve(:service_c)

      expect( val ).to be_a String
      expect( val ).to eq("AnyValue")
    end

    it "#resovle returns a proc without calling it. " do
      expect(services.resolve(:some_block).call("hello")).to eq("HELLO")
    end

    it "#resovle invokes the proc passing in dependencies. " do
      expect(services.resolve(:some_depends)).to eq("My warmest HELLO")
    end
  end

end
