FROM ruby:2.6.3

# Add user
RUN useradd -ms /bin/bash username
RUN echo 'username:userpassword' | chpasswd

RUN curl -sL https://deb.nodesource.com/setup_10.x | bash -

RUN apt-get update -yqq \
  && apt-get install -yqq --no-install-recommends \
  openjdk-11-jre-headless \
  openssh-server \
  cmake \
  vim \
  nodejs \
  wget \
  && apt-get -q clean \
  && rm -rf /var/lib/apt/lists

RUN mkdir /var/run/sshd

ENV DOCKERIZE_VERSION v0.6.1
RUN wget https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && tar -C /usr/local/bin -xzvf dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && rm dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz

RUN > /etc/java-11-openjdk/accessibility.properties

WORKDIR /app

COPY Gemfile* ./

RUN gem install bundler
RUN bundle install

COPY . .  

CMD rails s
