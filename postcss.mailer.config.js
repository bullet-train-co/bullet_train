const { execSync } = require("child_process");

const postcssImportConfigFile = execSync(`bundle exec bin/theme postcss-import-config ${process.env.THEME}`).toString().trim()
const postcssImportConfig = require(postcssImportConfigFile)

module.exports = {
  plugins: [
    require('postcss-import')(postcssImportConfig),
    require('postcss-extend-rule'),
    // CSS variables aren't currently well supported in email clients.
    // https://www.caniemail.com/search/?s=variables
    // Maybe someday we can remove this next plugin for the mailer stylesheet.
    require('postcss-css-variables'),
    require('tailwindcss/nesting'),
    require('tailwindcss'),
    require('autoprefixer'),
  ]
}
