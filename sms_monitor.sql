create database moniror;
use monitor;
CREATE TABLE servers (
  server_id INT NOT NULL AUTO_INCREMENT,
  server_name VARCHAR(255) NOT NULL,
  ip_address VARCHAR(255) NOT NULL,
  port INT NOT NULL,
  PRIMARY KEY (server_id)
);

-- Create a table to store SMS notification information
CREATE TABLE notifications (
  notification_id INT NOT NULL AUTO_INCREMENT,
  server_id INT NOT NULL,
  message VARCHAR(255) NOT NULL,
  sent_at DATETIME NOT NULL,
  PRIMARY KEY (notification_id),
  FOREIGN KEY (server_id) REFERENCES servers (server_id)
);
-- Insert 11 values for the servers table
INSERT INTO servers (server_name, ip_address, port) VALUES
('Server1', '192.168.1.1', 80),
('Server2', '192.168.1.2', 8080),
('Server3', '192.168.1.3', 8081),
('Server4', '192.168.1.4', 8082),
('Server5', '192.168.1.5', 8083),
('Server6', '192.168.1.6', 8084),
('Server7', '192.168.1.7', 8085),
('Server8', '192.168.1.8', 8086),
('Server9', '192.168.1.9', 8087),
('Server10', '192.168.1.10', 8088);

-- Insert 11 values for the notifications table
INSERT INTO notifications (server_id, message, sent_at) VALUES
(1, 'Server1 notification 1', NOW()),
(2, 'Server2 notification 1', NOW()),
(3, 'Server3 notification 1', NOW()),
(4, 'Server4 notification 1', NOW()),
(5, 'Server5 notification 1', NOW()),
(6, 'Server6 notification 1', NOW()),
(7, 'Server7 notification 1', NOW()),
(8, 'Server8 notification 1', NOW()),
(9, 'Server9 notification 1', NOW()),
(10, 'Server10 notification 1', NOW());
-- Create a stored procedure to check the status of a server
DELIMITER $$
CREATE PROCEDURE check_server_status (
  IN server_id INT
)
BEGIN
  -- Check if the server is up and running
  DECLARE is_up BOOLEAN;
  SELECT COUNT(*) INTO is_up
  FROM servers
  WHERE server_id = server_id
  AND is_running = 1;

  -- If the server is not up and running, send an SMS notification
  IF is_up = 0 THEN
    INSERT INTO notifications (server_id, message, sent_at)
    VALUES (server_id, 'Server is down!', NOW());
  END IF;
END $$
DELIMITER ; 
CREATE EVENT hourly_check_server_status
ON SCHEDULE EVERY 1 HOUR
DO
  CALL check_server_status();