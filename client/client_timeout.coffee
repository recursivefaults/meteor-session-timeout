if Meteor.isClient
   session_heartbeat = null
   session_purgeInterval = Meteor.settings?.public.purgeInterval || 3000
   Deps.autorun () ->
      ###
      # The way this works is by setting up an interval that will
      # set up a jQuery eventlistener for mouse movements. If that
      # event fires, we know you were active and we stop the event
      # and update your session.
      #
      # If it doesn't fire, then the event remains on and we catch
      # the next event that fires.
      ###
      if !session_heartbeat and Meteor.userId()?
         #You're a user, and we haven't started to watch for activity
         session_heartbeat = Meteor.setInterval(() ->
            $('body').on('mousemove', () ->
               #If you move the mouse, we will update your heartbeat, and
               #remove the event listener so that we don't spam.
               Meteor.call('session_heartbeat')
               $('body').off('mousemove')
            )
         , session_purgeInterval)
      if !Meteor.userId()?
         #Turn off the heartbeat if there's no user any more
         Meteor.clearInterval(session_heartbeat)
         session_heartbeat = null
         #Make sure we're not needlessly looking for mouse events
         $('body').off('mousemove')

   Deps.autorun () ->
      if Meteor.user()?.services?.resume?.forceLogout
         #If you have services.resume.forceLogout evaluating to true, you should be logged out
         #The server will purge login tokens while next check
         Meteor.forcedLogout()

   Meteor.forcedLogout = ->
      Meteor.logout()
