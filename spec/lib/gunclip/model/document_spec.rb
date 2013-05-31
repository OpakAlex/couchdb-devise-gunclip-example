require 'spec_helper'

describe Gunclip::Model::Document do

  before :each do
    described_class.stub(:connection_config_file).and_return(config)
    described_class.send(:connection_config_file)

    Gunclip::Model::Database.stub(:connection_config_file).and_return(config)
    Gunclip::Model::Database.send(:connection_config_file)
    Gunclip::Model::Database.create()
  end

  let(:config){  File.join('spec', 'fixtures', 'couchdb.yml') }

  let(:id) {"gunclip-id"}

  context ".find" do
    it "not found document error "do
      lambda { described_class.find(id) }.should raise_error
    end

    it "returns document object when document exist" do
      Gunclip::Model::Base.new(id: id, body: "body", type: "my-type")
      document = described_class.find(id)
      document.should be_a_kind_of Gunclip::Model::Base
      document.destroy()
    end
  end

end