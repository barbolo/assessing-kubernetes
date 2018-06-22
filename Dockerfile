FROM ruby:2.5.1

RUN apt-get update -qq && apt-get install -y build-essential

# Update time zone
RUN ln -sf /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime
RUN dpkg-reconfigure -f noninteractive tzdata

# for mysql2
RUN apt-get install -y ruby-mysql2

# add app directory
ENV APP_HOME /assessing-kubernetes
RUN mkdir $APP_HOME
WORKDIR $APP_HOME

# bundle gems in a separate volume
ENV BUNDLE_GEMFILE=$APP_HOME/Gemfile BUNDLE_JOBS="$(nproc)" BUNDLE_PATH=/bundle

# Add application binaries paths to PATH
ENV PATH $APP_HOME/bin:$BUNDLE_PATH/bin:$PATH

ADD . $APP_HOME
