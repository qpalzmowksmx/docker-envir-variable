-- 복제를 위한 사용자 생성
CREATE USER 'repl_user'@'%' IDENTIFIED BY 'repl_password';
GRANT REPLICATION SLAVE ON *.* TO '${MYSQL_REPL_PASSWORD}'@'%';

-- 모니터링을 위한 사용자 생성
CREATE USER 'monitor_user'@'%' IDENTIFIED BY 'monitor_password';
GRANT SELECT ON *.* TO 'monitor_user'@'%';

-- Orchestrator 사용자 생성
CREATE USER 'orchestrator_user'@'%' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
GRANT SUPER, PROCESS, REPLICATION SLAVE, REPLICATION CLIENT ON *.* TO 'orchestrator_user'@'%';
GRANT SELECT ON mysql.* TO 'orchestrator_user'@'%';
GRANT ALL PRIVILEGES ON orchestrator.* TO 'orchestrator_user'@'%';

-- 권한 적용
FLUSH PRIVILEGES;

-- GTID 설정
SET GLOBAL enforce_gtid_consistency = ON;
SET GLOBAL gtid_mode = ON;
SET GLOBAL master_info_repository = 'TABLE';
SET GLOBAL relay_log_info_repository = 'TABLE';
SET GLOBAL binlog_format = 'ROW';

-- 마스터 연결 설정
CHANGE MASTER TO
  MASTER_HOST='mysql-master',
  MASTER_USER='repl_user',
  MASTER_PASSWORD='repl_password',
  MASTER_AUTO_POSITION=1;

-- 복제 시작
START SLAVE;

-- 복제 상태 확인
SHOW SLAVE STATUS\G
