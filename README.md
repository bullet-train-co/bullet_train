# Bullet Train Application Template

If you're new to Bullet Train, start with the [Bullet Train Developer Documentation](https://tailwind.bullettrain.co/docs) and the [Getting Started](https://tailwind.bullettrain.co/docs/getting-started) guide.

## Building a New Application with Bullet Train
If you're building a new application with Bullet Train, you don't want to "Fork" the template repository on GitHub. Instead, you should:

1. Clone the template repository:

    ```
    $ git clone git@github.com:bullet-train-co/bullet_train.git your_new_project_name
    $ cd your_new_project_name
    ```

2. Run the configuration script:

    ```
    $ bin/configure
    ```

## Contribute to Bullet Train
If you're looking contribute to Bullet Train, you should "Fork" this template repository on GitHub, like so:

1. Visit https://github.com/bullet-train-co/bullet_train.
2. Click "Fork" in the top-right corner.
3. Select the account where you want to fork the repository.
4. Click the "Code" button on the new repository and copy the SSH path.
5. Clone your forked repository using the SSH path you copied, like so:

    ```
    $ git clone git@github.com:your-account/bullet_train.git
    $ cd bullet_train
    ```

6. Run the setup script:

    ```
    $ bin/setup
    ```

7. Start the application:

    ```
    $ bin/dev
    ```

8. Visit http://localhost:3000.

---

This `README.md` file will be replaced with [`README.md.example`](./README.md.example) after running `bin/configure`.
