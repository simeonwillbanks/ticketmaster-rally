module TicketMaster::Provider
  module Rally
    # Ticket class for ticketmaster-rally
    #
    # Remaps 
    #
    # id => oid
    # title => name
    # requestor => submitted_by
    # resolution => schedule_state
    # status => state
    # created_at => creation_date
    # updated_at => last_update_date    
    # assignee => owner    
    class Ticket < TicketMaster::Provider::Base::Ticket

      def initialize(*object)
        if object.first
          args = object
          ticket = args.shift
          project_id = args.shift
          @system_data = {:client => ticket}
          hash = {
            :oid => ticket.oid,
            :project_id => project_id,
            :title => ticket.name,
            :description => ticket.description,
            :requestor => ticket.submitted_by,
            :resolution => ticket.schedule_state, 
            :status => ticket.state,
            :created_at => Time.parse(ticket.creation_date),
            :updated_at => Time.parse(ticket.last_update_date)
          }
          # Rally optional attributes
          hash[:assignee] = ticket.owner if ticket.owner
          # From Rally Web Services API Documentation v1.21 
          # Allowed values for Defect.Priority:	"", 
          #                                     "Resolve Immediately", 
          #                                     "High Attention", 
          #                                     "Normal", 
          #                                     "Low"
          # When "" Rally Ruby REST API returns <Priority>None</Priority>
          # Unless API returns allowed value, don't set priority
          hash[:priority] = ticket.priority unless ticket.priority == "None"
          super(hash)
        end
      end
      
      # Rally REST API aliases String and Fixnum :to_q :to_s
      # However, it does not alias Bignum
      # If a ID is a Bignum, the API will throw undefined method
      # Because of this, we pass all IDs to API as strings
      # Ticketmaster specs set IDs as integers, so coerce type on get 
      def id
        oid.to_i
      end

      def id=(oid)
        id = oid
      end      

      def self.find_by_id(project_id, id)
        project = self.rally_project(project_id)
        # Rally Ruby REST API expects IDs as strings
        # See note on Project::id
        id = id.to_s unless id.is_a? String
        query_result = TicketMaster::Provider::Rally.rally.find(:defect, :fetch => true, :project => project) { equal :object_i_d, id }
        self.new query_result.first
      end

      # Accepts a project id and attributes hash and returns all 
      # tickets matching the project and those attributes in an array
      # Should return all project tickets if the attributes hash is empty
      def self.find_by_attributes(project_id, attributes = {})
        self.search(project_id, attributes)
      end            
      
      # This is a helper method to find
      def self.search(project_id, options = {}, limit = 1000)
        project = self.rally_project(project_id)
        query_result = TicketMaster::Provider::Rally.rally.find_all(:defect, :project => project)
        tickets = query_result.collect do |ticket| 
          self.new ticket
        end
        search_by_attribute(tickets, options, limit)
      end
      
      private
      
        def self.rally_project(project_id)
          ticketmaster_project = provider_parent(self)::Project.find_by_id(project_id)
          ticketmaster_project.system_data[:client]
        end
      
    end
  end
end
