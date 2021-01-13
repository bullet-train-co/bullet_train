// tailwind.config.js
const defaultTheme = require('tailwindcss/defaultTheme')
const colors = require('tailwindcss/colors')

module.exports = {
  purge: {
    content: ["./app/**/*.html.erb"],
  },
  darkMode: false, // or 'media' or 'class'
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
