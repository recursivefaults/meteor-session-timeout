if Meteor.isServer
   @Sessions = new Meteor.Collection("session_timeouts")
   Meteor.methods( {
      session_heartbeat: ->
         user_id = Meteor.userId()
         return unless user_id
         old_session = Sessions.findOne({user_id: user_id})
         if old_session?
            Sessions.update({user_id: user_id}, {$set: {heartbeat: Date.now()}})
         else
            Sessions.insert({user_id: user_id, heartbeat: Date.now()})
   })

   interval = Meteor.settings.purgeInterval || 3000
   Meteor.setInterval(() ->
      loggedOutUsersIds = _.pluck(Meteor.users.find('services.resume.forceLogout': true).fetch(), '_id')
      if loggedOutUsersIds?.length
         Meteor.users.update({_id: {$in: loggedOutUsersIds}},
            {$set: {'services.resume.loginTokens': []},
            $unset: {'services.resume.forceLogout': ''}})

      timeout = Date.now()
      timeout -= Meteor.settings.inactivityTimeout || 300000
      usersToLogOut = _.pluck(Sessions.find({heartbeat: {$lt: timeout}}).fetch(), 'user_id')
      if usersToLogOut?.length
         Meteor.users.update({_id: {$in: usersToLogOut}}, {$set: {'services.resume.forceLogout': true}})
         Sessions.remove({user_id: {$in: usersToLogOut}})

   , interval)

