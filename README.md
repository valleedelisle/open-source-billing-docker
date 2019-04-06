# open-source-billing-docker
Dockerization of [open-source-billing](https://github.com/vteams/open-source-billing)

# Build container

1. Clone repository
```
$ git clone git@github.com:valleedelisle/open-source-billing-docker.git && cd open-source-billing-docker
```

2. Docker build the image
```
$ docker build -t osb .
```

3. Start the container
```
$ docker run -d \
       -e PROD_APP_HOST="billing.dvd.dev" \
       -e PROD_APP_PROT="http" \
       -e PROD_AM_BILLING_MODE="test" \
       -e PROD_DEMO_MODE="false" \
       -e PROD_WKHTMLTOPDF_PATH="" \
       -e PROD_ENCRYPTION_KEY="" \
       -e PROD_PP_URL="https://www.sandbox.paypal.com/cgi-bin/webscr?" \
       -e PROD_PP_LOGIN="me@dvd.dev" \
       -e PROD_PP_PASSWORD="mypassword" \
       -e PROD_PP_SIGNATURE="Thank you very much" \
       -e PROD_PP_BUSINESS="DVD.DEV" \
       -e PROD_SMTP_ADDRESS="smtp.gmail.com" \
       -e PROD_SMTP_PORT="587" \
       -e PROD_SMTP_AUTH=":plain" \
       -e PROD_SMTP_STARTTLS_AUTH="true" \
       -e PROD_SMTP_LOGIN="me@dvd.dev" \
       -e PROD_SMTP_PASSWORD="mypassword" \
       -e PROD_QB_KEY="mykey" \
       -e PROD_QB_SECRET="secret" \
       -e DB_HOST=172.17.0.1 \
       -e DB_NAME=osb \
       -e DB_USERNAME=osb \
       -e DB_PASSWORD=mypassword \
       --name osb \
       --hostname osb \
       -p 8083:3000 \
       osb
``` 

4. Profit
