// 🚫 DEFAULT RAILS INCLUDES
// This section represents the default includes for a Rails 6.0.0-rc1 application. Bullet Train's includes and your own
// includes should be specified at the end of the file, not in this section. This helps avoid merge conflicts in the
// future should the framework defaults change.

// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

require("@rails/ujs").start()
require("turbolinks").start()
require("@rails/activestorage").start()
require("channels")

// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
// const images = require.context('../images', true)
// const imagePath = (name) => images(name, true)

// 🚫 DEFAULT BULLET TRAIN INCLUDES
// This section represents the default settings for a Bullet Train application. Your own includes should be specified
// at the end of the file. This helps avoid merge conflicts in the future, should we need to change our own includes.

global.$ = require('jquery')
require("bootstrap")
require("bootstrap-validator")
require("tether")
require("popper.js")
require("slick-carousel")

// // These are the packages Light Admin depends on. We recommend only enabling the ones you need as you need them.
// // You'll also need to do an `yarn install {library}` before these work.
// require("chart.js")
// require("ckeditor")
// require("datatables.net")
// require("datatables.net-bs")
// require("dropzone")
// require("editable-table")
// require("fullcalendar")
// require("ion-rangeslider")
// require("jquery-bar-rating")
// require("moment")
// require("perfect-scrollbar")

// // For some of the libraries above, you also want to include their CSS.
require("slick-carousel/slick/slick.scss")
// require("perfect-scrollbar/dist/css/perfect-scrollbar.min.css")
// require("fullcalendar/dist/fullcalendar.min.css")
// require("datatables.net-bs/css/dataTables.bootstrap.min.css")
// require("dropzone/dist/dropzone")

// Custom JavaScript for Bullet Train
require("../index")

// For inline use in `app/views/account/onboarding/user_details/edit.html.erb`.
global.jstz = require("jstz");

// ✅ YOUR APPLICATION'S INCLUDES
// If you need to customize your application's includes, this is the place to do it. This helps avoid merge
// conflicts in the future when Rails or Bullet Train update their own default includes.
