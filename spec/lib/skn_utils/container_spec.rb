##
# spec/lib/skn_utils/container_spec.rb
#

class MyKlassService
  def value
    true
  end
end



describe SknContainer, "IoC Lite Container Singleton." do

  context "Operational Features. " do

    it "#register accepts a proc object to produce unique instances. " do
      val = subject.register(:service, -> {MyKlassService.new} )
      expect( val ).to eq subject
    end

    it "#resolve returns new instances. " do
      subject.register(:service, -> {MyKlassService.new} )
      val_a = subject.resolve(:service)
      val_b = subject.resolve(:service)

      expect( val_a ).to be_instance_of MyKlassService
      expect( val_a ).to_not be_equal val_b
    end

    it "#register accepts a class object and return self to enable chaining. " do
      val = subject.register(:service_k, MyKlassService).register(:more, "More")
      expect( val ).to eq subject
    end

    it "#resolve returns class value. " do
      subject.register(:service_k, MyKlassService)
      val = subject.resolve(:service_k)

      expect( val ).to be_equal MyKlassService
      expect( val.new.value ).to be true
    end

    it "#resolve returns the same object value. " do
      thingy = MyKlassService.new
      subject.register(:service_k, thingy)
      val_a = subject.resolve(:service_k)
      val_b = subject.resolve(:service_k)

      expect( val_a ).to be_equal thingy
      expect( val_a ).to be_equal val_b
    end

    it "#resolve returns nil when key is not found. " do
      subject.register(:service_a, "AnyValue")
      expect(subject.resolve(:no_find)).to be_nil
    end

    it "#resolve returns block without calling it first. " do
      subject.register(:service_b, {call: false}) do |str|
        str.upcase
      end

      expect( subject.resolve(:service_b).call("Hello") ).to eq "HELLO"
    end
  end

end
