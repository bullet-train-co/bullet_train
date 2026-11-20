---
description: Clone bullet_train-core locally and link all gems to use local versions
---

Clone the bullet_train-core repository into the `local/` directory and update the Gemfile to use all local bullet_train gems.

Default repository: git@github.com:bullet-train-co/bullet_train-core.git

If a repository URL is provided as an argument (e.g., `/clone-and-link-core git@github.com:your-fork/bullet_train-core.git`), use that URL instead of the default.

Steps to perform:
1. Check if `local/bullet_train-core` already exists - if so, ask the user if they want to remove it and re-clone
2. Clone the repository (default or provided URL) into `local/bullet_train-core`
3. Update the Gemfile to replace all bullet_train gem version references with path references to `local/bullet_train-core/<gem-name>`
4. Remove the `BULLET_TRAIN_VERSION` constant if it exists
5. Run `bundle install` to update the bundle
6. Confirm completion and show the user what was linked
