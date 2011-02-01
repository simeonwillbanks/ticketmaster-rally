# ticketmaster-rally

This is a provider for [ticketmaster](http://ticketrb.com). It provides interoperability with [Rally](http://www.rallydev.com/) and it's project planning system through the ticketmaster gem.

# Usage and Examples

First we have to instantiate a new ticketmaster instance, your Rally installation should have api access enable:
    rally = TicketMaster.new(:rally, {:username=> 'foo', :password => "bar", :url => "https://community.rallydev.com/slm"}) 

If you do not pass in the url, username and password, you won't get any information.

## Finding Projects(Projects)

    rally = TicketMaster.new(:rally, {:url => 'https://community.rallydev.com/slm', 
                                             :username => 'foo', 
                                             :password => 'bar'})
    # Project with ID of 1
    project = rally.project(1)
    # Projects with IDs of 1 and 2
    projects = rally.project([1,2])
	
## Finding Tickets(Defects,Tasks)

Coming Soon

## Open Tickets
    
Coming Soon

## Finding comments
      
Coming Soon

## Requirements

* rubygems (obviously)
* ticketmaster gem (latest version preferred)
* rally_rest_api
* logger (only if you want Rally REST API to log activity)

## Other Notes

Since this and the ticketmaster gem is still primarily a work-in-progress, minor changes may be incompatible with previous versions. Please be careful about using and updating this gem in production.

If you see or find any issues, feel free to open up an issue report.

## Copyright

Copyright (c) 2011 Simeon Willbanks. See LICENSE.txt for
further details.


