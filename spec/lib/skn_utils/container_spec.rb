##
# spec/lib/skn_utils/container_spec.rb
#

class MyService
  def value
    true
  end
end



describe SknContainer, "IoC Lite Container module." do


  context "Operational Features. " do

    it "#register accepts a proc object to produce unique instances. " do
      val = subject.register(:service, -> {MyService.new} )
      expect( val ).to eq subject
    end

    it "#resolve returns new instances. " do
      subject.register(:service, -> {MyService.new} )
      val_a = subject.resolve(:service)
      val_b = subject.resolve(:service)

      expect( val_a ).to be_instance_of MyService
      expect( val_a ).to_not be_equal val_b
    end

    it "#register accepts a class object and return self to enable chaining. " do
      val = subject.register(:service_k, MyService).register(:more, "More")
      expect( val ).to eq subject
    end

    it "#resolve returns class value. " do
      subject.register(:service_k, MyService)
      val = subject.resolve(:service_k)

      expect( val ).to be_equal MyService
      expect( val.new.value ).to be true
    end

    it "#resolve returns the same object value. " do
      thingy = MyService.new
      subject.register(:service_k, thingy)
      val_a = subject.resolve(:service_k)
      val_b = subject.resolve(:service_k)

      expect( val_a ).to be_equal thingy
      expect( val_a ).to be_equal val_b
    end

    it "#resolve raises ArgumentError when key is not found. " do
      subject.register(:service_a, "AnyValue")
      expect{subject.resolve(:no_find)}.to raise_error ArgumentError
    end

    it "#resolve returns the block or method passed as value. " do
      subject.register(:my_method) do |str|
        str
      end
      val = subject.resolve(:my_method)
      expect( val.call("Welcome") ).to eq "Welcome"
    end
  end

end