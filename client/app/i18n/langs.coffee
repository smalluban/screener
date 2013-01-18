# Loader for use i18n library
$.i18n().load

  # Create language file in this path with pattern: lang_code.coffee
  # with content module.exports = ... { hash of texts }
  # and put it here
  'en' : require 'i18n/en' # sample english file with "sample" text
