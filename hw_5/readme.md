# Домашняя работа 5
## Ход работы

**Произвести ручную настройку сети в Ubuntu используя nmcli или Ip и изменив файл /etc/network/interfaces. Для Ubuntu server использовать netplan.**
Вариант 1:

//dhcp
Включаем интерфейс

>sudo ip link set enp0s3 up

Запрашиваем ip

>sudo dhclient enp0s3

//static
Включаем интерфейс
>sudo ip link set enp0s3 up

Настраиваем

>sudo ip addr add 192.168.0.12/255.255.255.0 broadcast 192.168.0.255 dev enp0s3

Указываем шлюз

>sudo ip route add default via 192.168.0.1

Завершение: настроим dns

>echo 'dns-nameservers 8.8.8.8 4.4.4.4' >> /etc/network/interfaces

перезагружаем

>sudo service networking restart

Вариант 2:
1. С помощью *ifconfig* получим перечень интерфейсов. У нас имеется lo(loopback) - вирутальный, указывающий на машину
и enp0s3

2. Рассмотрим файл настроек

>cat /etc/network/interfaces

Имеем: 
>auto lo
>iface lo inet loopback

Первая строка указывает, что нужно активировать интерфейс при загрузке, вторая же определяет настройки самого интерфейса.

3. Добавим конфигурацию получения ip адреса через dhcp

auto enp0s3
iface enp0s3 inet dhcp

Cохраняем файл, перезапускаем интерфейс: 

>sudo service networking restart

4. Для статического адреса мы добавим в конфиг следующее: 

>auto eth0
>iface eth0 inet static
>address 192.168.0.12
>gateway 192.168.0.1
>netmask 255.255.255.0
>network 192.168.0.0
>broadcast 192.168.0.255

Cохраняем файл, перезапускаем интерфейс: 

>sudo service networking restart

**Настроить правила iptables, чтобы из внешней сети можно было обратиться только к портам 80 и 443. Запросы на порт 8080 перенаправлять на порт 80.**

разрешим подключение к портам

>sudo iptables -A INPUT -p tcp --dport 80 -j ACCEPT
>sudo iptables -A INPUT -p tcp --dport 443 -j ACCEPT

перенаправим Запрсы с 8080 на 80

>sudo iptables -t nat -A PREROUTING -p tcp --dport 8080 -j REDIRECT --to-port 80

и убедимся, что перенаправление работает

>sudo iptables -t nat -L

и запретим все остальное 

>sudo iptables -A INPUT -j DROP

**Дополнительно к предыдущему заданию настроить доступ по ssh только из указанной сети.**

В зависимости от конфигурации адресов локальной сети, доступ ограничить можно следующим способом

>iptables -A INPUT -p tcp -s 192.168.0.0/24 --dport 22 -j ACCEPT

где вместо 192.168.0.0 может быть, например 10.10.0.0

