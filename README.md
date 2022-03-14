# Bullet Train Application Template

## Get Started Building a New Application with Bullet Train
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

## Bullet Train Basics

If you're using Bullet Train for the first time, start by learning these five techniques:

#### 1. Use `rails g model` to create and `bin/super-scaffold` to scaffold a new model:

```
$ rails g model Project team:references name:string
$ bin/super-scaffold crud Project Team name:text_field
```

#### 2. Use `rails g migration` and `bin/super-scaffold` to add a new field to a model you've already scaffolded:

```
$ rails g migration add_description_to_projects description:text
$ bin/super-scaffold crud-field Project description:trix_editor
```
    
These first two points are just the tip of the iceberg, so when you're ready, be sure to [learn more about Super Scaffolding](https://github.com/bullet-train-co/bullet_train-base/blob/main/docs/super-scaffolding.md).

#### 3. Figure out which ERB views are powering something you see in the UI:

 - Right click the element.
 - Select "Inspect Element".
 - Look for the `<!--XRAY START ...-->` comment above the element you've selected.

#### 4. Figure out the full I18N translation key of any string on the page:

 - Add `?show_locales=true` to the URL.

#### 5. Use `bin/resolve` to figure out where framework or theme things are coming from and eject them if you need to customize something locally:

```
$ bin/resolve Users::Base
$ bin/resolve en.account.teams.show.header --open
$ bin/resolve shared/box --open --eject
```

Also, for inputs that can't be provided on the shell, there's an interactive mode where you can paste them:

```
$ bin/resolve --interactive --eject --open
```

And then paste any input, e.g.:

```
<!--XRAY START 73 /Users/andrewculver/.rbenv/versions/3.1.1/lib/ruby/gems/3.1.0/gems/bullet_train-themes-light-1.0.10/app/views/themes/light/commentary/_box.html.erb-->
```

## Contributing to Bullet Train
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
