module TicketMaster::Provider
  # This is the Rally Provider for ticketmaster
  module Rally
    include TicketMaster::Provider::Base
    #TICKET_API = Rally::Ticket
    #PROJECT_API = Rally::Project
    
    # This is for cases when you want to instantiate using TicketMaster::Provider::Rally.new(auth)
    def self.new(auth = {})
      TicketMaster.new(:rally, auth)
    end
    
    # Providers must define an authorize method. This is used to initialize and set authentication
    # parameters to access the API
    def authorize(auth = {})
      @authentication ||= TicketMaster::Authenticator.new(auth)
      auth = @authentication
      if (auth.url.blank? and auth.username.blank? and auth.password.blank?)
        raise "Please you should provide a Rally url, username and password"
      end
      RallyRestAPI.new(:username => auth.username, 
                       :password => auth.password,
                       :base_url => auth.url)
    end
    
    # declare needed overloaded methods here
    
  end
end


