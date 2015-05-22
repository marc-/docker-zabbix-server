<?php
// Zabbix GUI configuration file
global $DB;

$DB["TYPE"]          = 'MYSQL';
$DB["SERVER"]   = getenv("MYSQL_HOST");
$DB["PORT"]          = getenv("MYSQL_PORT");
$DB["DATABASE"]   = 'zabbix';
$DB["USER"]    = getenv("MYSQL_USER");
$DB["PASSWORD"]   = getenv("MYSQL_PASS");
// SCHEMA is relevant only for IBM_DB2 database
$DB["SCHEMA"]   = '';

$ZBX_SERVER          = 'localhost';
$ZBX_SERVER_PORT  = '10051';
$ZBX_SERVER_NAME  = '';

$IMAGE_FORMAT_DEFAULT = IMAGE_FORMAT_PNG;
?>
