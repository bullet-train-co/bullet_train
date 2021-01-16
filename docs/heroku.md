# Deploying to Heroku

When you're ready to deploy to Heroku, it's highly recommended you use this button:

[![Deploy](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy?template=http://github.com/bullet-train-co/bullet-train-tailwind-css)

In order for this to work, you'll need to authorize Heroku to access your GitHub account.

This button leverages the configuration found in `app.json`, including sensible defaults for dyno formation, third-party services, buildpack configuration, etc.

## Additional Required Steps
Even after using the above button, there are a few steps that need to be performed manually using the [Heroku CLI](https://devcenter.heroku.com/articles/heroku-cli):

### Add Heroku as a Remote in Your Local Repository

```
heroku git:remote -a YOUR_HEROKU_APP_NAME
```

After this, you'll be able to deploy updates to your app like so:

```
git push heroku main
````

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

### Adding Your Actual Domain

The most common use case for Bullet Train applications is to be hosted at some appropriate subdomain (e.g. `app.YOURDOMAIN.COM`) while a marketing site is hosted with a completely different service at the apex domain (e.g. just `YOURDOMAIN.COM`) or `www.YOURDOMAIN.COM`. To accomplish this, do the following in your shell:

```
heroku domains:add app.YOURDOMAIN.COM
```

The output for this command will say something like:

```
Configure your app's DNS provider to point to the DNS Target SOMETHING-SOMETHING-XXX.herokudns.com.
```

On most DNS providers this means going into the DNS records for `YOURDOMAIN.COM` and adding a *CNAME* record for the `app` subdomain with a value of `SOMETHING-SOMETHING-XXX.herokudns.com` (except using the actual value provided by the Heroku CLI) and whatever TTL refresh rate you desire. I always set this as low as possible at first to make it easier to fix any mistakes I've made.

After you've added that record, you need to update the following environment settings on the Heroku app:

```
heroku config:set BASE_URL=https://app.YOURDOMAIN.COM
heroku config:set MARKETING_SITE_URL=https://YOURDOMAIN.COM
```

You'll also need to enable Heroku's Automated Certificate Management to have them handle provisioning and renewing your Let's Encrypt SSL certificates:

```
heroku certs:auto:wait
```

You should be done now and your app should be available at `https://app.YOURDOMAIN.COM/account` and any hits to `https://app.YOURDOMAIN.COM` (e.g. when users sign out, etc.) will be redirected to your marketing site.
