# Deploying to Heroku

When you're ready to deploy to Heroku, it's highly recommended you use this button:

[![Deploy](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy?template=http://github.com/bullet-train-co/bullet-train-tailwind-css)

In order for this to work, you'll need to authorize Heroku to access your GitHub account.

This button leverages the configuration found in `app.json`, including sensible defaults for dyno formation, third-party services, buildpack configuration, etc.

## What's Included?

### Required Add-Ons
We've included the "entry-level but production-grade" service tier across the board for:

 - [Heroku Postgres](https://elements.heroku.com/addons/heroku-postgresql)
 - [Heroku Redis](https://elements.heroku.com/addons/heroku-redis) to support Sidekiq and Action Cable.
 - [Memcachier](https://elements.heroku.com/addons/memcachier) to support Rails Cache.
 - [HDrive](https://elements.heroku.com/addons/hdrive) to support off-server file uploads backed by AWS S3.
 - [Cloudinary](https://cloudinary.com) to support off-server image uploads and ImageMagick processing.
 - [Heroku Scheduler](https://elements.heroku.com/addons/scheduler) for cron jobs.
 - [Rails Autoscale](https://railsautoscale.com) for best-of-breed reactive performance monitoring.
 - [Honeybadger](https://www.honeybadger.io) and [Sentry](https://elements.heroku.com/addons/sentry), both free, for redundant error tracking.
 - [Expedited Security](https://expeditedsecurity.com)'s [Real Email](https://elements.heroku.com/addons/realemail) to reduce accounts created with fake and unreachable emails, which will subsequently hurt your email deliverability.

### Speeding Up Asset Precompilation
Historically asset compilation could take as long as four minutes when deploying to Heroku. Through the inclusion of three custom buildpacks provided by [Jan Žák](https://github.com/zakjan), [Hirotaka Ikoma](https://github.com/hikoma), and [others](https://github.com/bullet-train-co/heroku-buildpack-cachesave/commits/master), we're able to reduce that part of the deploy process down to about 30 seconds.

We've forked these three buildpacks into our own GitHub organization to help mitigate the risk of a [supply chain attack](https://en.wikipedia.org/wiki/Supply_chain_attack) where your application can become compromised via the compromised repository of a third-party buildpack. To reduce this risk even further, you can also fork our copy of the following repositories and configure your Heroku application to use your forked buildpack repositories in place of ours.

 - [heroku-buildpack-cacheload](https://github.com/bullet-train-co/heroku-buildpack-cacheload)
 - [heroku-buildpack-cachesave](https://github.com/bullet-train-co/heroku-buildpack-cachesave)
 - [heroku-buildpack-cleanup](https://github.com/bullet-train-co/heroku-buildpack-cleanup)


## Additional Required Steps
Even after using the above button, there are a few steps that need to be performed manually using the [Heroku CLI](https://devcenter.heroku.com/articles/heroku-cli):

### 1. Add Heroku as a Remote in Your Local Repository

```
heroku git:remote -a YOUR_HEROKU_APP_NAME
```

After this, you'll be able to deploy updates to your app like so:

```
git push heroku main
````

### 2. Running Database Migrations and Seeds
We've decided not to configure the application to automatically run database migrations after a deploy for the time being. For that reason, you'll need to run the migrations and seeds manually, like so:

```
heroku run rake db:migrate
heroku run rake db:seed
```

### 3. Enabling Runtime Dyno Metadata
We include [Honeybadger](http://honeybadger.io) and Sentry (both at a free tier) for redundant error tracking by default. Sentry requires the following Heroku labs feature to be enabled:

```
heroku labs:enable runtime-dyno-metadata
```

### 4. Adding Your Actual Domain

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
heroku certs:auto:enable
heroku certs:auto
```

You should be done now and your app should be available at `https://app.YOURDOMAIN.COM/account` and any hits to `https://app.YOURDOMAIN.COM` (e.g. when users sign out, etc.) will be redirected to your marketing site.
