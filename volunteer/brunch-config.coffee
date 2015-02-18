exports.config =
  modules:
    definition: false
    wrapper: false
  paths:
    public: 'public'
  files:
    javascripts:
      joinTo:
        'javascripts/vendor.js': /^(bower_components|vendor)/
        'javascripts/app.js': /^app/

    stylesheets:
      joinTo:
        'stylesheets/vendor.css': /^(bower_components|vendor)/
        'stylesheets/app.css':        /^app/
      # order:
        before: [
          'app/stylesheets/app.less'
        ]

    templates:
      joinTo:
        'views/.compile-jade': /^app/  # Hack for auto-compiling Jade templates.

  plugins:
    assetsmanager:
      copyTo:
        'fonts': ['bower_components/font-awesome/fonts/*', 'bower_components/bootstrap/fonts/*']
        '': ['../public/*.png'] # The same icon set as the server.
        'stylesheets': ['../app/assets/stylesheets/theme.css']
        'images': ['../app/assets/images/logo', '../app/assets/images/textures']
  notifications: no

  keyword:
    filePattern: /\.(js|css|html|txt)$/

  sourceMaps: false

  overrides:
    production:
      minify: true
      optimize: true
      sourceMaps: false
      plugins:
        autoReload: enabled: false
        jade: pretty: no
      conventions: ignored: [ /\/angular-mocks\.js$/, /\.mock\.ls$/ ]
    staging:
      conventions: ignored: [ /\/angular-mocks\.js$/, /\.mock\.ls$/ ]
