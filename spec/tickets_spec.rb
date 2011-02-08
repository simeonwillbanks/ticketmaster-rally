require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Ticketmaster::Provider::Rally::Ticket" do
  before(:all) do 
    @project_name = "Sample Project"
    @project_id = 2712835688
    @ticket_id = 2780205298
    @ticket_title = "Safari email alert has wrong subject"
    @ticket_description = "The safari email alert message is 'Safari Email.' It should be 'Awesome Safari Email.'"
    @ticket_requestor = "sfw@simeonfosterwillbanks.com"
    @ticket_resolution = "Defined"
    @ticket_status = "Submitted"
    @ticket_created_at = "Sat Jan 29 19:35:56 UTC 2011"
  end

  before(:each) do
    @ticketmaster = TicketMaster.new(:rally, {:url => 'https://community.rallydev.com/slm', 
                                              :username => 'ticketmaster-rally@simeonfosterwillbanks.com', 
                                              :password => 'Password'})
    @project = @ticketmaster.project(@project_id)
    @klass = TicketMaster::Provider::Rally::Ticket
  end
  
  it "should return the ticket class" do
    @project.ticket.should == @klass
  end

  it "should be able to load all tickets" do 
    @project.tickets.should be_an_instance_of(Array)
    @project.tickets.first.should be_an_instance_of(@klass)
  end

  it "should be able to load all tickets based on array of id's" do
    tickets = @project.tickets([@ticket_id])
    tickets.should be_an_instance_of(Array)
    tickets.first.should be_an_instance_of(@klass)
    tickets.first.description.should == @ticket_description
    tickets.first.project_id.should == @project_id
    tickets.first.created_at.utc.strftime('%a %b %d %H:%M:%S UTC %Y').should == @ticket_created_at
  end

  it "should be able to load a single ticket based on attributes"  do
    ticket = @project.ticket(:id => @ticket_id)
    ticket.should be_an_instance_of(@klass)
    ticket.description.should == @ticket_description
    ticket.project_id.should == @project_id
    ticket.created_at.utc.strftime('%a %b %d %H:%M:%S UTC %Y').should == @ticket_created_at
  end
  
  it "should be able to load all tickets using attributes" do
    tickets = @project.tickets(:status => "Submitted")
    tickets.should be_an_instance_of(Array)
    tickets.first.should be_an_instance_of(@klass)
    tickets.first.description.should == @ticket_description
    tickets.first.project_id.should == @project_id
    tickets.first.created_at.utc.strftime('%a %b %d %H:%M:%S UTC %Y').should == @ticket_created_at
  end

  it "should be able to update and save a ticket" do
    ticket = @project.ticket(@ticket_id)
    ticket.description = "A brand new awesome description"
    ticket.status = "Closed"
    ticket.save
    ticket.description.should == 'A brand new awesome description'
    ticket.status.should == "Closed"
    ticket.description = @ticket_description
    ticket.status = @ticket_status
    ticket.save
    ticket.description.should == @ticket_description
  end
  
  it "should be able to create a new ticket" do
    ticket = @project.ticket!({:title => 'Testing', :description => "Here we go"})
    ticket.should be_an_instance_of(@klass)
  end

end
