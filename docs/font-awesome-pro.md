# Font Awesome Pro

By default, Bullet Train ships with both [Themify Icons](https://themify.me/themify-icons) and [Font Awesome Pro's Light icons](https://fontawesome.com/icons?d=gallery&s=light) preconfigured for each menu item. However, Font Awesome Pro is a [paid product](https://fontawesome.com/plans), so by default Bullet Train falls back to showing the Themify icons.

In our experience, there is no better resource than Font Awesome Pro for finding the perfect icon for every model when you're using Super Scaffolding, so we encourage you to make the investment. Once you configure Font Awesome Pro in your environment, its icons will take precedence over the Themify Icons that were provided as a fallback.

## Configuring Font Awesome Pro

### 1. Set Authentication Token Environment Variable

Once you buy a license for Font Awesome Pro, set `FONTAWESOME_NPM_AUTH_TOKEN` in your shell environment to be equal to your key as presented [on their instructions page](https://fontawesome.com/how-to-use/on-the-web/setup/using-package-managers). Unfortunately, it's not enough to simply set `FONTAWESOME_NPM_AUTH_TOKEN` in `config/application.yml` like you might be thinking, because that value won't be picked up when you run `yarn install`.

#### If you're using **Bash**:
- Add `export FONTAWESOME_NPM_AUTH_TOKEN=XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX` in `~/.bashrc`.
- Restart your terminal.

#### If you're using **zsh**:
- Add `export FONTAWESOME_NPM_AUTH_TOKEN=XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX` in `~/.zshrc`.
- Restart your terminal.

If you're configuring this in another type of shell, please let us know what the steps are [in a new GitHub issue](http://github.com/bullet-train-co/bullet-train-tailwind-css/issues/new) and we'll add them here for others.

### 2. Merge the Font Awesome Pro Mix-In (Optional)

We've pushed up [a branch with the remaining steps already done](https://github.com/bullet-train-co/bullet-train-tailwind-css/compare/mixins/font-awesome-pro). You can merge it into your project like so:

```
git merge bullet-train/mixins/font-awesome-pro
````

If that worked for you, you can stop now. 🛑

### 3. Add `.npmrc` Configuration

Create a `.npmrc` file in the root of your project if you don't already have one, and add the following to it:

```
@fortawesome:registry=https://npm.fontawesome.com/
//npm.fontawesome.com/:_authToken=${FONTAWESOME_NPM_AUTH_TOKEN}
```

This will pull the environment variable in, but also be compatible with the way we need to supply this value when deploying to Heroku.

### 4. Add Font Awesome Pro npm Package

Once you've got your Font Awesome Pro authentication token configured, you can run:

```
yarn add @fortawesome/fontawesome-pro
```

No, that's not a typo. [That's the name of their company.](https://fortawesome.com) If you receive an error at this point, be sure you restarted your terminal, and reach out for help!

### 5. Add Font Awesome Pro to Webpacker

In `app/javascript/packs/application.js`, below `require("@icon/themify-icons/themify-icons.css")`, add:

```
require("@fortawesome/fontawesome-pro/css/all.css")
```
