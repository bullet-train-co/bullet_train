const path = require('path');
const { execSync } = require("child_process");
const glob = require('glob').sync

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

let themeFile = ""
if (process.env.THEME) {
  themeFile = execSync(`bundle exec bin/theme javascript ${process.env.THEME}`).toString().trim()
}

// Could also swap to packs?
const otherEntrypoints = {}
glob("app/javascript/entrypoints/**/*.*")
  .forEach((file) => {
    // strips app/javascript/entrypoints from the key.
    const key = path.join(path.dirname(file), path.parse(file).name).split(path.sep + "entrypoints" + path.sep)[1]
    const value = "." + path.sep + path.join(path.dirname(file), path.basename(file))
    otherEntrypoints[key] = value
  });

const themeEntrypoints = {}
if (process.env.THEME) {
  themeEntrypoints[`application.${process.env.THEME}`] = themeFile
}

let build_details = {
  entryPoints: {
    ...otherEntrypoints,
    "application": path.join(process.cwd(), "app/javascript/application.js"),
    "intl-tel-input-utils": path.join(process.cwd(), "app/javascript/intl-tel-input-utils.js"),
    ...themeEntrypoints,
  },
  define: {
    global: "window"
  },
  bundle: true,
  // ESM + Splitting will only work if the script is type="module"
  // splitting: true,
  // format: "esm",
  minify: true,
  format: "iife",
  sourcemap: true,
  outdir: path.join(process.cwd(), "app/assets/builds"),
  loader: {
    ".png": "file",
    ".jpg": "file",
    ".svg": "file",
    ".woff": "file",
    ".woff2": "file",
    ".ttf": "file",
    ".eot": "file",
  },
  plugins: [
    ImportGlobPlugin()
  ],
  // TODO: Silencing warnings until the charset warning is fixed.
  logLevel: 'error'
}

async function serve_with_esbuild() {
  let ctx = await require("esbuild").context(build_details)

  await ctx.watch()

  let { host, port } = await ctx.serve({
    servedir: path.join(process.cwd(), "app/assets/builds")
  })
}

if(process.argv.includes("--watch")) {
  serve_with_esbuild()
} else {
  require("esbuild").build(build_details)
}
