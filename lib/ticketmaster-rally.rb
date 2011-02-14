require 'rubygems'
require 'rally_rest_api'
require 'time'

#RALLY_LOGGER_PATH = nil
# Turn on Rally REST API logging by setting constant to path
RALLY_LOGGER_PATH = File.join(File.dirname(__FILE__), '..', 'log', 'rally.log')

if RALLY_LOGGER_PATH && File.exists?(File.dirname(RALLY_LOGGER_PATH))
  require 'logger'
end

%w{ rally ticket project comment }.each do |f|
  require File.dirname(__FILE__) + '/provider/' + f + '.rb';
end
