module TicketMaster::Provider
  module Rally
    # Project class for ticketmaster-rally
    #
    # Remaps 
    #
    # id => oid
    # created_at => creation_date
    # updated_at => creation_date
    class Project < TicketMaster::Provider::Base::Project

      def initialize(*object)
        if object.first
          project = object.first
          # Store Rally Project object in Ticketmaster Project object
          # This allows Ticketmaster to perform updates on Rally Project
          @system_data = {:client => project}
          hash = {:oid => project.oid, 
                  :name => project.name, 
                  :description => project.description,
                  :created_at => project.creation_date, 
                  # Rally Project object does not have a modified time
                  :updated_at => project.creation_date}           
          super hash
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

      # Accepts an integer id and returns the single project instance
      def self.find_by_id(id)
        # Rally Ruby REST API expects IDs as strings
        # For id.to_s see note on Project::id
        query_result = TicketMaster::Provider::Rally.rally.find(:project, :fetch => true) { equal :object_i_d, id.to_s }
        self.new query_result.first
      end
      
      # Accepts an attributes hash and returns all projects matching those attributes in an array
      # Should return all projects if the attributes hash is empty
      def self.find_by_attributes(attributes = {})
        self.search(attributes)
      end            
      
      # This is a helper method to find
      def self.search(options = {}, limit = 1000)
        projects = TicketMaster::Provider::Rally.rally.find_all(:project).collect do |project| 
          self.new project
        end
        search_by_attribute(projects, options, limit)
      end      
      
      # copy from this.copy(that) copies that into this
      def copy(project)
        project.tickets.each do |ticket|
          copy_ticket = self.ticket!(:title => ticket.title, :description => ticket.description)
          ticket.comments.each do |comment|
            copy_ticket.comment!(:body => comment.body)
            sleep 1
          end
        end
      end

    end
  end
end


