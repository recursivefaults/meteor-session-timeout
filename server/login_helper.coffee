if Meteor.isServer
   Accounts.validateLoginAttempt (attemptInfo) ->
      if attemptInfo?.user?.services?.resume?.forceLogout
         Meteor.users.update(attemptInfo.user._id, {$unset: {'services.resume.forceLogout': ''}})
      return true
