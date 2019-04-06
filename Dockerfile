FROM ubuntu:14.04
ENV PROD_APP_HOST="billing.dvd.dev" \
    PROD_APP_PROT="http" \
    PROD_AM_BILLING_MODE="test" \
    PROD_DEMO_MODE="false" \
    PROD_WKHTMLTOPDF_PATH="" \
    PROD_ENCRYPTION_KEY="" \
    PROD_PP_URL="https://www.sandbox.paypal.com/cgi-bin/webscr?" \
    PROD_PP_LOGIN="me@dvd.dev" \
    PROD_PP_PASSWORD="mypassword" \
    PROD_PP_SIGNATURE="Thank you very much" \
    PROD_PP_BUSINESS="DVD.DEV" \
    PROD_SMTP_ADDRESS="smtp.gmail.com" \
    PROD_SMTP_PORT="587" \
    PROD_SMTP_AUTH=":plain" \
    PROD_SMTP_STARTTLS_AUTH="true" \
    PROD_SMTP_LOGIN="me@dvd.dev" \
    PROD_SMTP_PASSWORD="mypassword" \
    PROD_QB_KEY="mykey" \
    PROD_QB_SECRET="secret" \
    DB_HOST="localhost" \
    DB_USERNAME="root" \
    DB_PASSWORD="q1w2e3" \
    DB_NAME="osb"

RUN set -ex; \
  savedAptMark="$(apt-mark showmanual)"; \
  apt-get update; \
  DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
  software-properties-common \
  language-pack-en-base \
  mysql-client \
  libmysqlclient-dev \
  git \
  git-core \
  curl \
  zlib1g-dev \
  build-essential \
  libssl-dev \
  sudo \
  wkhtmltopdf \
  libreadline-dev \
  libyaml-dev \
  libsqlite3-dev \
  sqlite3 \
  libxml2-dev \
  libxslt1-dev \
  libcurl4-openssl-dev \
  python-software-properties \
  libffi-dev \
  libncurses5-dev \
  automake \
  libtool \
  bison \
  libffi-dev \
  imagemagick \
  libmagickcore-dev \
  libmagickwand-dev \
  libicu-dev && \
  locale-gen en_US.UTF-8 && \
  export LANG=en_US.UTF-8 && \
  export LC_ALL=en_US.UTF-8  && \
  LC_ALL=C.UTF-8 add-apt-repository ppa:ondrej/php && \
  useradd -ms /bin/bash osb && \
  echo "osb ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/osb && \
  mkdir -p /srv/osb && \
  chown osb /srv/osb

USER osb
RUN set -ex; \
  gpg --keyserver hkp://pool.sks-keyservers.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB && \
  bash -c "curl -L https://get.rvm.io | bash -s stable && \
  source /home/osb/.rvm/scripts/rvm && \
  rvm install 2.3.7 && \
  cd /srv/osb && rvm use 2.3.7 --default  && gem install bundler -v 1.17.3 && \
  gem uninstall -i /home/osb/.rvm/gems/ruby-2.3.7@global bundler -v 2.0.1 && \
  git clone https://github.com/vteams/open-source-billing /srv/osb && \
  cd /srv/osb && \
  gem install bundler -v 1.17.3 && \
  bundle install"

ADD start_osb.sh /srv/osb/
WORKDIR /srv/osb
CMD ["/srv/osb/start_osb.sh"]
EXPOSE 3000
LABEL org.label-schema.name="DVD-OSB" \
      org.label-schema.vendor="DVD.DEV" \
      org.label-schema.license="Apache-2.0" \
      org.label-schema.docker.schema-version="1.0"
