module TicketMaster::Provider
  # This is the Rally Provider for ticketmaster
  module Rally
    include TicketMaster::Provider::Base
    #TICKET_API = Rally::Ticket
    #PROJECT_API = RallyAPI::Project
    
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
      TicketMaster::Provider::Rally.rally = RallyAPI.authenticate(auth.url, auth.username, auth.password)
    end
    
    # declare needed overloaded methods here
    
    # Upon auth, collect all Rally projects
    def projects(*options)
      if options.empty?
        Project.find(:all).collect{|repo| Project.new repo }
      elsif options.first.is_a?(Array)
        options.collect{ |name| Project.find(:user => @client.user.username, :repo => name)}
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


