// tailwind.config.js
const defaultTheme = require('tailwindcss/defaultTheme')
const colors = require('tailwindcss/colors')

module.exports = {
  purge: {
    content: [
      "./app/**/*.html.erb",
      "./app/**/*.js",
      "./app/**/*.css",
      "./app/**/*.scss"
    ]
  },
  darkMode: 'media',
  theme: {
    extend: {
      fontSize: {
        'xs': '.81rem',
      },
      colors: {
        red: {
          darker: '#652424',
          DEFAULT: '#e86060',
          light: '#ee8989',
        },
        yellow: {
          darker: '#6e6446',
          DEFAULT: '#fbe6a8',
          light: '#fcedbe',
        },
        blue: {
          light: '#95acff',
          lightish: '#448eef',
          DEFAULT: '#047bf8',
          dark: '#0362c6',
          darker: '#00369D',
        },
        green: {
          darker: '#166e0c',
          dark: '#1b850f',
          DEFAULT: '#71c21a',
          light: '#c5f0c0',
        },
        sealBlue: {
          100: '#232942',
          200: '#293145',
          300: '#2b344e',
          400: '#323c58',
          500: '#4D566F',
          600: '#777E94',
          700: '#9facc7',
          800: '#b3bcde',
          900: '#ccd9e8'
        },
        vividBlue: {
          700: '#1c4cc3',
          800: '#0e369a'
        },
        black: {
          100: '#000000',
          200: '#101112',
          300: '#171818',
          400: '#292b2c',
          DEFAULT: '#000000',
        }
      },
      fontFamily: {
        // "Avenir Next W01", "Proxima Nova W01", "", -apple-system, system-ui, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif
        sans: ['Inter var', ...defaultTheme.fontFamily.sans],
      },
    },
  },
  variants: {
    extend: {},
  },
  plugins: [
    require('@tailwindcss/forms'),
    require('@tailwindcss/typography'),
  ],
}
