##
# spec/lib/skn_utils/container_spec.rb
#

class MyService
  def value
    true
  end
end



describe SknContainer, "Gem D/I Container module." do


  context "Operational Features. " do


    it "#register accepts a proc object. " do
      val = subject.register(:service, -> {MyService.new} )
      expect( val ).to be_a SknContainer::Content
    end
    it "#resolve returns proc value. " do
      subject.register(:service, -> {MyService.new} )
      val = subject.resolve(:service)
      expect( val ).to be_kind_of MyService
    end

    it "#register accepts a class object. " do
      val = subject.register(:service_k, MyService)
      expect( val ).to be_a SknContainer::Content
    end
    it "#resolve returns class value. " do
      subject.register(:service_k, MyService)
      val = subject.resolve(:service_k)
      expect( val ).to be_a Class
    end

  end

end
