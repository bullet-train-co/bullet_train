# Pulling Updates Into Your Application

## Overview

As an optional prerequisite, please read our blog article describing [how and why Bullet Train is distributed the way it is](https://blog.bullettrain.co/how-is-bullet-train-distributed/).

To upgrade the framework, you’ll simply merge the upstream Bullet Train repository into your local repository. If you haven’t tinkered with the framework defaults at all, then this should happen with no meaningful conflicts at all. Simply run your automated tests (including the comprehensive integration tests Bullet Train ships with) to make sure everything is still working as it was before.

If you _have_ modified some framework defaults _and_ we also happened to update that same logic upstream, then pulling the most recent version of the framework should cause a merge conflict in Git, which will give you an opportunity to compare our upstream changes with your local customizations and resolve them in a way that makes sense for your application.

Practically speaking, most framework updates will be a feature branch that you merge our upstream changes into, and then after it checks out in testing, you can merge that into main.

## Steps

### 1. Make sure you're working with a clean local copy.
```
git status
```

If you've got uncommitted or untracked files, you can clean them up with the following.

```
# ⚠️ This will destroy any uncommitted or untracked changes and files you have locally.
git checkout .
git clean -d -f
```

### 2. Fetch the latest and greatest from the Bullet Train repository.
```
git fetch bullet-train
````

### 3. Create a new "upgrade" branch off of your main branch.

```
git checkout main
git checkout -b updating-bullet-train
```

### 4. Merge in the newest stuff from Bullet Train and resolve any merge conflicts.

```
git merge bullet-train/main
```

It's quite possible you'll get some merge conflicts at this point. No big deal! Just go through and resolve them like you would if you were integrating code from another developer on your team. We tend to comment our code heavily, but if you have any questions about the code you're trying to understand, let us know on Slack!

```
git diff
git add -A
git commit -m "Upgrading Bullet Train."
```

### 5. Run Tests.

```
rails test
```

### 6. Merge into `main` and delete the branch.

```
git checkout main
git merge updating-bullet-train
git push origin main
git branch -d updating-bullet-train
```

Alternatively, if you're using GitHub, you can push the `updating-bullet-train` branch up and create a PR from it and let your CI integration do it's thing and then merge in the PR and delete the branch there. (That's what we typically do.)
