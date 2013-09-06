Package.describe({
    "summary": "Simple configurable session timeout"
});

Package.on_use(function (api) {
    api.use('coffeescript', ['server', 'client']);
    api.use('jquery', 'client');
    api.use('underscore', 'server');
    api.add_files('server/server_timeout.coffee', 'server')
    api.add_files('client/client_timeout.coffee', 'client')
});
