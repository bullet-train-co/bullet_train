# HTTP Tunneling with ngrok

Before your application can take advantage of features that depend on incoming webhooks, you'll need to setup an HTTP tunnel using a service like [ngrok](https://ngrok.com).

## Use a Paid Plan

You should specifically sign up for a paid account. Although ngrok offers a free plan, their $5/month paid plan will allow you to reserve a custom subdomain for reuse each time you spin up your tunnel. This is a critical productivity improvement, because in practice you'll end up configuring your tunnel URL in a bunch of different places like `config/application.yml` but also in external systems like when you [configure payment providers to deliver webhooks to you](docs/billing/stripe.md).

## Usage

Once you have ngrok installed, you can start your tunnel like so, replacing `your-subdomain` with whatever subdomain you reserved in your ngrok account:

```
ngrok http 3000 -subdomain=your-subdomain
```

## Updating Your Configuration

Before your Rails application will accept connections on your tunnel hostname, you need to update `config/application.yml` with:

```
BASE_URL: https://your-subdomain.ngrok.io
```

You'll also need to restart your Rails server:

```
rails restart
```
