module Gunclip
  module Model
    class Base < Gunclip::Model::Document

      include Gunclip::Model::Request

      def initialize params
        params.deep_stringify_keys!
        if params["_id"].present?
          @request = params
        else
          create(params)
        end
      end

      def create params
        id  = params.delete "id"
        if id
          @request = Oj.load request(:put, make_url(id: id), params).body
        else
          @request = Oj.load request(:post, make_url(), params).body
        end
        merge_params(params)

        self
      end

      def id
        @request["_id"]
      end

      def _rev
        (@request["rev"] || @request["_rev"])
      end

      def save
        #To do implement
      end

      def destroy
        request(:delete, make_url(id: id, rev: _rev))
      end

      def update_attributes attrs={}
        attrs.deep_stringify_keys!
        delete_system_attrs!(attrs.merge! @request)
        request = request(:put, make_url(id: id, rev: _rev), attrs)
        raise UpdateConflictError if request.status == 409
        merge_params(attrs)
        change_rev(Oj.load request.body)
        self
      end

      def make_url params={}
        self.class.send(:make_url, params)
      end

      def method_missing(method, opts={})
        puts method
      end

      alias_method :rev, :_rev

      private

      def delete_system_attrs! attrs
        %w(id _id rev _rev).each do |attr|
          attrs.delete attr
        end
      end

      def merge_params params
        id = @request.delete "id"
        @request.delete "ok"
        @request.merge!(params)
        change_id_to__id id unless @request["_id"]
      end

      def change_id_to__id id
        @request["_id"] = id
      end

      def change_rev request
        @request["rev"] = request["rev"]
        @request["_rev"] = request["rev"]
      end

    end
  end
end