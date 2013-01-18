exports.config =
  # See http://brunch.readthedocs.org/en/latest/config.html for documentation.
  files:
    javascripts:
      joinTo:
        'javascripts/app.js': /^app/
        'javascripts/vendor.js': /^vendor/
        'test/javascripts/test.js': /^test(\/|\\)(?!vendor)/
        'test/javascripts/test-vendor.js': /^test(\/|\\)(?=vendor)/
      order:
        # Files in `vendor` directories are compiled before other files
        # even if they aren't specified in order.before.
        before: [
          'vendor/scripts/console-helper.js',
          'vendor/scripts/jquery-1.8.3.js',
          'vendor/scripts/underscore-1.4.0.js',
          'vendor/scripts/spine.js'
        ]

    stylesheets:
      joinTo:
        'stylesheets/global.css': /^(app\/styles\/.*-global|vendor)/
        'stylesheets/phone.css': /^app\/styles\/.*-phone\.styl/
        'stylesheets/phone-landscape.css': /^app\/styles\/.*-phone-landscape\.styl/
        'stylesheets/phone-portrait.css': /^app\/styles\/.*-phone-portrait\.styl/
        'stylesheets/tablet.css': /^app\/styles\/.*-tablet\.styl/
        'stylesheets/tablet-landscape.css': /^app\/styles\/.*-tablet-landscape\.styl/
        'stylesheets/tablet-portrait.css': /^app\/styles\/.*-tablet-portrait\.styl/
        'test/stylesheets/test.css': /^test/
      order:
        before: ['vendor/styles/normalize-1.0.1.css']
        after: ['vendor/styles/helpers.css']

    templates:
      joinTo: 'javascripts/app.js'
