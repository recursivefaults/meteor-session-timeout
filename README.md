meteor-session-timeout
======================

A simple meteorite package to give you session timeouts.


Minimum Version
---------------
0.7.2


Configuration
-------------
In your json settings file, you can add the following two options

`inactivityTimeout` - This is the number of milliseconds a user has of
inactivity before being forcibly logged out. It defaults to 900000 (15 minutes).

`purgeInterval` - This is the number of milliseconds that the package will use 
in a setInterval to purge all inactive sessions from Meteor. It defaults to
60000 (1 minute)

`sessionTimeoutQuery` - A MongoDB query object restricting the set of users affected by session timeout functionality with a MongoDB query.


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

The client does two things. First, it watches the `services.resume.forceLogout` value
in Meteor.users collection. When it changes to a value evaluated to `true`, the user
is logged out. By default, the user is logged out by `Meteor.logout` method. However,
you can override `Meteor.forcedLogout` method to implement custom logout logic.

Second, we set a timer to check and see if there is mouse movement happening
anywhere in the application. If there is we call the heartbeat method. We then
remove the event listeners and whatnot for the next time the timer fires.
