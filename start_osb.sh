#!/bin/bash
source /home/osb/.rvm/scripts/rvm
rm -f /srv/osb/tmp/pids/server.pid
cd /srv/osb
export RAILS_ENV=production
echo "production:
  adapter: mysql2
  encoding: utf8 
  reconnect: true
  database: $DB_NAME
  pool: 5
  username: $DB_USERNAME
  password: $DB_PASSWORD
  host: $DB_HOST" > /srv/osb/config/database.yml

rake secret > /srv/osb/.rakesecret
echo "production:
  app_host: $PROD_APP_HOST
  app_protocol: $PROD_APP_PROT
  activemerchant_billing_mode: $PROD_AM_BILLING_MODE
  wkhtmltopdf_path: $(which wkhtmltopdf)
  encryption_key: $(cat /srv/osb/.rakesecret)
  paypal:
    url: $PROD_PP_URL 
    login: $PROD_PP_LOGIN
    password: $PROD_PP_PASSWORD
    signature: $PROD_PP_SIGNATURE
    business: $PROD_PP_BUSINESS

  smtp_setting:
    address: $PROD_SMTP_ADDRESS
    port: $PROD_SMTP_PORT
    authentication: $PROD_SMTP_AUTH
    enable_starttls_auto: $PROD_SMTP_STARTTLS_AUTH
    user_name: $PROD_SMTP_LOGIN
    password: $PROD_SMTP_PASSWORD

  quickbooks:
    consume_key: $PROD_QB_KEY
    consumer_secret: $PROD_QB_SECRET" > /srv/osb/config/config.yml

if [[ $(mysql -u $DB_USERNAME -p${DB_PASSWORD} -h $DB_HOST -D $DB_NAME -e "show table status;" | wc -l) -eq 0 ]]; then
 rake db:create
 rake db:migrate
 rake db:seed
fi
bin/delayed_job start
rails server -b0.0.0.0
