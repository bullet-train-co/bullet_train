console.log('application.importmaps reporting')

// 🚫 DEFAULT RAILS INCLUDES
// This section represents the default includes for a Rails application. Bullet Train's includes and your own
// includes should be specified at the end of the file, not in this section. This helps avoid merge conflicts in the
// future should the framework defaults change.

import * as ActiveStorage from "@rails/activestorage"
import "@hotwired/turbo-rails"
// This is made possibly by this line in config/importmap.rb:
// pin_all_from 'app/javascript/controllers', under: 'controllers', integrity: true
import "controllers"
import "channels"

ActiveStorage.start()

console.log('ActiveStorage = ', ActiveStorage);

// 🚫 DEFAULT BULLET TRAIN INCLUDES
// This section represents the default settings for a Bullet Train application. Your own includes should be specified
// at the end of the file. This helps avoid merge conflicts in the future, should we need to change our own includes.

import "support/jstz";


// TODO: If we can get importmaps from the gems working correctly we may not need to explicitly import anything?
//import "@bullet-train/bullet-train"
//import "@bullet-train/bullet-train-sortable"

//require("@icon/themify-icons/themify-icons.css")

import { trixEditor } from "trix_editor"
trixEditor()

// ✅ YOUR APPLICATION'S INCLUDES
// If you need to customize your application's includes, this is the place to do it. This helps avoid merge
// conflicts in the future when Rails or Bullet Train update their own default includes.
