# Deploying to Heroku

When you're ready to deploy to Heroku, it's highly recommended you use this button:

[![Deploy](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy?template=http://github.com/bullet-train-co/bullet-train-tailwind-css)

In order for this to work, you'll need to authorize Heroku to access your GitHub account.

This button leverages the configuration found in `app.json`, including sensible defaults for dyno formation, third-party services, buildpack configuration, etc.

## Additional Required Steps
Even after using the above button, there are a few steps that need to be performed manually using the [Heroku CLI](https://devcenter.heroku.com/articles/heroku-cli):

### Running Database Migrations and Seeds
We've decided not to configure the application to automatically run database migrations after a deploy for the time being. For that reason, you'll need to run the migrations and seeds manually, like so:

```
heroku run rake db:migrate
heroku run rake db:seed
```

### Enabling Runtime Dyno Metadata
We include [Honeybadger](http://honeybadger.io) and Sentry (both at a free tier) for redundant error tracking by default. Sentry requires the following Heroku labs feature to be enabled:

```
heroku labs:enable runtime-dyno-metadata
```
