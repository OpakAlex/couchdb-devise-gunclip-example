module Gunclip
  module Model

    class Base < Gunclip::Model::Document


      include Gunclip::Model::Request

      include Gunclip::Model::Callbacks

      #validations
      include ActiveModel::Validations


      #define_callbacks :before_save
      #define_callbacks :after_save

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


      def save
        set_timestamps if with_timestamps

        #run_callbacks(:before_save) { self }

        attrs = delete_system_attrs
        if id
          request = request(:put, make_url(get_id_rev), attrs)
        else
          request = request(:post, make_url(get_id_rev), attrs)
        end
        raise UpdateConflictError if request.status == 409
        @request = Oj.load request.body
        merge_params(attrs)

        #run_callbacks(:after_save) {
        #  puts "ss"
        #  self }

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

      def method_missing(method, *args)
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
        # To do
      end

      protected

      def with_timestamps
        true
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