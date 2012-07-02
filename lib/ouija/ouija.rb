# encoding: utf-8

module Ouija
  class << self
    def setup(options={})
      @options = options
      # ToDo: For other mediums, include options logic here (defaulting to YAML)
      @channel = stringify_keys_recursive(Medium::Yaml.new.channel(options))
      true
    end

    def topics
      @channel.keys
    end

    def session(topic, context={})
      topic = topic.to_s
      unless topics.include?(topic)
        raise Error.new "Unknown topic \"#{topic}\""
      end
      Planchette.new(scope_topic(topic, context))
    end
    alias_method :séance, :session

    protected
    
    def stringify_keys_recursive(hash)
      stringified_hash = {}
      hash.each_pair do |k,v|
        key = k.kind_of?(Symbol) ? k.to_s : k
        value = v.is_a?(Hash) ? stringify_keys_recursive(v) : v
        stringified_hash[key] = value
      end
      stringified_hash
    end

    def scope_topic(topic, context={})
      hash = @channel[topic] || {}
      environment = context[:environment] || context[:env] || get_environment
      hostname = context[:hostname] || context[:host] || get_hostname

      #puts "Loading config for environment \"#{environment}\" and hostname \"#{hostname}\"."

      base_hash = hash.has_key?('default') ? hash['default'].dup : {}
      if !environment.nil? && !environment.empty? && !hash['environments'].nil? && !hash['environments'][environment.to_s].nil?
        env_hash = hash['environments'][environment.to_s]
        recursive_merge!(base_hash, env_hash)
      end
      if !hostname.nil? && !hostname.empty? && !hash['hosts'].nil? && !hash['hosts'][hostname.to_s].nil?
        host_hash = hash['hosts'][hostname.to_s]
        recursive_merge!(base_hash, host_hash)
      end
      base_hash
    end

    def recursive_merge!(hash, other_hash)
      other_hash.each_pair do |k, v|
        cur_val = hash[k]
        if cur_val.is_a?(Hash) && v.is_a?(Hash)
          hash[k] = recursive_merge!(cur_val, v)
        elsif !v.nil?
          hash[k] = v
        end
      end
      hash
    end

    def get_environment
      @options[:environment] || @options[:env] || ENV['RAILS_ENV'] || ENV['OUIJA_ENV'] || 'development'
    end

    def get_hostname
      @options[:hostname] || @options[:host] || begin
        require 'socket'
        Socket.gethostname rescue nil
      end
    end
  end
end
