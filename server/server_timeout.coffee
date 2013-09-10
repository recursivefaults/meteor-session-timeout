if Meteor.isServer
    @Sessions = new Meteor.Collection("session_timeouts")
    Meteor.methods( {
       session_heartbeat: (user_id) ->
          check(user_id, String)
          old_session = Sessions.findOne({user_id: user_id})
          if old_session?
              Sessions.update({user_id: user_id}, {$set: {heartbeat: Date.now()}})
          else
              Sessions.insert({user_id: user_id, heartbeat: Date.now()})
    })

    interval = Meteor.settings.purgeInterval || 3000
    Meteor.setInterval(() ->
        timeout = Date.now()
        timeout -= Meteor.settings.inactivityTimeout || 300000
        users = _.pluck(Sessions.find({heartbeat: {$lt: timeout}}).fetch(), 'user_id')
        for id in users
            Meteor.users.update(id ,{$set: {'services.resume.loginTokens': []}})
            Sessions.remove({user_id: id})

    , interval)

