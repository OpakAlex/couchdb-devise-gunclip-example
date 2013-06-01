require 'spec_helper'


describe Gunclip::Model::Base do

  before :each do
    @class = GunclipTestModel.new({body: "text"})
    described_class.stub(:connection_config_file).and_return(config)
  end

  let(:config){  File.join('spec', 'fixtures', 'couchdb.yml') }

  context "#validates_presence_of" do
    it do
      @class.valid?.should == true
      @class.update_attributes({body: ""})
      @class.valid?.should == false
      @class.destroy()
    end
  end

end