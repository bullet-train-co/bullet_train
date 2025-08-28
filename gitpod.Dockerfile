FROM gitpod/workspace-postgres
USER gitpod

RUN _ruby_version=ruby-3.4.5 \
    && printf "rvm_gems_path=/home/gitpod/.rvm\n" > ~/.rvmrc \
    && bash -lc "rvm reinstall ruby-${_ruby_version} && rvm use ruby-${_ruby_version} --default && gem install rails" \
    && printf "rvm_gems_path=/workspace/.rvm" > ~/.rvmrc \
    && printf '{ rvm use $(rvm current); } >/dev/null 2>&1\n' >> "$HOME/.bashrc.d/70-ruby"

# Install Redis.
RUN curl https://packages.redis.io/gpg | sudo apt-key add - \
 && echo "deb https://packages.redis.io/deb $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/redis.list \
 && sudo apt-get update \
 && sudo apt-get install -y redis libvips graphviz \
 && sudo rm -rf /var/lib/apt/lists/*
