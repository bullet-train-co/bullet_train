const path = require('path');
const { execSync } = require("child_process");

const themeRoot = execSync(`bundle show bullet_train-themes-${process.env.THEME} 2> /dev/null`).toString().trim()
const themeStylesheets = path.resolve(themeRoot, 'app/assets/stylesheets/');

module.exports = {
  plugins: [
    require('postcss-import')({
      resolve: (id, basedir, importOptions) => {
        if (id.startsWith('$THEMESTYLESHEETS')) {
          id = id.replace('$THEMESTYLESHEETS', themeStylesheets);
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
