module TicketMaster::Provider
  module Rally
    # The comment class for ticketmaster-rally
    #
    # Remaps 
    #
    # id => oid
    # author => user_name
    # body => text
    # created_at => creation_date
    # updated_at => creation_date    
    class Comment < TicketMaster::Provider::Base::Comment
      
      def initialize(*object)
        if object.first
          args = object
          comment = args.shift
          project_id = args.shift
          ticket_id = args.shift
          @system_data = {:client => comment}
          hash = {
            :oid         => comment.oid,
            :project_id  => project_id,
            :ticket_id   => ticket_id,
            :author      => comment.user_name,
            :body        => comment.text,
            :created_at  => comment.creation_date,
            :updated_at  => comment.creation_date,
            :post_number => comment.post_number,
          }
          super(hash)
        end
      end

      def created_at
        Time.parse(self[:created_at])
      end

      def updated_at
        Time.parse(self[:updated_at])
      end

      # Rally REST API aliases String and Fixnum :to_q :to_s
      # However, it does not alias Bignum
      # If a ID is a Bignum, the API will throw undefined method
      # Because of this, we pass all IDs to API as strings
      # Ticketmaster specs set IDs as integers, so coerce type on get 
      def id
        self[:oid].to_i
      end

      def id=(id)
        self[:oid] = id.to_s
      end 

      def self.find_by_id(project_id, ticket_id, id)
        project = self.rally_project(project_id)
        # Rally Ruby REST API expects IDs as strings
        # For id.to_s see note on Project::id
        query_result = TicketMaster::Provider::Rally.rally.find(:conversation_post, :fetch => true, :project => project) { equal :object_i_d, id.to_s }
        self.new query_result.first, project_id
      end

      # Accepts a project id, ticket id and attributes hash and returns all 
      # comments matching the project, ticket and those attributes in an array
      # Should return all ticket comments if the attributes hash is empty
      def self.find_by_attributes(project_id, ticket_id, attributes = {})
        self.search(project_id, ticket_id, attributes)
      end            
      
      # This is a helper method to find
      def self.search(project_id, ticket_id, options = {}, limit = 1000)
        project = self.rally_project(project_id)
        artifact = project.ticket(:id => ticket_id.to_s)
        query_result = TicketMaster::Provider::Rally.rally.find_all(:conversation_post, :project => project) { equal :artifact, artifact }
        comments = query_result.collect do |comment| 
          self.new comment, project_id, ticket_id
        end
        search_by_attribute(comments, options, limit)
      end
      
      def self.create(*options)
        options = options.shift
        project = provider_parent(self)::Project.find_by_id(options[:project_id])
        ticket = provider_parent(self)::Ticket.find_by_id(options[:project_id], options[:ticket_id])
        comment = {
          :project => project.system_data[:client],
          :artifact => ticket.system_data[:client],
          :text => options[:body]
        }
        new_comment = TicketMaster::Provider::Rally.rally.create(:conversation_post, comment)
        self.new new_comment
      end
      
      private
      
        def self.rally_project(project_id)
          ticketmaster_project = provider_parent(self)::Project.find_by_id(project_id)
          ticketmaster_project.system_data[:client]
        end
              
        def self.to_rally_object(hash)
          ticket = {
            :name => hash[:title],
            :description => hash[:description],
            :schedule_state => hash[:resolution] ||= "Defined", 
            :state => hash[:status] ||= "Submitted"     
          }
          # Rally optional attributes
          ticket[:submitted_by] = hash[:requestor] if hash[:requestor]
          ticket[:owner] = hash[:assignee] if hash[:assignee]
          ticket[:priority] = hash[:priority] if hash[:priority]
          ticket[:work_product] = hash[:work_product] if hash[:work_product]
          ticket          
        end
    end
  end
end
