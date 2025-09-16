# Pin npm packages by running ./bin/importmap

# Automatic integrity calculation for enhanced security
enable_integrity!
pin "application.importmaps", integrity: true
pin_all_from 'app/javascript/controllers', under: 'controllers', integrity: true
pin_all_from 'app/javascript/channels', under: 'channels', integrity: true
pin_all_from "app/javascript/support", under: 'support', integrity: true

pin "@hotwired/stimulus", to: "@hotwired--stimulus.js" # @3.2.2

# This file is provided by importmaps, I think?
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
# This file is provided by the activestorage gem
pin "@rails/activestorage", to: "activestorage.esm.js"
# This file is proviced by the turbo-rails gem
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "jstz" # @2.1.1

# TODO: This block is stuff that's needed by bullet_train-sortable.
# Can we vendor these inside the gem or something?
pin "jquery" # @3.7.1
pin "dragula" # @3.7.3
pin "atoa" # @1.0.0
pin "contra/emitter", to: "contra--emitter.js" # @1.9.4
pin "crossvent" # @1.5.5
pin "custom-event" # @1.0.1
pin "process" # @2.1.0
pin "ticky" # @1.0.1

# TODO: This is needed by the bullet_train gem. Can we handle it there somehow?
pin "el-transition" # @0.0.7
