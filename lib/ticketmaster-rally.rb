require File.dirname(__FILE__) + '/rally/rally-api'

%w{ rally ticket project comment }.each do |f|
  require File.dirname(__FILE__) + '/provider/' + f + '.rb';
end
