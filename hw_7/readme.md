# Домашняя работа 7
## Ход работы

**Установить Nginx и настроить его на работу с php-fpm.**

установим nginx (как root)

>aptitude install nginx

Устанавливаем пакет php5-fpm

>aptitude install php5-fpm

Убедимся, что все готово к настройке, остановим сервисы nginx и php-fpm:

>/etc/init.d/nginx stop;

>/etc/init.d/php5-fpm stop;

Конфигурируем nginx

Создадим location c указанием на место php скриптов и параметры соединения с php-fpm (полный текст в sites.conf)

```
#в server {..} напишем:
#здесь можем пометить любое доменное имя. 
#В локльных целях можно заменить localhost на указанное здесь имя и #добавив правило mysite.com 127.0.0.1 в /etc/hosts
server_name mysite.com;
root /var/www/site/public;
#сконфигурируем php
location ~ \.php$ {
        try_files $uri = 404;
        include fastcgi_params;
        fastcgi_pass  unix:/var/run/php5-fpm.sock;
        fastcgi_index index.php;

        fastcgi_param  SCRIPT_FILENAME  $document_root$fastcgi_script_name;
    }
#порядок индексов
location /
{
    index  index.php index.html index.htm;
}
```


**Настроить Nginx в качестве балансировщика. Используя mod_upstream, раскидывать весь входящий трафик по трем Apache2-серверам, находящимся в локальной сети.**

Допустим, мы имеем 3 сервера apache2 находящиеся в одной подсети. Добавим в конфиг:

```
upstream backend {
    server 192.168.0.10:8080;
    server 192.168.0.11:8080;
    server 192.168.0.12:8080;
}
```

в настройках виртуального хоста добавим location запросы к которому мы будем распределять:

```
location / {
    proxy_pass http://backend/;
    proxy_set_header Host $host;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header X-Real-IP $remote_addr;
    }
```

Этого набора правил достаточно чтобы nginx уже начал раскидывать трафик между тремя машинами. Мы можем более детально настроить, добавив к каждому серверу в записи 

>max_fails=2 fail_timeout=10s;

Что означает если сервер недоступен дважды подряд, он будет выведен из работы на 10c

* weight Вес сервера. Чем он больше, тем будет больше запросов
* max_conns 0 - нет ограничения. Любое другое число указывает максимальное число активных соединений в момент времени
* max_fails Задаёт число неудачных попыток работы с сервером, которые должны произойти в течение времени, заданного параметром fail_timeout, чтобы сервер считался недоступным на период времени, также заданный параметром fail_timeout. Дефолтное значение — 1.
* fail_timeout Задаёт время, в течение которого должно произойти заданное число неудачных попыток работы с сервером для того, чтобы сервер считался недоступным и время, в течение которого сервер будет считаться недоступным. По умолчанию параметр равен 10 секундам.
* backup Помечает сервер как запасной сервер. На него будут передаваться запросы в случае, если не работают основные серверы.
* down Помечает сервер как постоянно недоступный.


**Настроить Nignx + ssl с использованием cert-manager (материал в доп ссылке в комментариях)**

Установим certbot:

```
sudo apt-get update
sudo apt-get install software-properties-common
sudo add-apt-repository universe
sudo add-apt-repository ppa:certbot/certbot
sudo apt-get update
sudo apt-get install certbot python-certbot-nginx
```
В автоматическом режиме добавим сертификат и сконфигурируем nginx

>sudo certbot --nginx

Если консервативных взглядов или в конфиге имеется много кастомной настройки и есть риск, что все поломается или не будет работать так, как планировалос, тогда лучше:

>sudo certbot certonly --nginx

В ответе мы получаем список:

```
`privkey.pem`  : the private key for your certificate.
`fullchain.pem`: the certificate file used in most server software.
`chain.pem`    : used for OCSP stapling in Nginx >=1.3.7.
`cert.pem`     : will break many server configurations, and should not be used
                 without reading further documentation (see link below).
```

далее, в конфиге nginx добавим: 
```
server {
    listen 80;
  server_name #доменное имя здесб
  return 301 https://$server_name$request_uri;
}

server {
  listen 443 ssl;
  server_name #доменное имя здесь

  ssl on;
  ssl_certificate /etc/nginx/ssl/canbyedfoundation_org-bundle.crt;
  ssl_certificate_key /etc/nginx/ssl/canbyedfoundation.org.key;
    .....
}

```

Установим периодическое обновление сертификата

>sudo certbot renew --dry-run
