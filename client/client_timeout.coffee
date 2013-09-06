if Meteor.isClient
    session_heartbeat = null
    session_checkInterval = Meteor.settings.purgeInterval || 3000
    Deps.autorun () ->
      if !session_heartbeat and Meteor.userId()?
        session_heartbeat = Meteor.setInterval(() ->
          console.log Meteor.userId()
          $('body').on('mousemove', () ->
            Meteor.call('session_heartbeat', Meteor.userId())
            $('body').off('mousemove')
          )
        , session_purgeInterval)
      if !Meteor.userId()?
        Meteor.clearInterval(session_heartbeat)
        session_heartbeat = null
        $('body').off('mousemove')

    Deps.autorun () ->
      if Meteor.user()?.services?.resume.loginTokens.length == 0
        Meteor.logout()
