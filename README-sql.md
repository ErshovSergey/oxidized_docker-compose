# Для первоначального наполнения sqlite БД
sqlite3 "/home/oxidized/.config/oxidized/router.db.sql"  "create table nodes
  (fqdn TEXT, ipaddr TEXT, model TEXT, username TEXT, password TEXT, enable_password TEXT, group_devices TEXT, ssh_port);"

sqlite3 "/home/oxidized/.config/oxidized/router.db.sql"  "insert into
  nodes (fqdn, ipaddr, model, username, password, enable_password, group_devices, ssh_port)
  values ('k10.local', '192.168.1.1', 'routeros' ,'ssh' ,'ssh_pass','enable' , 'local', 22);"



