const path = require('path');
const { execSync } = require("child_process");

const themeStylesheet = execSync(`bundle exec bin/theme tailwind-stylesheet ${process.env.THEME} 2> /dev/null`).toString().trim()
const themeRoot = execSync(`bundle show bullet_train-themes-${process.env.THEME} 2> /dev/null`).toString().trim()
const themeStylesheetsDir = path.resolve(themeRoot, 'app/assets/stylesheets/');

module.exports = {
  plugins: [
    require('postcss-import')({
      resolve: (id, basedir, importOptions) => {
        if (id.startsWith('$ThemeStylesheetsDir')) {
          initial_id = id;
          id = id.replace('$ThemeStylesheetsDir', themeStylesheetsDir);
          console.log(initial_id, "$ThemeStylesheetsDir", themeStylesheetsDir, id)
        } else if (id.startsWith('$ThemeStylesheet')) {
          id = id.replace('$ThemeStylesheet', themeStylesheet);
        }
        return id;
      }
    }),
    require('postcss-extend-rule'),
    require('postcss-nested'),
    require('tailwindcss'),
    require('autoprefixer'),
  ]
}
