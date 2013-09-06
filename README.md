meteor-session-timeout
======================

A simple meteorite package to give you session timeouts.


Configuration
-------------
In your json settings file, you can add the following two options

`inactivityTimeout` - This is the number of milliseconds a user has of
inactivity before being forcibly logged out. It defaults to 30000 (5 minutes).

`purgeInterval` - This is the number of milliseconds that the package will use 
in a setInterval to purge all inactive sessions from Meteor. It defaults to
3000 (3 seconds)


How it Works
------------

### On the server

The server uses a mongo collection named "session_timeout" to store the
timeouts of user sessions.

There is also a method exposed called session_heartbeat that is used to update
the timeout values of those sessions.

Finally we periodically check those sessions for all users and if we find any
that are expired we destroy all of that users login tokens. That is done
because there isn't really a better way to force a user out of Meteor at this
time.

### On the client

The client does two things. First, it watches the user's loginTokens and if
they wind up empty (Because of timeout) they are logged out using the
Meteor.logout() method.

Second, we set a timer to check and see if there is mouse movement happening
anywhere in the application. If there is we call the heartbeat method. We then
remove the event listeners and whatnot for the next time the timer fires.
