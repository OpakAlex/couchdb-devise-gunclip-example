require 'spec_helper'

describe Gunclip::Model::Configuration do

  before :each do
    described_class.stub(:connection_config_file).and_return(config)
  end

  let(:config){  File.join('spec', 'fixtures', 'couchdb.yml') }

  context ".env" do
    it "returns default env " do
      described_class.env = :test
      described_class.env.should ==  :test
    end

    it "changes env " do
      described_class.env = :development
      described_class.env.should ==  :development
    end
  end

  describe ".config" do
    context "#development" do
      it do
        described_class.env = :development
        described_class.config.should == {database: "gunclip-development", host: "0.0.0.0",
                                               port: 5984, protocol: "http"}
      end
    end

    context "#test" do
      it do
        described_class.env = :test
        described_class.config.should == {database: "gunclip-test", host: "0.0.0.0",
                                        port: 5984, protocol: "http"}
      end
    end

  end

end
