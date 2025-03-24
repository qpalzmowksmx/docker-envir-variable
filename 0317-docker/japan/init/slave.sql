-- 사용자 생성 및 권한 부여
CREATE USER 'repl_user'@'%' IDENTIFIED BY '${MYSQL_REPL_PASSWORD}';
GRANT REPLICATION SLAVE ON *.* TO 'repl_user'@'%';

CREATE USER 'monitor_user'@'%' IDENTIFIED BY 'monitor_password';
GRANT SELECT ON *.* TO 'monitor_user'@'%';

CREATE USER 'exporter'@'%' IDENTIFIED BY 'exporter_password';
GRANT PROCESS, REPLICATION CLIENT ON *.* TO 'exporter'@'%';

FLUSH PRIVILEGES;

-- GTID 설정 적용
SET GLOBAL enforce_gtid_consistency = ON;
SET GLOBAL gtid_mode = ON;
SET GLOBAL master_info_repository = 'TABLE';
SET GLOBAL relay_log_info_repository = 'TABLE';
SET GLOBAL binlog_format = 'ROW';

-- 마스터와의 복제 설정
CHANGE MASTER TO
  MASTER_HOST='서울_마스터의_프라이빗_IP_주소',
  MASTER_USER='repl_user',
  MASTER_PASSWORD='${MYSQL_REPL_PASSWORD}',
  MASTER_AUTO_POSITION=1;

-- 복제 시작
START SLAVE;
