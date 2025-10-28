const path = require('path');
const { execSync } = require("child_process");
const glob  = require('glob').sync

if (!process.env.THEME) {
  throw "tailwind.config.js: missing process.env.THEME"
  process.exit(1)
}
  
const themeConfigFile = execSync(`bundle exec bin/theme tailwind-config ${process.env.THEME}`).toString().trim()
let themeConfig = require(themeConfigFile)

// *** Uncomment the block below if you want to override the base color. ***
// Note, that you need to specify primary and secondary in addition to base.
// The settings here will override and clobber the theme settings in theme.rb
// (which is likely to be deprecated soon).
//
/*
themeConfig.theme.extend.colors = ({colors}) => ({
  base: colors.stone,
  primary: colors.blue,
  secondary: colors.blue,
})
*/

// *** Uncomment these if required for your overrides ***

// const defaultTheme = require('tailwindcss/defaultTheme')
// const colors = require('tailwindcss/colors')

// *** Add your own overrides here ***

// themeConfig.theme.extend.fontFamily.sans = ['Custom Font Name', ...themeConfig.theme.extend.fontFamily.sans]
// themeConfig.theme.extend.fontSize['2xs'] = '.75rem'
// themeConfig.content.push('./app/additional/path')
// themeConfig.plugins.push(require('additional-tailwind-plugin'))

module.exports = themeConfig
