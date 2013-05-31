require 'spec_helper'

describe Gunclip::Model::Database do
  before :each do
    described_class.stub(:connection_config_file).and_return(config)
  end

  let(:config){  File.join('spec', 'fixtures', 'couchdb.yml') }

  context ".database_name" do

    it "returns default database_name" do
      described_class.database_name.should == "gunclip-test"
    end

    it "sets database_name" do
      described_class.database_name "gunclip_test_name"
      described_class.database_name.should == "gunclip_test_name"
      described_class.database_name "gunclip-test"
    end
  end

  context ".make_url" do
    it "#with port "do
      described_class.send(:make_url).should == "http://0.0.0.0:5984/gunclip-test/"
    end

    it "#without port" do
      described_class.config[:port] = nil
      described_class.send(:make_url).should == "http://0.0.0.0/gunclip-test/"
      described_class.config[:port] = 5984
    end
  end

  context ".exist?" do
    it "deletes db && db doesn't exists" do
      described_class.delete()
      described_class.exist?.should == false
    end

    it "creates db && returns true" do
      described_class.create()
      described_class.exist?.should == true
    end
  end

end
