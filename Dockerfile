FROM ruby:3.0

ENV DOCKERIZE_VERSION v0.6.1

#パッケージの取得
RUN apt-get update && \
    apt-get install -y --no-install-recommends\
    nodejs  \
    mariadb-client  \
    build-essential  \
    wget \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir /exportLC

WORKDIR /exportLC

ADD Gemfile /exportLC/Gemfile
ADD Gemfile.lock /exportLC/Gemfile.lock

RUN gem install bundler
RUN bundle install

ADD . /exportLC

COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
# CMD ["rails", "server", "-b", "0.0.0.0"]
