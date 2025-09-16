# Pin npm packages by running ./bin/importmap

# Automatic integrity calculation for enhanced security
enable_integrity!
pin "application.importmaps", integrity: true
pin_all_from 'app/javascript/controllers', under: 'controllers', integrity: true
pin_all_from 'app/javascript/channels', under: 'channels', integrity: true
pin "app/javascript/support/jstz", integrity: true

pin "@hotwired/stimulus", to: "@hotwired--stimulus.js" # @3.2.2

# This file is provided by importmaps, I think?
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
# This file is provided by the activestorage gem
pin "@rails/activestorage", to: "activestorage.esm.js"
# This file is proviced by the turbo-rails gem
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "jstz" # @2.1.1
