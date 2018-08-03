FROM gcr.io/gcp-runtimes/ubuntu_16_0_4

##
# Ruby installation
##

# Other versions of node; ruby and bundler can be passed in arg
ARG nodejs_version=8.11.3
ARG ruby_version=2.5.1
ARG bundler_version=1.16.3

ENV RBENV_ROOT=/opt/rbenv \
    DEBIAN_FRONTEND=noninteractive \
    DEFAULT_BUNDLER_VERSION=${bundler_version}

# Install packages
RUN apt-get update -y \
    && apt-get install -y -q --no-install-recommends \
        bzip2 \
        apt-utils \
        autoconf \
        build-essential \
        ca-certificates \
        cmake \
        curl \
        file \
        git \
        libffi-dev \
        libreadline6-dev \
        libssl-dev \
        libyaml-dev \
        libz-dev \
        procps \
        systemtap \
        tzdata \
    && apt-get clean

# Install ruby and node essentials
RUN rm -f /var/lib/apt/lists/*_* \
    && mkdir -p /opt/nodejs \
    && rm -f /etc/ImageMagick-6/policy.xml \
    && git clone https://github.com/sstephenson/rbenv.git ${RBENV_ROOT} \
    && git clone https://github.com/sstephenson/ruby-build.git ${RBENV_ROOT}/plugins/ruby-build \
    && (curl -s https://nodejs.org/dist/v${nodejs_version}/node-v${nodejs_version}-linux-x64.tar.gz \
        | tar xzf - --directory=/opt/nodejs --strip-components=1) \
    && ln -s ${RBENV_ROOT} /rbenv \
    && ln -s /opt/nodejs /nodejs

# Add Path variables (rbenv and node)
ENV PATH=/opt/nodejs/bin:${RBENV_ROOT}/shims:${RBENV_ROOT}/bin:${PATH}

# Install ruby; set version as global & install bundler
RUN rbenv install ${ruby_version} \
    && rbenv global ${ruby_version} \
    && gem install bundler

##
# Application Specifics
##

RUN apt-get update -qq \
    && apt-get install -y ruby-mysql2

# bundle gems in a separate volume & Add application binaries paths to PATH
ENV APP_HOME=/assessing-kubernetes \
    BUNDLE_GEMFILE=$APP_HOME/Gemfile \
    BUNDLE_JOBS="$(nproc)" \
    BUNDLE_PATH=/bundle \
    PATH=$APP_HOME/bin:$BUNDLE_PATH/bin:$PATH

# Update time zone & Create work directory
RUN ln -sf /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime \
    && dpkg-reconfigure -f noninteractive tzdata \
    && mkdir $APP_HOME

WORKDIR $APP_HOME

ADD . $APP_HOME
