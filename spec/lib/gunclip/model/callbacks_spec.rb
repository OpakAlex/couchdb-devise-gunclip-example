require 'spec_helper'

#require 'gunclip_test_model'

describe Gunclip::Model::Callbacks do

  before :each do
    @class = GunclipTestModel.new({body: "text"})
  end

  context "#before_destroy" do
    it do
      puts @class.valid?
      @class.destroy()
    end
  end

end