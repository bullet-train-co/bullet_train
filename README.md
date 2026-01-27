# Bullet Train Application Template
If you're new to Bullet Train, start with the [Bullet Train Developer Documentation](https://bullettrain.co/docs) and the [Getting Started](https://bullettrain.co/docs/getting-started) guide. You should also [join the community Discord server](https://discord.gg/bullettrain)!

## Prerequisites

### On macOS

You can use [Homebrew](https://brew.sh) to install all required dependencies, including:

 - [rbenv](https://github.com/rbenv/rbenv) and [ruby-build](https://github.com/rbenv/ruby-build) for Ruby version management
 - [nvm](https://github.com/nvm-sh/nvm) and [Yarn](https://yarnpkg.com) for Node version and package management
 - [PostgreSQL](https://www.postgresql.org) as a relational database
 - [Redis](https://redis.io) for Action Cable WebSockets and background job queues

The instructions below will explain when to run `brew bundle`.

## Building a New Application with Bullet Train
If you're building a new application with Bullet Train, you don't want to "Fork" the template repository on GitHub. Instead, you should:

1. Clone the template repository:

    ```
    git clone https://github.com/bullet-train-co/bullet_train.git your_new_project_name
    ```

2. Enter the project directory:

    ```
    cd your_new_project_name
    ```

4. If you're on macOS, you can use [Homebrew](https://brew.sh) to install all dependencies:

    ```
    brew bundle
    ```

    ### Additional nvm configuration

    If Homebrew is installing nvm for the first time, there are some additional steps you need to take:

    ```
    mkdir ~/.nvm
    touch ~/.zshrc
    open ~/.zshrc
    ```

    When the editor opens, paste the following into `~/.zshrc`:

    ```
    export NVM_DIR="$HOME/.nvm"
    [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"
    [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"
    ```

    ### Additional rbenv configuration

    If Homebrew is installing rbenv for the first time, there are some additional steps you need to take:

    ```
    rbenv init
    rbenv install `cat .ruby-version`
    ```

    > ⚠️ You'll need to open a new shell before continuing. The easiest way to do this on macOS is hitting `⌘` + `T` to open a new tab in the same working directory.   

6. Make sure Node.js is properly configured:

    ```
    source ~/.zshrc
    nvm install
    corepack enable
    ```

   > ⚠️ You'll need to open a new shell before continuing. The easiest way to do this on macOS is hitting `⌘` + `T` to open a new tab in the same working directory.

7. Run the configuration and setup scripts:

    ```
    bin/configure
    bin/setup
    ```
    
8. Boot your application:

    ```
    bin/dev
    ```
    
9. Visit `http://localhost:3000`.

<br>
<br>

<p align="center">
<strong>Open-source development sponsored by:</strong>
</p>

<p align="center">
<a href="https://www.clickfunnels.com"><img src="https://statics.myclickfunnels.com/workspace/Yjxavr/image/15795008/file/e4d910a06aaea6730652fb2cf60531a6.svg" width="575" /></a>
</p>

<br>
<br>

## Provisioning a Production Environment
You can use this public repository to provision a new application and then push your private application code there later.

### Render

[![Deploy to Render](https://render.com/images/deploy-to-render-button.svg)](https://render.com/deploy?repo=https://github.com/bullet-train-co/bullet_train)

Clicking this button will take you to the first step of a process that, when completed, will provision production-grade infrastructure for your Bullet Train application which will cost about **$30/month**.

### Heroku

[![Deploy to Heroku](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy?template=http://github.com/bullet-train-co/bullet_train)

Clicking this button will take you to the first step of a process that, when completed, will provision production-grade infrastructure and services for your Bullet Train application which will cost about **$140/month**.

Once that process has completed, be sure to complete the other steps from the [Deploying to Heroku](https://bullettrain.co/docs/heroku) documentation.

## Contribute to Bullet Train
If you're looking contribute to Bullet Train, you should "Fork" this template repository on GitHub, like so:

1. Visit https://github.com/bullet-train-co/bullet_train.
2. Click "Fork" in the top-right corner.
3. Select the account where you want to fork the repository.
4. Click the "Code" button on the new repository and copy the SSH path.
5. Clone your forked repository using the SSH path you copied, like so:

    ```
    git clone git@github.com:your-account/bullet_train.git
    cd bullet_train
    ```

6. Run the setup script:

    ```
    bin/setup
    ```

7. Start the application:

    ```
    bin/dev
    ```

    > [!NOTE]
    > Optional: If you have [ngrok](https://ngrok.com/) installed, uncomment `ngrok: ngrok http 3000` from `Procfile.dev` and run
    > `bin/set-ngrok-url` to set `BASE_URL` to a publically accessible domain.
    > Run `bin/set-ngrok-url` after restarting `ngrok` to update `BASE_URL` to
    > the current public url.

8. Visit http://localhost:3000.

---

This `README.md` file will be replaced with [`README.example.md`](./README.example.md) after running `bin/configure`.

