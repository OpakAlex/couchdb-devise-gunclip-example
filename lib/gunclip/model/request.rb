module Gunclip
  module Model
    module Request

      extend self

      def request(type, url, data=nil, headers={})
        headers.merge! default_headers
        params = {body: Oj.dump(data), headers: headers}

        case type
          when :post
            post_request(url, params)
          when :put
            put_request(url, params)
          when :get
            get_request(url, params)
          when :delete
            delete_request(url, params)
          when :head
            head_request(url, params)
          else
            nil
        end
      end

      def post_request(url, params)
        Excon.post(url, params)
      end

      def put_request(url, params)
        Excon.put(url, params)
      end

      def delete_request(url, params)
        Excon.delete(url, params)
      end

      def get_request(url, params)
        Excon.get(url, params)
      end

      def head_request(url, params)
        Excon.head(url, params)
      end

      private

      def default_headers
        {"Content-Type" => "application/json"}
      end

    end
  end
end