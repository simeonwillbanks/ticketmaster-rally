require 'rubygems'
require 'rally_rest_api'

#RALLY_LOGGER_PATH = nil
# Turn on Rally REST API logging by setting constant to path
RALLY_LOGGER_PATH = '/Users/sfw/Desktop/rally.log'

if RALLY_LOGGER_PATH
  require 'logger'
end

%w{ rally ticket project comment }.each do |f|
  require File.dirname(__FILE__) + '/provider/' + f + '.rb';
end
