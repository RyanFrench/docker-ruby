FROM ubuntu:14.04.1
MAINTAINER Ryan French <rfrench@lic.co.nz>

ENV RUBY_MAJOR 2.1
ENV RUBY_VERSION 2.1.4

RUN apt-get update && apt-get install -y libpq-dev curl procps \
  autoconf bison build-essential libssl-dev libyaml-dev libreadline6-dev zlib1g-dev \
  libncurses5-dev libffi-dev libgdbm3 libgdbm-dev ruby \
  && rm -rf /var/lib/apt/lists/* \
  && mkdir -p /usr/src/ruby \
  && curl -SL "http://cache.ruby-lang.org/pub/ruby/$RUBY_MAJOR/ruby-$RUBY_VERSION.tar.bz2" \
    | tar -xjC /usr/src/ruby --strip-components=1 \
  && cd /usr/src/ruby \
  && autoconf \
  && ./configure --disable-install-doc \
  && make -j"$(nproc)" \
  && apt-get purge -y --auto-remove bison ruby \
  && make install \
  && cd / \
  && echo 'gem: --no-rdoc --no-ri' >> "$HOME/.gemrc" \
  && rm -r /usr/src/ruby \
  && rm -rf /var/lib/apt/lists/

ENV GEM_HOME /usr/local/bundle
ENV PATH $GEM_HOME/bin:$PATH
RUN gem install bundler \
  && bundle config --global path "$GEM_HOME" \
  && bundle config --global bin "$GEM_HOME/bin"

ENV BUNDLE_APP_CONFIG $GEM_HOME
