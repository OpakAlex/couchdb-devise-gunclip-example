module Gunclip
  module Model
    module Configuration

      extend self

      def env
        @env ||= Rails.env.to_sym
      end

      def env= env
        @env = env
      end

      def connection_config_file
        File.join(Dir.pwd, 'config', 'couchdb.yml')
      end

      def config
        configurate[env]
      end

      def configurate
        @config ||= YAML::load_file(connection_config_file).deep_symbolize_keys.merge default_config
      end

      def default_config
        {host: "localhost", protocol: "http"}
      end

    end
  end
end