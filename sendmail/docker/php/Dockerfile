FROM php:7.2.3-alpine3.7

RUN apk update && apk add msmtp

COPY docker/php/etc/msmtprc /etc/msmtprc
COPY docker/php/usr/local/etc/php/conf.d/sendmail.ini /usr/local/etc/php/conf.d/sendmail.ini

COPY . /work
WORKDIR /work

CMD php -S 0.0.0.0:80 -t public
ENTRYPOINT php -S 0.0.0.0:80 -t public
