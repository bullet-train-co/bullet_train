const path = require('path');
const environment = require('../config/webpack/environment');
const { merge } = require('webpack-merge')

module.exports = {
  stories: ['../storybook/**/*.stories.json'],
  addons: [{
    name: '@storybook/addon-essentials',
    options: {
      actions: false,
      docs: false
    }}
    ,
    '@storybook/addon-a11y'
  ],
};
