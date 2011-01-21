require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Ticketmaster::Provider::Rally::Project" do

  before(:all) do 
    @project_name = "Sample Project"
    @project_id = 2712835688
    @project_created_at = "Tue Jan 18 15:40:28 UTC 2011"
  end

  before(:each) do
    @ticketmaster = TicketMaster.new(:rally, {:url => 'https://community.rallydev.com/slm', 
                                              :username => 'ticketmaster-rally@simeonfosterwillbanks.com', 
                                              :password => 'Password'})
    @klass = TicketMaster::Provider::Rally::Project
  end

  it "should be able to load all projects" do
    @ticketmaster.projects.should be_an_instance_of(Array)
    @ticketmaster.projects.first.should be_an_instance_of(@klass)
  end

  it "should be able to find a project by id" do
    project = @ticketmaster.project(@project_id)
    project.should be_an_instance_of(@klass)
    project.name.should == @project_name
    project.id.should == @project_id
    project.created_at.to_s.should == @project_created_at
  end

  it "should be able to load all projects from an array of ids" do 
    projects = @ticketmaster.projects([@project_id])
    projects.should be_an_instance_of(Array)
    projects.first.should be_an_instance_of(@klass)    
    projects.first.name.should == @project_name
    projects.first.id.should == @project_id    
    projects.first.created_at.to_s.should == @project_created_at
  end

  it "should be able to load all projects from attributes" do 
    projects = @ticketmaster.projects(:name => @project_name)
    projects.should be_an_instance_of(Array)
    projects.first.should be_an_instance_of(@klass)
    projects.first.name.should == @project_name
    projects.first.id.should == @project_id    
    projects.first.created_at.to_s.should == @project_created_at
  end
  
  it "should be able to load projects using the find method" do
    @ticketmaster.project.should == @klass
    @ticketmaster.project.find(@project_id).should be_an_instance_of(@klass)
  end

end
