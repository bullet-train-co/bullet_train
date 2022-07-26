# Bullet Train Application Template
If you're new to Bullet Train, start with the [Bullet Train Developer Documentation](https://bullettrain.co/docs) and the [Getting Started](https://bullettrain.co/docs/getting-started) guide. You should also [join the community Discord server](https://discord.gg/bullettrain)!

## Building a New Application with Bullet Train
If you're building a new application with Bullet Train, you don't want to "Fork" the template repository on GitHub. Instead, you should:

1. Clone the template repository:

    ```
    git clone git@github.com:bullet-train-co/bullet_train.git your_new_project_name
    ```

2. Enter the project directory:

    ```
    cd your_new_project_name
    ```

3. Run the configuration script:

    ```
    bin/configure
    ```

## Cloud Development with Gitpod

[![Open in Gitpod](https://gitpod.io/button/open-in-gitpod.svg)](https://gitpod.io/#https://github.com/bullet-train-co/bullet_train)

Clicking this button will set up a new Bullet Train project for development on [Gitpod](https://gitpod.io).

<br>

<p align="center">
<strong>Open-source development sponsored by:</strong>
</p>

<p align="center">
<a href="https://www.clickfunnels.com"><img src="https://images.clickfunnel.com/uploads/digital_asset/file/176632/clickfunnels-dark-logo.svg" width="575" /></a>
</p>

<br>
<br>

## Provisioning a Production Environment
You can use this public repository to provision a new application and then push your private application code there later.

### Heroku

[![Deploy to Heroku](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy?template=http://github.com/bullet-train-co/bullet_train)

Clicking this button will take you to the first step of a process that, when completed, will provision production-grade infrastructure and services for your Bullet Train application which will cost about **$140/month**.

Once that process has completed, be sure to complete the other steps from the [Deploying to Heroku](https://bullettrain.co/docs/heroku) documentation.

### Render

[![Deploy to Render](https://render.com/images/deploy-to-render-button.svg)](https://render.com/deploy?repo=https://github.com/bullet-train-co/bullet_train)

Clicking this button will take you to the first step of a process that, when completed, will provision production-grade infrastructure for your Bullet Train application which will cost about **$30/month**.

When you're done deploying to Render, you need to go into "Dashboard" > "web", copy the server URL, and then go into "Env Groups" > "settings" and paste the URL into the value for `BASE_URL`.



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

8. Visit http://localhost:3000.

---

This `README.md` file will be replaced with [`README.example.md`](./README.example.md) after running `bin/configure`.
