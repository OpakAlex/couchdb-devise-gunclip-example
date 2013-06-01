module Gunclip
  module Model

    class Base < Gunclip::Model::Document


      include Gunclip::Model::Request

      include Gunclip::Model::Callbacks

      #validations
      include ActiveModel::Validations
      include ActiveModel::Validations::Callbacks

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

      alias_method :rev, :_rev

      def new?
        !(id && rev)
      end

      alias_method :new_record?, :new?


      def save
        set_timestamps if with_timestamps

        return false unless valid?()

        attrs = delete_system_attrs
        if id
          request = request(:put, make_url(get_id_rev), attrs)
        else
          request = request(:post, make_url(get_id_rev), attrs)
        end
        raise UpdateConflictError if request.status == 409
        @request = Oj.load request.body
        merge_params(attrs)
        self
      end

      def destroy
        request = request(:delete, make_url(id: id, rev: _rev))
        raise UpdateConflictError if request.status == 409
        true
      end

      def changed?
        true
      end

      def update_attributes attrs={}
        attrs.deep_stringify_keys!
        @request.merge!(attrs)
        save()
      end

      def make_url params={}
        self.class.send(:make_url, params)
      end

      def method_missing(method, *args)
        puts method
        if method.to_s =~ /=/
          @request[method.to_s.gsub("=", "")] = args.first
        else
          @request[method.to_s]
        end
      end

      def read_attribute_for_validation(key)
        @request[key.to_s]
      end

      def self.create params
        self.new(params).save()
      end

      def self.validates_uniqueness_of(*args)
        puts args
        # To do
      end

      def self.find_for_authentication(tainted_conditions)
        puts tainted_conditions
        #     find_first_by_auth_conditions(tainted_conditions, :active => true)
      end

      protected

      def with_timestamps
        true
      end

      def system_fields
        %w(id _id rev _rev)
      end

      private


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
        h[:id] = id if id.present?
        h
      end

      def set_timestamps
        time = Time.now.to_i
        self.created_at = time if new?
        self.updated_at = time
      end

    end
  end
end