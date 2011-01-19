require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Ticketmaster::Provider::Rally" do
  
  before(:all) do 
    @auth = {:url => 'https://community.rallydev.com/slm', 
             :username => 'ticketmaster-rally@simeonfosterwillbanks.com', 
             :password => 'Password'}
  end

  it "should be able to instantiate a new instance directly" do
    @ticketmaster = TicketMaster::Provider::Rally.new(@auth)
    @ticketmaster.should be_an_instance_of(TicketMaster)
    @ticketmaster.should be_a_kind_of(TicketMaster::Provider::Rally)
  end
  
  it "should be able to instantiate a new instance from parent" do
    @ticketmaster = TicketMaster.new(:rally, @auth)
    @ticketmaster.should be_an_instance_of(TicketMaster)
    @ticketmaster.should be_a_kind_of(TicketMaster::Provider::Rally)
  end
  
end
