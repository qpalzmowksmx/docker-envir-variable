-- repl용이랑 모니터링용 사용자 생성 및 권한 부여
CREATE USER 'repl_user'@'%' IDENTIFIED BY 'repl_password';
GRANT REPLICATION SLAVE ON *.* TO 'repl_user'@'%';

CREATE USER 'monitor_user'@'%' IDENTIFIED BY 'monitor_password';
GRANT SELECT ON *.* TO 'monitor_user'@'%';

-- Orchestrator용 데이터베이스 및 사용자 생성
CREATE DATABASE IF NOT EXISTS orchestrator;

CREATE USER 'orchestrator_user'@'%' IDENTIFIED BY 'orchestrator_password';
GRANT ALL PRIVILEGES ON orchestrator.* TO 'orchestrator_user'@'%';

FLUSH PRIVILEGES;

-- GTID 설정 확인
SET GLOBAL enforce_gtid_consistency = ON;
SET GLOBAL gtid_mode = ON;
SET GLOBAL master_info_repository = 'TABLE';
SET GLOBAL relay_log_info_repository = 'TABLE';
SET GLOBAL binlog_format = 'ROW';
