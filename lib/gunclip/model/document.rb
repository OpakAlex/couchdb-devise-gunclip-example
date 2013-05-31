module Gunclip
  module Model
    class Document

      class NotFoundError < Exception; end

      extend Gunclip::Model::Configuration
      extend Gunclip::Model::Database
      extend Gunclip::Model::Request

      include Gunclip::Model::Callbacks

      #To do implements relations

      class << self

        def find id
          # To do implement find by _rev
          request = request(:get, make_url({id: id}))
          raise NotFoundError if request.status == 404
          Gunclip::Model::Base.new Oj.load(request.body)
        end

        #To do implement find by ids

      end

    end
  end
end