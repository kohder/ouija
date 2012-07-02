# encoding: utf-8
require 'yaml'

module Ouija
  LIBRARY_PATH = File.join(File.dirname(__FILE__), 'ouija')
  MEDIUM_PATH = File.join(LIBRARY_PATH, 'medium')

  class Error < StandardError; end

  module Medium
    class Error < Ouija::Error; end

    autoload :Yaml, File.join(MEDIUM_PATH, 'yaml')
  end

  %w{
  planchette
  ouija
  }.each {|lib| require File.join(LIBRARY_PATH, lib) }
end
