###  Установка  
```
git clone https://github.com/ErshovSergey/oxidized_docker-compose.git
cd oxidized_docker-compose
```
###  Настройка  
Скопировать файлы
```
cp .env-default .env
cp router.db.csv-default  	router.db.csv
```
Если в инфраструктуре есть оборудование от Dlink - то может понадобится
```
cp ssh_config.dlink-default ssh_config.dlink
```
и настроить параметры (*.env*) контейнера и доступы (*router.db.csv*) к сетевым устройствам, basic аутентификация настраивается в файле htpasswd, по умолчанию *логин/пароль admin/admin*.   
В дальнейшем добавлять устройства для бекапа необходимо в *${DATA_FOLDER_PATH}/oxidized-docker/router.db.csv*, basic аутентификация в файле настраивается в файле *${DATA_FOLDER_PATH}/htpasswd/${VIRTUAL_HOST}*.
### Адрес для доступа к консоли  
*http://${VIRTUAL_HOST}*  
### Команды
#### Создать контейнер  
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
Необходимо сохранять файлы для авторизации на устройствах по сертификату  
```
${DATA_FOLDER_PATH}/oxidized-docker/.ssh/id_dsa
${DATA_FOLDER_PATH}/oxidized-docker/.ssh/id_dsa.pub
${DATA_FOLDER_PATH}/oxidized-docker/.ssh/oxidized-key.key
${DATA_FOLDER_PATH}/oxidized-docker/.ssh/oxidized-key.key.pub
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
Проверка (из контейнера oxidized)  
- авторизация по ключу, должна пройти без ключа на маршрутизатор  
```
ssh -o StrictHostKeyChecking=no -p [порт ssh на маршрутизаторе] [ssh_user]@[ip маршрутизатора]
```
- авторизацию на внутренем узле должна пройти по сертификату с последующим приглашением ввода пароля на внутренний узел  
```
ssh -o StrictHostKeyChecking=no -o ProxyCommand="ssh -W %h:%p [ssh_user inside]@[ip адрес хоста внутри сети] -p [порт ssh на хосте внутри сети]" [ssh_user]@[ip маршрутизатора] -p [порт ssh на маршрутизаторе]
```

#### Коммутаторы Dlink - особенности
Коммутаторы от Dlink - имеют ряд особенностей.
Разные линейки коммутаторов имеют разный CLI, т.е. команды CLI для разных линеек - разные.
Для каждой линейки необходимо использовать свою настройку - подробности в папке new-devises.
Также для работы черезе ssh для разных линеек необходимо использовать свой набор криптоалгоритмов - подробнее в файле ssh_config.dlink-default.

### Ссылки
nginx+ldap
https://github.com/ytti/oxidized/issues/784#issuecomment-289759880
