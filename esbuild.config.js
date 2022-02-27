const path = require('path');
const { execSync } = require("child_process");

require("esbuild").build({
  entryPoints: [
    path.join(process.cwd(), "app/javascript/application.js"),
    path.join(process.cwd(), "app/javascript/intl-tel-input-utils.js")
  ],
  bundle: true,
  sourcemap: true,
  outdir: path.join(process.cwd(), "app/assets/builds"),
  // absWorkingDir: path.join(process.cwd(), "app/javascript"),
  loader: {
    ".png": "file",
    ".jpg": "file",
    ".svg": "file",
    ".woff": "file",
    ".ttf": "file",
    ".eot": "file",
  },
  watch: process.argv.includes("--watch"),
  plugins: [],
}).catch(() => process.exit(1));
