Package.describe({
    "summary": "Simple session timeout for Meteor" 
});

Package.on_use(function (api) {
    api.use('coffeescript', 'server');
    api.add_files('server/server_timeout.coffee', 'server')
    api.add_files('client/client_timeout.coffee', 'client')
    
});
