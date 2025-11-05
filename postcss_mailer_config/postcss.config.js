const { execSync } = require("child_process");

const postcssImportConfigFile = execSync(`bundle exec bin/theme postcss-import-config ${process.env.THEME}`).toString().trim()
const postcssImportConfig = require(postcssImportConfigFile)
const tailwindImportConfigFile = execSync(`bundle exec bin/theme tailwind-mailer-config ${process.env.THEME}`).toString().trim()

module.exports = {
  plugins: [
    require('postcss-import')(postcssImportConfig),
    require('postcss-extend-rule'),
    // CSS variables aren't currently well supported in email clients.
    // https://www.caniemail.com/search/?s=variables
    // Maybe someday we can remove this next plugin for the mailer stylesheet.
    require('postcss-css-variables'),
    require('tailwindcss/nesting'),
    require('tailwindcss')({ config: tailwindImportConfigFile }),
    require('autoprefixer'),
  ]
}
