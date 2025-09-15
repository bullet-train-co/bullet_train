# Pin npm packages by running ./bin/importmap

# Automatic integrity calculation for enhanced security
enable_integrity!
pin "application.importmaps", integrity: true
pin_all_from 'app/javascript/controllers', under: 'controllers', integrity: true
pin "@hotwired/stimulus", to: "@hotwired--stimulus.js" # @3.2.2
# This file is provided by importmaps, I think?
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
