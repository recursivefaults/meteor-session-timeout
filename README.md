meteor-session-timeout
======================

A simple meteorite package to give you session timeouts.


Configuration
=============
In your json settings file, you can add the following two options

inactivityTimeout - This is the number of milliseconds a user has of
inactivity before being forcibly logged out. It defaults to 30000 (5 minutes).

purgeInterval - This is the number of milliseconds that the package will use 
in a setInterval to purge all inactive sessions from Meteor. It defaults to
3000 (3 seconds)
