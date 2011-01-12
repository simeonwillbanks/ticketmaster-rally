require 'rally_rest_api'

module RallyAPI

  class << self
    def authenticate(url, username, password)
      @rally = RallyRestAPI.new(:username => username, 
                                :password => password,
                                :base_url => url)
    end
  end
  
end  