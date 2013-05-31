module Gunclip
  module Model
    module Database

      extend self

      extend Gunclip::Model::Configuration
      extend Gunclip::Model::Request

      def database_name name = nil
        if name
          @database_name = name
        else
          (@database_name || config[:database])
        end
      end

      def exist?
        request(:head, make_url).status != 404
      end

      def create
        request(:put, make_url)
      end

      def delete
        request(:delete, make_url)
      end

      protected

      def make_url params = {}
        url = "#{config[:protocol]}://#{config[:host]}"
        url += ":#{config[:port]}" if config[:port]
        url += "/#{database_name}/"
        if params[:id]
          url += "#{params.delete(:id)}"
        end
        url += "?#{URI.encode_www_form(params)}" unless params.empty?
        url
      end

    end
  end
end