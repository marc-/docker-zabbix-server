#!/bin/sh

_file_marker=".mysql-configured"

if [ "x$DB_ENV_MYSQL_PASS" != "x"  ]; then
  MYSQL_PASS=$DB_ENV_MYSQL_PASS
fi
if [ "x$DB_ENV_MYSQL_PASSWORD" != "x"  ]; then
  MYSQL_PASS=$DB_ENV_MYSQL_PASSWORD
fi
if [ "x$DB_ENV_MYSQL_USER" != "x"  ]; then
  MYSQL_USER=$DB_ENV_MYSQL_USER
fi
if [ "x$DB_PORT_3306_TCP_ADDR" != "x"  ]; then
  MYSQL_HOST=$DB_PORT_3306_TCP_ADDR
fi
if [ "x$DB_PORT_3306_TCP_PORT" != "x"  ]; then
  MYSQL_PORT=$DB_PORT_3306_TCP_PORT
fi

export MYSQL_PASS
export MYSQL_USER
export MYSQL_HOST
export MYSQL_PORT

if [ ! -f "$_file_marker" ]; then
  echo "mysql root and admin password: $MYSQL_PASS"

  echo "$MYSQL_PASS" > /mysql-root-pw.txt

  mysql -h$MYSQL_HOST -P$MYSQL_PORT -u$MYSQL_USER -p"$MYSQL_PASS" -e "CREATE DATABASE IF NOT EXISTS zabbix CHARACTER SET utf8;"

  zabbix_mysql_v="/usr/share/zabbix/database/mysql"

  mysql -h$MYSQL_HOST -P$MYSQL_PORT -u$MYSQL_USER -D zabbix -p"$MYSQL_PASS" < "${zabbix_mysql_v}/schema.sql"

  mysql -h$MYSQL_HOST -P$MYSQL_PORT -u$MYSQL_USER -D zabbix -p"$MYSQL_PASS" < "${zabbix_mysql_v}/images.sql"

  mysql -h$MYSQL_HOST -P$MYSQL_PORT -u$MYSQL_USER -D zabbix -p"$MYSQL_PASS" < "${zabbix_mysql_v}/data.sql"

  touch "$_file_marker"
fi

sed -e "s/^\(DBHost=\).*/\1$MYSQL_HOST/g" \
    -e "s/^\(DBPort=\).*/\1$MYSQL_PORT/g" \
    -e "s/^\(DBUser=\).*/\1$MYSQL_USER/g" \
    -e "s/^\(DBPassword=\).*/\1$MYSQL_PASS/g" -i /etc/zabbix/zabbix_server.conf

rm -f /var/run/httpd.pid

/usr/sbin/zabbix_server -c /etc/zabbix/zabbix_server.conf
/usr/sbin/zabbix_agentd -c /etc/zabbix/zabbix_agentd.conf
/usr/sbin/httpd -DFOREGROUND
