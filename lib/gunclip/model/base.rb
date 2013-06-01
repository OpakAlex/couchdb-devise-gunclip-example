module Gunclip
  module Model
    class Base < Gunclip::Model::Document

      include Gunclip::Model::Request

      include Gunclip::Model::Callbacks

      #validations
      include ActiveModel::Validations

      def initialize params
        params.deep_stringify_keys!
        @request = params
      end


      def id
        (@request["_id"] || @request["id"])
      end

      def _rev
        (@request["rev"] || @request["_rev"])
      end

      def save
        attrs = delete_system_attrs
        if id
          request =  request(:put, make_url(get_id_rev), attrs)
        else
          request =  request(:post, make_url(get_id_rev), attrs)
        end
        raise UpdateConflictError if request.status == 409
        @request = Oj.load request.body
        merge_params(attrs)
        self
      end

      def destroy
        request(:delete, make_url(id: id, rev: _rev))
      end

      def update_attributes attrs={}
        attrs.deep_stringify_keys!
        @request.merge!(attrs)
        save()
      end

      def make_url params={}
        self.class.send(:make_url, params)
      end

      def method_missing(method, opts={})
        puts method
      end

      def read_attribute_for_validation(key)
        @request[key.to_s]
      end

      alias_method :rev, :_rev

      def self.create params
        self.new(params).save()
      end

      def self.validates_uniqueness_of(*args)
        false
        puts "a #{args}"
      end

      private

      def system_fields
        %w(id _id rev _rev)
      end

      def delete_system_attrs
        @request.select { |k| !system_fields.member?(k) }
      end

      def merge_params params
        @request.delete "ok"
        @request.update(params)
      end

      def get_id_rev
        h = {}
        h[:rev] = rev if rev.present?
        h[:id] = id   if id.present?
        h
      end

    end
  end
end