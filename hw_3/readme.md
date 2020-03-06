# Домашняя работа 2
## Ход работы

**Создать файл file1 и наполнить его произвольным содержимым.**

>touch file1
>ls -la >> file1

**Скопировать его в file2. Создать символическую ссылку file3 на file1.**

>cp file1 file2
>ln -s file1 file3

**Создать жесткую ссылку file4 на file1.**

>ln file1 file4

**Посмотреть, какие айноды у файлов**
Айноды у файлов полностью совпадают

**Удалить file1. Что стало с остальными созданными файлами? Попробовать вывести их на экран.**

>rm file1

В случае с символьной ссылкой, мы получим сообщение, что файл не найден, в случае с жесткой ссылкой мы сможем открыть и прочитать содержимое

**Создать два произвольных файла. Первому присвоить права на чтение, запись для владельца и группы, только на чтение — для всех. Второму присвоить права на чтение, запись — только для владельца. Сделать это в численном и символьном виде.**

>touch sample_file1
>touch sample_file2

>chmod 664 sample_file1 
>chmod 600 sample_file2

или

>chmod ug=rw,o=r sample_file1 
>chmod u=rw sample_file2

**Создать пользователя, обладающего возможностью выполнять действия от имени суперпользователя.**

>sudo useradd randomuser

>usermod -aG sudo randomuser

**Создать группу developer и несколько пользователей, входящих в нее. Создать директорию для совместной работы. Сделать так, чтобы созданные одними пользователями файлы могли изменять другие пользователи этой группы.**

*Cоздадим группу и добавим в нее пользователей*

>sudo groupadd developer
>sudo useradd backend-developer -g developer
>sudo useradd frontent-developer -g developer
>sudo useradd devops-engineer -g developer

*создадим общую папку для группы*
*и все созданные здесь файлы будут доступны для работы членам группы 2-новые файлы будут получать ту группу, в которой они находятся*

>mkdir /var/share
>sudo chgrp -R developer /var/share
>sudo chmod -R 2775 /var/share

**Создать в директории для совместной работы поддиректорию для обмена файлами, но чтобы удалять файлы могли только их создатели.**

>mkdir /var/share/file_transfer
>sudo chmod g+t /var/share/file_transfer 

**Создать директорию, в которой есть несколько файлов. Сделать так, чтобы открыть файлы можно было, только зная имя файла, а через ls список файлов посмотреть было нельзя**

>mkdir /home/randomdir
>touch /home/randomdir/file1
>touch /home/randomdir/file2
>touch /home/randomdir/file3

скроет из листинга ls, но при опции -а/-А выведет

>mv /home/randomdir/file1 /home/randomdir/.file1
>mv /home/randomdir/file2 /home/randomdir/.file2
>mv /home/randomdir/file3 /home/randomdir/.file3
