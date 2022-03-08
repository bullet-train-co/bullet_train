# Bullet Train Application Template

## Getting Started

### Building a New Application with Bullet Train

You don't want to "Fork" the template repository on GitHub. Instead, you should:

1. Clone the template repository:

```
git clone git@github.com:bullet-train-co/bullet_train.git your_new_project_name
cd your_new_project_name
```

2. Run the configuration script:

```
bin/configure
```

### Contributing to Bullet Train

If you want to contribute to Bullet Train, you should "Fork" the template repository on GitHub, like so:

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

#### Below are instructions for developers working on applications built with Bullet Train.
🚅 `bin/configure` will remove everything above this line when you begin building an application.

# Untitled Application

## Getting Started

1. Install Dependencies

Before you can get started developing, you must have the following dependencies installed:

 - Ruby 3.1
 - PostgreSQL 13
 - Redis 6.2
 - Node 16.14
 - [Chrome](https://www.google.com/search?q=chrome) (for headless browser tests)

If you don't have these installed, you can use [rails.new](https://rails.new) to help with the process.

2. Run the setup script:

```
bin/setup
```

3. Start the application:

```
bin/dev
```

4. Visit http://localhost:3000.
