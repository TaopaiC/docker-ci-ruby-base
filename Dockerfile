# CI Ruby
#
# VERSION 1
#
# docker build -t ci_ruby_base .

FROM ubuntu:14.04
MAINTAINER TaopaiC, pctao.tw@gmail.com
# packages
RUN dpkg-divert --local --rename /usr/bin/ischroot && ln -sf /bin/true /usr/bin/ischroot
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get upgrade -y && apt-get clean
RUN apt-get update && \
    apt-get install -y git-core curl zlib1g-dev build-essential libssl-dev libreadline-dev libyaml-dev libsqlite3-dev sqlite3 \
                       libxml2-dev libxslt1-dev libcurl4-openssl-dev python-software-properties software-properties-common && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# rbenv
RUN git clone https://github.com/sstephenson/rbenv.git ~/.rbenv
RUN mkdir -p ~/.rbenv/plugins && git clone https://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build
RUN echo 'export PATH=$HOME/.rbenv/bin:$PATH\neval "$(rbenv init -)"' >> /etc/profile.d/rbenv.sh && . /etc/profile.d/rbenv.sh
# ruby
ENV CONFIGURE_OPTS --disable-install-doc
# #RUN bash -lc '~/.rbenv/plugins/ruby-build/bin/ruby-build 2.0.0-p451 ~/.rbenv/versions/2.0.0'
RUN bash -lc 'for v in 2.0.0-p481 2.1.2; do $HOME/.rbenv/plugins/ruby-build/bin/ruby-build $v $HOME/.rbenv/versions/$v; done'
# bundler for all ruby
RUN echo 'gem: --no-rdoc --no-ri' >> /.gemrc
RUN bash -lc 'for v in 2.0.0-p481 2.1.2; do rbenv global $v; gem install bundler; rbenv rehash; done'
# nodejs
RUN apt-add-repository -y ppa:chris-lea/node.js && apt-get update && apt-get install -y nodejs && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
ENV PATH $HOME/.rbenv/shims:$HOME/.rbenv/bin:$PATH