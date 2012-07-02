# encoding: utf-8

module Ouija
  module Medium
    class Yaml
      DEFAULT_CONFIG_DIRNAME = 'ouija'

      def channel(options={})
        config_dirname = options[:config_dirname] || DEFAULT_CONFIG_DIRNAME
        config_path = options[:config_path]
        config_files = find_config_files(config_dirname, config_path)
        config_map = {}
        config_files.each do |config_file|
          section_name = File.basename(config_file, '.*')
          begin
            config_data = YAML.load_file(config_file)
          rescue Exception => ex
            raise Ouija::Medium::Error.new "Failed to load YAML file \"#{config_file}\".\nError message: #{ex.message}"
          end
          config_map[section_name] = config_data
        end
        config_map
      end

      protected

      def find_config_files(config_dirname, config_path=nil)
        if !config_path.nil? && !config_path.empty?
          config_dir = search_for_config_dir(config_dirname, config_path)
          raise Error.new("Could not find configuration directory \"#{config_dirname}\" in path \"#{config_path}\".") if config_dir.nil?
        else
          config_dir = search_for_config_dir(config_dirname, '.')
          raise Error.new("Could not find configuration directory \"#{config_dirname}\".") if config_dir.nil?
        end
        Dir.glob(File.join(config_dir, '*.yml'), File::FNM_CASEFOLD)
      end

      def search_for_config_dir(config_dirname, path)
        config_dir = nil
        if File.directory?(path)
          if File.basename(path) == config_dirname
            config_dir = path
          else
            possible_dir = File.join(path, config_dirname)
            if File.exists?(possible_dir)
              config_dir = possible_dir
            else
              possible_dir = File.join(path, 'config', config_dirname)
              if File.exists?(possible_dir)
                config_dir = possible_dir
              end
            end
          end
        end
        config_dir.nil? ? nil : File.expand_path(config_dir)
      end
    end
  end
end
