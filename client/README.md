# Brunch with Spine Template
Simple template of brunch with spinejs framework specialy created for PhoneGap application boilerplate.

## Getting started
You'll need [brunch](https://github.com/brunch/brunch). Then use in terminal:

	brunch new app_name --skeleton https://github.com/smalluban/brunch-with-spine.git

More info about how brunch works on thier github site.

## Css styles for mobile devices

Template has already created `@media queries` for tablets and mobile phones. 
It is very simple to use. Files created in `app/styles` will be added to compiled 
css files. It has to have right prefix on the end of file (before `.styl`):

* `-global` - for all types
* `-tablet` - only tablets (768px width and more)
* `-tablet-landscpae` - only tablets in landscape mode
* `-tablet-portrait` - only tablets in portrait mode
* `-phone` - only mobile phones (less than 768px width)
* `-phone-landscape` - only mobile phones in landscape mode
* `-phone-portrait` - only mobile phones in portrait mode

You have to uncomment include tags of css files in `app/assets/index.html` to get it work.

## Multi language support

In default application support multi-language from [jquery.i18n](https://github.com/wikimedia/jquery.i18n).
To add new language Put your files in `app/i18n` directory and load it in `langs.coffee` like show examples in file.

To use translate texts use `$.i18n()` function. For more info see 
[wiki](https://github.com/wikimedia/jquery.i18n/wiki/_pages) page.