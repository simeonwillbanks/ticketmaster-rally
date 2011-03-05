require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Ticketmaster::Provider::Rally::Comment" do
  before(:all) do 
    @project_id = 2712835688
    @ticket_id = 2780205298
    @comment_id = 2988719307
    @comment_author = "sfw@simeonfosterwillbanks.com"
  end

  before(:each) do
    @ticketmaster = TicketMaster.new(:rally, {:url => 'https://community.rallydev.com/slm', 
                                              :username => 'ticketmaster-rally@simeonfosterwillbanks.com', 
                                              :password => 'Password'})
    @project = @ticketmaster.project(@project_id)
    @klass = TicketMaster::Provider::Rally::Comment
    @ticket = @project.ticket(:id => @ticket_id)
  end

  it "should be able to load all comments" do
    @ticket.comments.should be_an_instance_of(Array)
    @ticket.comments.first.should be_an_instance_of(@klass)
  end
  
  it "should be able to load all comments based on array of ids" do 
    comments = @ticket.comments([@comment_id])
    comments.should be_an_instance_of(Array)
    comments.first.should be_an_instance_of(@klass)
    comments.first.author.should == @comment_author
  end

  it "should be able to load all comments based on attributes" do 
    comments = @ticket.comments(:id => @comment_id)
    comments.should be_an_instance_of(Array)
    comments.first.should be_an_instance_of(@klass)
    comments.first.author.should == @comment_author
  end
   
  it "should be able to create a new comment" do
    # Add discussion for User Story US8: Order picture package
    ticket = @project.ticket(:id => "2712836091")
    comment = ticket.comment!(:body => 'Pictures will be available for purchase!')
    comment.should be_an_instance_of(@klass)
  end 
   
end
