const path = require('path');
const { execSync } = require("child_process");
const glob  = require('glob').sync

// Glob plugin derived from:
// https://github.com/thomaschaaf/esbuild-plugin-import-glob
// https://github.com/xiaohui-zhangxh/jsbundling-rails/commit/b15025dcc20f664b2b0eb238915991afdbc7cb58
const ImportGlobPlugin = () => ({
  name: 'require-context',
  setup: (build) => {
    build.onResolve({ filter: /\*/ }, async (args) => {
      console.log('resolveDir', args.resolveDir)
      if (args.resolveDir === '') {
        return; // Ignore unresolvable paths
      }
      console.log('path', args.path)
      return {
        path: args.path,
        namespace: 'import-glob',
        pluginData: {
          resolveDir: args.resolveDir,
        },
      };
    });

    build.onLoad({ filter: /.*/, namespace: 'import-glob' }, async (args) => {
      const files = (
        glob(args.path, {
          cwd: args.pluginData.resolveDir,
        })
      ).sort();

      let importerCode = `
        ${files
          .map((module, index) => `import * as module${index} from './${module}'`)
          .join(';')}
        export default [${files
          .map((module, index) => `module${index}.default`)
          .join(',')}];
        export const context = {
          ${files.map((module, index) => `'${module}': module${index}.default`).join(',')}
        }
      `;

      return { contents: importerCode, resolveDir: args.pluginData.resolveDir };
    });
  },
});

require("esbuild").build({
  entryPoints: [
    path.join(process.cwd(), "app/javascript/application.js"),
    path.join(process.cwd(), "app/javascript/intl-tel-input-utils.js")
  ],
  define: {
    global: "window"
  },
  bundle: true,
  sourcemap: true,
  outdir: path.join(process.cwd(), "app/assets/builds"),
  // absWorkingDir: path.join(process.cwd(), "app/javascript"),
  loader: {
    ".png": "file",
    ".jpg": "file",
    ".svg": "file",
    ".woff": "file",
    ".woff2": "file",
    ".ttf": "file",
    ".eot": "file",
  },
  watch: process.argv.includes("--watch"),
  plugins: [
    ImportGlobPlugin()
  ],
  // TODO: Silencing warnings until the charset warning is fixed.
  logLevel: 'error',
}).catch(() => process.exit(1));
