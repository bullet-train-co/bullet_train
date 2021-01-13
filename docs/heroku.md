# Deploying to Heroku

When you deploy to Heroku, you'll need to set the `BASE_URL` environment variable to `https://whatever-your-app-is-called.herokuapp.com` before your first deploy so asset compilation will succeed. (Be sure to later update this value if you register a custom domain.) You can set this configuration value using the Heroku CLI like so:

```
heroku config:set BASE_URL=https://whatever-your-app-is-called.herokuapp.com
```
