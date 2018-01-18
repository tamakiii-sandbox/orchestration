FROM httpd:2.4-alpine

COPY ./usr/local/apache2/conf/httpd.conf /usr/local/apache2/conf/httpd.conf

RUN { \
  echo 'LoadModule proxy_module modules/mod_proxy.so'; \
  echo 'LoadModule proxy_fcgi_module modules/mod_proxy_fcgi.so'; \
  echo ''; \
  echo 'DirectoryIndex index.php index.html'; \
  echo '<FilesMatch \.php$>'; \
  echo '    CGIPassAuth On'; \
  echo '    SetHandler "proxy:fcgi://php:9000"'; \
  echo '</FilesMatch>'; \
} >> /usr/local/apache2/conf/httpd.conf

