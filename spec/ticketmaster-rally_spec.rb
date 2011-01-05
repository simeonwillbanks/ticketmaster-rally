require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Ticketmaster::Provider::Rally" do
  
  it "should be able to instantiate a new instance" do
    @ticketmaster = TicketMaster.new(:rally, {:url => 'https://trial.rallydev.com/slm', :username => 'simeon.willbanks@publish2.com', :password => 'Password'})
    @ticketmaster.should be_an_instance_of(TicketMaster)
    @ticketmaster.should be_a_kind_of(TicketMaster::Provider::Rally)
  end
  
end
