FROM httpd:2.4-alpine

COPY ./usr/local/apache2/conf/httpd.conf /usr/local/apache2/conf/httpd.conf
COPY ./usr/local/apache2/conf/extra/proxy-php.conf /usr/local/apache2/conf/extra/proxy-php.conf

RUN mkdir -p /repository/symfony-4.0/public
