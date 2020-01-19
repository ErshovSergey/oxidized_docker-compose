###  Установка  
```
git clone https://github.com/ErshovSergey/oxidized_docker-compose.git
cd oxidized_docker-compose
```
###  Настройка  
Скопировать файл
```
cp .env-default .env
cp router.db.csv-default  	router.db.csv
```
и настроить параметры и доступы к сетевым устройствам.   

### Команды
Создать контейнер
```
docker-compose up --build -d --remove-orphans --force-recreate
```
#### Удалить контейнер
```
docker-compose down --remove-orphans
```
#### Обновить образы  
```
docker pull jwilder/nginx-proxy:alpine
docker pull oxidized/oxidized
```
После обновления пересоздать контейнеры

### Получение конфигурации за маршрутизатором Mikrotik
#### Подготовка маршрутизатора Mikrotik
Внутри контейнера oxidized cоздаем ключ (docker exec -i -t [name_of_container] bash) и копируем закрытый ключ внутрь контенера
```
ssh-keygen -t dsa -N '' -C oxidized-key -f /root/.config/oxidized/.ssh/id_dsa
cp /root/.config/oxidized/.ssh/id_dsa /root/.ssh/
```

#### На маршрутизаторе Mikrotik  
Открытый ключ [${DATA_FOLDER_PATH}/oxidized-docker/.ssh/id_dsa.pub] копируем на маршрутизатор.  
Создаем пользователя на маршрутизаторе (только для чтения, сложный пароль)  
```
user add name=[ssh_user] group=read
```
Назначаем ключ пользователю  
```
/user ssh-keys import user=[ssh_user] public-key-file=[d_dsa.pub]
```
Разрешаем forwarding  
```
/ip ssh set forwarding-enabled=local
```
#### На хосте за маршрутизатором Mikrotik  
Создаем пользователя [ssh_user inside] на хосте внутри сети (только для чтения [сложный пароль])   
Строка (в файле *router.db.csv*) для получения конфига   
```
[unic_name]:[ip адрес хоста внутри сети]:routeros:[ssh_user inside]:[пароль для ssh_user inside]:empty:group_1:[порт ssh на хосте внутри сети]:[ssh_user]@[ip маршрутизатора]:[порт ssh на маршрутизаторе]
```
Проверка (из контейнера)  
- авторизацию по ключу, должна пройти без ключа на маршрутизатор  
```
ssh -o StrictHostKeyChecking=no -p [порт ssh на маршрутизаторе] [ssh_user]@[ip маршрутизатора]
```
- авторизацию на внутренем узле, должна пройти с приглшением ввода пароля на внутренний узел  
```
ssh -o StrictHostKeyChecking=no -o ProxyCommand="ssh -W %h:%p [ssh_user inside]@[ip адрес хоста внутри сети] -p [порт ssh на хосте внутри сети]" [ssh_user]@[ip маршрутизатора] -p [порт ssh на маршрутизаторе]
```

### Авторизация Basic access authentication  
Необходимо поместить файл в формате .htpasswd в папку ${DATA_FOLDER_PATH}/htpasswd/ с названием ${VIRTUAL_HOST}  

### Ссылки
nginx+ldap
https://github.com/ytti/oxidized/issues/784#issuecomment-289759880
