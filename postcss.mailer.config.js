const { execSync } = require("child_process");

const postcssImportConfigFile = execSync(`bundle exec bin/theme postcss-import-config ${process.env.THEME}`).toString().trim()
const postcssImportConfig = require(postcssImportConfigFile)

module.exports = {
  plugins: [
    require('postcss-import')(postcssImportConfig),
    require('postcss-extend-rule'),
    require('postcss-nested'),
    require('tailwindcss'),
    require('postcss-css-variables'),
    require('autoprefixer'),
  ]
}
