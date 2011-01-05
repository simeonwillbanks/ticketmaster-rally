require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Ticketmaster::Provider::Rally::Ticket" do
  before(:all) do 
    @project_id = 'Iteration 38'
  end

  before(:each) do 
    @ticketmaster = TicketMaster.new(:rally, {:url => 'https://trial.rallydev.com/slm', :username => 'simeon.willbanks@publish2.com', :password => 'Password'})
    @project = @ticketmaster.project(@project_id)
    @klass = TicketMaster::Provider::Rally::Ticket
  end

  it "should be able to load all tickets" do 
    @project.tickets.should be_an_instance_of(Array)
    @project.tickets.first.should be_an_instance_of(@klass)
  end

  it "should be able to load all tickets based on array of id's" do
    @tickets = @project.tickets([1])
    @tickets.should be_an_instance_of(Array)
    @tickets.first.should be_an_instance_of(@klass)
    @tickets.first.summary.should == 'test'
  end

  it "should be able to load all tickets using attributes" do
    @tickets = @project.tickets(:status => "!closed")
    @tickets.should be_an_instance_of(Array)
    @tickets.first.should be_an_instance_of(@klass)
    @tickets.first.summary.should == 'test'
  end

  it "should return the ticket class" do
    @project.ticket.should == @klass
  end

  it "should be able to load a single ticket based on attributes"  do
    @ticket = @project.ticket(:status => "!closed")
    @ticket.should be_an_instance_of(@klass)
    @ticket.summary.should == 'test'
  end

  it "should be able to create a new ticket" do
    @ticket = @project.ticket!({:summary => 'Testing', :description => "Here we go"})
    @ticket.should be_an_instance_of(@klass)
  end

end
