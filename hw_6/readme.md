# Домашняя работа 6
## Ход работы

**Настроить виртуальный сервер в облаке (GCP, AWS, VDS и др.) с публичным IP-адресом.**

Регистрируемся и переходим в панель управления. В крайней левой колонке выбираем Compute Engine -> Экземпляр ВМ. Далее идем по шагам мастера установщика - Выибраем железо, Ос, разрешаем http/https трафик, добавляем ssh ключ.

Должно пройти какое-то время, прежде чем машина будет запущена

После этого, мы тут же можем подключиться к машине по ssh для проверки и дальнейшей настройки

Далее перейдем в раздел сеть-VPC и зарезервируем наш внешний ip как статический

**Зарегистрировать свой домен через freenom.com.**

В данный момент сервис не функционален. 

**Настроить фаервол, чтобы был доступ только к сервисам http и ssh.**

GCP по-умолчанию блокирует трафик из-вне. Мы можем разраешить доступ по http/https в рамках создания ВМ. Но как альтернатива, можно использовать *ufw*

>sudo ufw enable

>sudo ufw default deny incoming

>sudo ufw allow from any to any port 22,80,443 proto tcp

>sudo ufw status verbose

Пояснение: запускаем фаервол, далее блокируем весь входящий трафик, 
разрешаем доступ к ssh, http, https, проверяем, что правила приенились.

**Установить веб-сервер Nginx и подключиться к нему — прислать скриншот.**

Добавим репозиторий, чтобы получать свежие обновления nginx

>sudo apt-add-repository ppa:nginx/stable

Обновим списки пакетов и установим nginx

>sudo apt update
>sudo apt install nginx

добавим nginx в автозагрузку
>sudo apt install nginx

запустим

>sudo service nginx start

проверяем: 

>sudo systemctl status nginx

!['Вывод команды в консоли'](https://www.screencast.com/t/cUefCdRHS53Y)
!['Скрин окна браузера'](https://www.screencast.com/t/F26cwQFeQy)

**Передать управление NS-записями на cloudflare.com**

Пока сервис freenom не функционален, нет возможности выполнить этот пункт. 


