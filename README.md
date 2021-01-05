# Bullet Train

## Getting Started

### Step 1: _Clone_ (And Don't Fork) The Repository

First, [create a new private repository on GitHub](https://github.com/new). (Please be careful that the repository you create is actually private, since otherwise you would be redistributing Bullet Train.)

Once you have the new repository ready, clone our repository to your local machine.

```
git clone git@github.com:bullet-train-co/bullet-train-tailwind-css.git your-new-app-name
cd your-new-app-name
git remote rename origin bullet-train
git remote add origin git@github.com:your-username/your-new-app-name.git
git push origin main
```

In those steps you've renamed the original Bullet Train repository to be referred to as `bullet-train` and your own repository is now your `origin`. (This means you'll be able to merge in updates from `bullet-train/main`.)

Using GitHub's "Fork" feature is only for developers when they want to submit a Pull Request to the Bullet Train codebase. It's _not_ the correct way to get started building a new project with Bullet Train.

### Step 1.1: Run Bundler and Yarn

As with any Rails app, you'll need to run `bundle install` and a `yarn install`.

### Step 2: The Basic Site

1. Run `bin/set-name "Whatever Your App Name Is"` to properly configure your database, session store, and application class name.

2. Run `rake db:create`, `rake db:migrate`, and `rake db:seed` to get your database into working condition.

3. Copy `config/application.yml.example` to `config/application.yml` as a baseline for your application configuration.

4. The Tailwind port of Bullet Train currently uses Font Awesome Pro's light icons by default. If you have a license for Font Awesome Pro, you can follow the instructions on their [Getting Started](https://fontawesome.com/how-to-use/on-the-web/setup/using-package-managers) page to add your license key to your environment. After that, you can run `yarn add @fortawesome/fontawesome-pro`.

5. Start the server with `rails s` and visit [http://localhost:3000/](http://localhost:3000/). The first time you render the sign-in page the stylesheets will take a few seconds to compile. Don't worry, it'll cache them going forward.

Your application is now up and running and you can test the sign-up process.

### Step 3. Running the Test Suite!

1. You can run Bullet Train's entire automated test suite in your shell by typing `rails test`. If there are any failing tests out of the box, please submit an issue to us on GitHub so we can investigate what environmental factors may be causing a failure for you. Bullet Train depends on Chrome for headless browser testing, so you'll want to have that installed as well.

Note: Bullet Train has a handful of optional features that are featured-flagged. For example, the Stripe integration and subscription management are completely optional. When you run the test suite with `rails test`, by default it will only run the tests that correspond to your environment settings. However, sometimes it can be helpful to make sure your changes don't break compatibility with other configurations of Bullet Train. For example, but you may not have subscription management implemented yet, but you plan on doing it in the future. In order to test your application in all possible future configurations, there is a `bin/test-all-configurations` script that we've included that will run the test suite in all possible combinations of the feature-flags.

## Deploying to Heroku

When you deploy to Heroku, you'll need to set the `BASE_URL` environment variable to `https://whatever-your-app-is-called.herokuapp.com` before your first deploy so asset compilation will succeed. (Be sure to later update this value if you register a custom domain.) You can set this configuration value using the Heroku CLI like so:

```
heroku config:set BASE_URL=https://whatever-your-app-is-called.herokuapp.com
```

## Other Configuration Options

### Hide Super Scaffolding Examples
Set `HIDE_THINGS=1` in your environment. Don't forget to do this when you go to production as well.

## Pulling New Bullet Train Updates into Your Application

1. Make sure you're working with a clean local copy.
```
git status
```

(If you've got uncommitted or untracked files, you can clean them up with the following. ⚠️ This will destroy any uncommitted or untracked changes and files you have locally.)

```
git checkout .
git clean -d -f
```

2. Fetch the latest and greatest from the Bullet Train repository.
```
git fetch bullet-train
````

3. Create a new "upgrade" branch off of your main branch (e.g. `main` in this example.)

```
git checkout main
git checkout -b updating-bullet-train
```

4. Merge in the newest stuff from Bullet Train and resolve any merge conflicts.

```
git merge bullet-train/main
```

(It's quite possible you'll get some merge conflicts at this point. No big deal! Just go through and resolve them like you would if you were integrating code from another developer on your team. We try to comment our code heavily, but if you have any questions about the code you're trying to understand, let us know on Slack!)

```
git diff
git add -A
git commit -m "Upgrading Bullet Train."
```

5. Run Tests.

```
rails test
```

6. Merge into `main` and delete the branch.

```
git checkout main
git merge updating-bullet-train
git push origin main
git branch -d updating-bullet-train
```

Alternatively, if you're using GitHub, you can push the `updating-bullet-train` branch up and create a PR from it and let CI, etc. do it's thing and then merge in the PR and delete the branch there. (That's what we typically do.)

## Things You Should Know About Bullet Train

### It’s Just Rails on Rails!
Developing a Bullet Train app is the same as developing a Rails app. If you’re familiar with Ruby on Rails, everything within your Bullet Train app will be familiar and understandable to you.

### Simple Distribution
Instead of using Rails application templates or generators, Bullet Train is simply distributed as a repository that you can fork and begin customizing or building on top of.

### Completely Customizable
Although we incorporate some popular third-party gems that provide incredible functionality, Bullet Train itself isn’t distributed as a Ruby Gem and it’s functionality isn’t concealed within one. This means you’re not limited to configuration settings and values that we’ve thought to make available, but all of Bullet Train’s major functionality is available as well-documented code right within your project, so if you need to modify something the framework provides, you can do that right in your own repository!

### Marketing Site
By default Bullet Train provides a beautiful marketing site to get you started. If you want to host your marketing site elsewhere, that’s also no problem at all!

### Authentication
We use the Devise gem for authentication, but we’ve already done the work of making the views all pretty and integrated into the look-and-feel of the application. We also be pre-configuring OAuth login workflows for Stripe Connect which is easily duplicated to allow authentication from any other OAuth providers.

### Authorization
We use the CanCanCan gem for reliably enforcing security rules in your views and controllers. Our super scaffolding feature automatically adds sensible defaults for users to be able to manage their resources, but you can customize anything you may want to in `app/models/ability.rb`.

### The Account and Public Namespaces for Controllers and Views
Many web applications have a private section where users manage their data and separate public pages where that data is presented to site visitors (e.g. Yelp, Airbnb, etc.) To make these applications easy to develop, we have a default `Account` namespace for those private views and controllers where users manage their account data.

### Onboarding
Bullet Train provides an easy to understand and modifiable structure for defining required onboarding steps and forms. This system makes it easy for users to complete required steps before seeing your applications full account interface.

### Super Scaffolding: Code Generation for CRUD Views and Controllers
You can quickly and easily generate the code that allows users to manage their account data and modified that experience as much as you need to. There are no magic libraries, just generated Rails code into your application. You can even edit the base templates we use to do the code generation just like you would any view or controller.

### Fully Responsive
Every single page of your app works on mobile by default.

### Automated Integration Tests
All of Bullet Train’s core functionality is verifiable using the provided test suite. The headless browser integration tests took a ton of time to write, but they give us the peace of mind that nothing is being broken before a deploy.

### Restful API, Webhooks, and Zapier Support
Bullet Train will provide an out-of-the-box Restful API for all the resources in your application, including automatically generated documentation, API token management, webhooks.

### New Features and Ongoing Updates
To upgrade the framework, you’ll simply merge the upstream Bullet Train repository into your local repository. If you haven’t tinkered with the framework defaults at all, then this should happen with no conflicts at all. Simply run your automated tests (including the comprehensive integration tests Bullet Train ships with) to make sure everything is still working as it was before.

If you _have_ modified some framework defaults _and_ we also happened to update that same logic upstream, then pulling the most recent version of the framework should cause a merge conflict in Git, which will give you an opportunity to compare our upstream changes with your local customizations and resolve them in a way that makes sense for your application.

Practically speaking, most framework updates will be a feature branch that you merge our upstream changes into, and then after it checks out in testing, you can merge that into main.

### It’s Weeks of Work, Already Done!
Not only have we done all these things, but we’ve put them all together in a way that feels consistent to the user. There were many design decisions and debugging sessions along the way. All of it has added up to several weeks of work, and there are many more months of work to come in the future. By using Bullet Train as your foundation, you’re saving all that time both now and in the future. It’s like hiring someone to manage all of these features in your application, and keep improving them as well.

[![Deploy](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy?template=https://github.com/bullet-train-co/bullet-train)
