module TicketMaster::Provider
  # This is the Rally Provider for ticketmaster
  module Rally
    include TicketMaster::Provider::Base

    # This is for cases when you want to instantiate using TicketMaster::Provider::Rally.new(auth)
    def self.new(auth = {})
      TicketMaster.new(:rally, auth)
    end
    
    # Providers must define an authorize method. This is used to initialize and set authentication
    # parameters to access the API
    def authorize(auth = {})
      @authentication ||= TicketMaster::Authenticator.new(auth)
      auth = @authentication
      if ((auth.url.nil? || auth.url.empty?) and (auth.username.nil? || auth.username.empty?) and (auth.password.nil? || auth.password.empty?))
        raise "Please you should provide a Rally url, username and password"
      end
      TicketMaster::Provider::Rally.rally = RallyRestAPI.new(:username => auth.username, 
                                                             :password => auth.password,
                                                             :base_url => auth.url)
                                                             
    end
    
    # declare needed overloaded methods here
    
    def valid?
      begin
        TicketMaster::Provider::Rally.rally.find_all(:project).first
        true
      rescue
        false
      end
    end

    def self.rally=(rally_instance)
      @rally = rally_instance
    end

    def self.rally
      @rally
    end

  end
end


