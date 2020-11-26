const {styles} = require('@ckeditor/ckeditor5-dev-utils');

module.exports = {
  test: /ckeditor5-[^/\\]+[/\\]theme[/\\].+\.css/,
  use: [
    'style-loader',
    'css-loader', {
      loader: 'postcss-loader',
      options: styles.getPostCssConfig({
        themeImporter: {
          themePath: require.resolve('@ckeditor/ckeditor5-theme-lark')
        },
        minify: true
      })
    }
  ]
}
