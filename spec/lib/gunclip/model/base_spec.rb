require 'spec_helper'

describe Gunclip::Model::Base do

  before :each do
    described_class.stub(:connection_config_file).and_return(config)
    described_class.send(:connection_config_file)

    Gunclip::Model::Database.stub(:connection_config_file).and_return(config)
    Gunclip::Model::Database.send(:connection_config_file)
    Gunclip::Model::Database.create()
  end

  let(:config){  File.join('spec', 'fixtures', 'couchdb.yml') }


  context ".create" do
    it do
      document = described_class.new({id: "test", body: "test_body"})
      document.id.should == "test"
      document.delete()
    end
  end

  context "#update_attributes" do
    it do
      document = described_class.new({id: "test", body: "test_body"})
      rev = document.rev
      document.update_attributes({body: "updated_body"})
      document.rev.should_not == rev
      document.delete()
    end

    it "updates find document" do
      described_class.new({id: "test", body: "test_body"})
      document = described_class.find("test")
      rev = document.rev
      document.update_attributes({body: "updated_body"})
      document.rev.should_not == rev
      document.delete()
    end

  end

end