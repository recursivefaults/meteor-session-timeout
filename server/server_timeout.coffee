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
      timeout = Date.now()
      timeout -= Meteor.settings.inactivityTimeout || 300000
      user_ids = _.pluck(Sessions.find({heartbeat: {$lt: timeout}}).fetch(), 'user_id')
      if user_ids.length
         Meteor.users.update({_id: {$in: user_ids}} ,{$set: {'services.resume.loginTokens': []}})
         Sessions.remove({user_id: {$in: user_ids}})

   , interval)

