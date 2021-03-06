const { environment } = require('@rails/webpacker')
const CopyPlugin = require("copy-webpack-plugin");

const webpack = require('webpack')
environment.plugins.prepend('Provide',
  new webpack.ProvidePlugin({
    $: 'jquery',
    jQuery: 'jquery',
    jquery: 'jquery',
    'window.jQuery': 'jquery',
  })
)

environment.config.externals = ['cloudinary']

// Add support for CKEditor 5.
const CKEditorWebpackPlugin = require( '@ckeditor/ckeditor5-dev-webpack-plugin')

environment.plugins.prepend('CKEditor',
  new CKEditorWebpackPlugin({
    language: 'en'
  })
)

// Copy utils.js from intl-tel-input dependency to `public/assets`.
// See `app/javascript/fields/phone_field.js` for where we use this.
environment.plugins.prepend('CopyPlugin',
  new CopyPlugin({
    patterns: [
      { from: "node_modules/intl-tel-input/build/js/utils.js", to: "../assets/intl-tel-input/utils.js" }
    ]
  })
)

// Define custom loaders for CKEditor's SVG and CSS files.
environment.loaders.append('CKEditorSVGLoader', require('./loaders/ckeditor/svg'))
environment.loaders.append('CKEditorCSSLoader', require('./loaders/ckeditor/css'))

// Tell the standard CSS and file loaders to ignore CKEditor's CSS and SVG files. We have our own loaders for those.
environment.loaders.get('css').exclude = /(\.module\.[a-z]+$)|(ckeditor5-[^/\\]+[/\\]theme[/\\].+\.css)/
environment.loaders.get('file').exclude = /ckeditor5-[^/\\]+[/\\]theme[/\\]icons[/\\][^/\\]+\.svg$/

module.exports = environment
